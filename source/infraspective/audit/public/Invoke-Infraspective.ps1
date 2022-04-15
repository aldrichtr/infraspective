
function Invoke-Infraspective {
    <#
    .SYNOPSIS
        Perform an audit on the specified hosts
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "Low"
    )]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('PsPath')]
        [String[]]$Path,

        # Alternate configuration file
        [Parameter(
        )]
        [string]$Configuration,

        # Discover audit controls, but do not run them
        [Parameter(
        )]
        [switch]$DiscoverOnly
    )

    begin {

        $c = Import-Configuration
        $c.PSTypeName = 'Infraspective.Configuration'
        $config = [PSCustomObject]$c

        $AuditState = New-InfraspecAuditState

        $AuditState.Configuration = $config
        $AuditState.SessionState = $PSCmdlet.SessionState
        $logging = $config.Logging
        foreach ($target in $logging.Keys) {
            Add-LoggingTarget -Name $target -Configuration $logging[$target]
        }
        Write-Log -Level INFO -Message "************ Starting ********************"
    }
    process {
        Write-Log -Level INFO -Message "Generating file list"
        if ($null -eq $PSItem) {
            Write-Log -Level DEBUG -Message "No paths from the pipeline"
            $pathsFromPipeline = $false
            if ($Path.Count -gt 1) {
                Write-Log -Level DEBUG -Message "Multiple paths specified in -Path"
            }
        } else {
            $pathsFromPipeline = $true
        }
        <#------------------------------------------------------------------
        Discovery phase
        ------------------------------------------------------------------#>
        $AuditState.Discovery = $true

        $audit_files = Get-ChildItem -Path $Path -Filter $config.Audit.Filter
        Write-Log -Level DEBUG -Message "Found $($audit_files.Count) audit files"
        $AuditState.AuditTimer.Restart()
        foreach ($f in $audit_files) {
            Write-Log -Level DEBUG -Message "Discovering tests in $($f.Name)"
            $content = Get-Content $f.FullName
            $sb = { . $f.FullName }
            $result = & $sb
            $result.Container = $f

            $audit = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Audit'
                Name       = $f.BaseName -replace '\.[aA]udit' , ''
                Result     = $result
                Block      = $sb
            }

            if ($DiscoverOnly) {
                Write-Output $audit
            } else {
                $AuditState.Stack.Push($audit)
            }
        }
        Write-Log -Level INFO -Message (
            "Discovery phase complete. {0} Files in {1:N4} milliseconds" -f
            $AuditState.Stack.Count, $AuditState.AuditTimer.Elapsed.MilliSeconds)

        <#------------------------------------------------------------------
          Run phase
          If `-DiscoverOnly` was specified, there wont be any objects on the
          stack, so the below foreach will be skipped.
        ------------------------------------------------------------------#>

        $AuditState.Discovery = $false
        foreach ($discovered in $AuditState.Stack) {
            Write-Log -Level DEBUG -Message "Running: $($discovered.Name)"
            & $discovered.Block | Foreach-Object {
                $run = $_
                Write-Log -Level DEBUG -Message "Returned a '$($run.GetType())'"
                Write-Output $run
            }
        }
    }
    end {
        Write-Log -Level INFO -Message (
            "Audit complete.  Total time {0:N4} milliseconds" -f
            $AuditState.AuditTimer.Elapsed.MilliSeconds)
    }
}

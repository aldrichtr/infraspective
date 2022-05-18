

function Invoke-Infraspective {
    <#
    .SYNOPSIS
        Perform an audit on the specified hosts
    .DESCRIPTION
        Run checklists, groupings and controls in files specified in the configuration.
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "Low"
    )]
    param(
        [Parameter(
        )]
        [String[]]$Path,

        # Alternate configuration file
        [Parameter(
        )]
        [string]$Configuration
    )

    begin {
        try {
            $c = Import-Configuration
            $c.PSTypeName = 'Infraspective.Configuration'
            $config = [PSCustomObject]$c
        } catch {
            Write-Error "There was an error loading the configuration`n$_" -ErrorAction Stop
        }

        $audit_state = New-InfraspecAuditState
        $audit_state.Configuration = $config
        $audit_state.SessionState = $PSCmdlet.SessionState
        $logging = $config.Logging
        foreach ($target in $logging.Keys) {
            Add-LoggingTarget -Name $target -Configuration $logging[$target]
        }
        Write-Log -Level INFO -Message "Logging initialized on $($logging.Keys -join ', ')"
        $TotalCount = 0
        $FailedCount = 0
        $PassedCount = 0
        $SkippedCount = 0
    }
    process {
        Write-Log -Level INFO -Message "Generating file list"

        $file_options = $config.Audit

        if ($PSBoundParameters['Path']) {
            $file_options.Path = $Path
        }
        Write-Log -Level DEBUG -Message " - Path: $($file_options.Path)"
        Write-Log -Level DEBUG -Message " - Filter: $($file_options.Filter)"
        Write-Log -Level DEBUG -Message " - Include: $($file_options.Include)"
        Write-Log -Level DEBUG -Message " - Exclude: $($file_options.Exclude)"
        Write-Log -Level DEBUG -Message " - Recurse: $($file_options.Recurse)"
        $audit_files = Get-ChildItem @file_options
        Write-Log -Level DEBUG -Message "Found $($audit_files.Count) audit files"
        $audit_state.AuditTimer.Restart()

        Write-Log -Level INFO -Message "Audit start"
        Write-Result Audit 'Start' "Audit $(Get-Date -Format 'dd-MMM-yyyy HH:mm:ss')"
        foreach ($f in $audit_files) {
            if ($PSCmdlet.ShouldProcess($f, "Perform tests")) {
                $audit_state.Depth += 1
                $audit_state.CurrentPath = $f.Directory.FullName
                Write-Log -Level INFO -Message "File $($f.Name) start"
                Write-Result File 'Start' "File $($f.Name)"
                [scriptblock]$sb = { . $f.FullName }
                Write-Log -Level DEBUG -Message " Executing Audit file $($f.Name)"
                $result = & $sb
                $result.Container = $f
                $audit_state.Depth -= 1
                Write-Log -Level INFO -Message "File $($f.Name) complete"
                $TotalCount += $result.TotalCount
                $PassedCount += $result.PassedCount
                $FailedCount += $result.FailedCount
                $SkippedCount += $result.SkippedCount

                Write-Output $result
            }
        }

    }
    end {
        $message = (
            "Audit complete.  Total files {0} executed in {1:N4} milliseconds" -f $audit_files.Count,
            $audit_state.AuditTimer.Elapsed.MilliSeconds)
        Write-Result Audit 'End' $message -Stats @{
            Total   = $TotalCount
            Passed  = $PassedCount
            Failed  = $FailedCount
            Skipped = $SkippedCount
        }
        Write-Log -Level INFO -Message $message
    }
}

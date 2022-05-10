

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
        }
        catch {
            Write-Error "There was an error loading the configuration`n$_" -ErrorAction Stop
        }

        $AuditState = New-InfraspecAuditState
        $AuditState.Configuration = $config
        $AuditState.SessionState = $PSCmdlet.SessionState
        $logging = $config.Logging
        foreach ($target in $logging.Keys) {
            Add-LoggingTarget -Name $target -Configuration $logging[$target]
        }
        Write-Log -Level INFO -Message "Logging initialized on $($logging.Keys -join ', ')"
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
        $AuditState.AuditTimer.Restart()

        Write-Log -Level INFO -Message "Audit start"
        foreach ($f in $audit_files) {
            Write-Log -Level INFO -Message "File $($f.Name) start"
            [scriptblock]$sb = { . $f.FullName }
            Write-Log -Level DEBUG -Message " Executing Audit file $($f.Name)"
            $result = & $sb
            $result.Container = $f
            Write-Log -Level INFO -Message "File $($f.Name) complete"
            Write-Output $result
        }
    }
    end {
        Write-Log -Level INFO -Message (
            "Audit complete.  Total files {0} executed in {1:N4} milliseconds" -f $audit_files.Count,
            $AuditState.AuditTimer.Elapsed.MilliSeconds)
    }
}

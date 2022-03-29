
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
        # Path to the Infraspective Checklists folder
        [Parameter(
            Position = 0
        )]
        [string]$Path
    )

    begin {
        $config = Import-Configuration
        $logging = $config.Logging
    }
    process {
        if ($PSCmdlet.ShouldProcess($Path)) {
            foreach ($target in $logging.Keys) {
                Add-LoggingTarget -Name $target -Configuration $logging[$target]
            }

            Write-Log -Level INFO -Message "$($MyInvocation.MyCommand.Name) Starting"
            Write-Log -Level DEBUG -Message "Looking for audit files in $($Path) using Filter $($config.Checklist.Filter)"
            $audit_files = Get-ChildItem -Path $Path -Filter $config.Checklist.Filter
            Write-Log -Level DEBUG -Message "Found $($audit_files.Count) audit files"
            foreach ($f in $audit_files) {
                Write-Log -Level DEBUG -Message "Running audit $($f.Name)"
                & $f.FullName | Write-Output
            }
            Write-Log -Level INFO -Message "$($MyInvocation.MyCommand.Name) Complete"
        } else {
            $lgs = $config.Logging.Keys
            if ($lgs.Count -gt 0) {
                $msg = "Logging to:`n"
                foreach ($k in $lgs) {
                    $msg += " - $k"
                    $msg += $config.Logging.$k.Path ? " Path: $($config.Logging.$k.Path)" : " "
                    $msg += "Level: $($config.Logging.$k.Level)"
                    $msg += "`n"
                }
                Write-Output $msg
            }
        }
    }
    end {
    }
}

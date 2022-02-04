
function Invoke-Infraspective {
    <#
    .SYNOPSIS

    #>
    [CmdletBinding()]
    param(
        # Path to the Infraspective Checklists folder
        [Parameter(
        )]
        [string]
        $Path
    )

    begin {
        $config = Import-Configuration
        $logging = $config.Logging
        foreach ($target in $logging.Keys) {
            Add-LoggingTarget -Name $target -Configuration $logging[$target]
        }
        Write-Log -Level INFO -Message "$($MyInvocation.MyCommand.Name) Starting"

    }
    process {
        Write-Log -Level DEBUG -Message "Looking for audit files in $($Path) using Filter $($config.Checklist.Filter)"
        $audit_files = Get-ChildItem -Path $Path -Filter $config.Checklist.Filter
        Write-Log -Level DEBUG -Message "Found $($audit_files.Count) audit files"
        foreach ($f in $audit_files) {
            Write-Log -Level DEBUG -Message "Running audit $($f.Name)"
            & $f.FullName | Write-Output
        }
    }
    end {
        Write-Log -Level INFO -Message "$($MyInvocation.MyCommand.Name) Complete"
    }
}

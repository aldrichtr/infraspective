
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
        [String[]]$Path
    )

    begin {

        $c = Import-Configuration
        $c.PSTypeName = 'Infraspective.Configuration'
        $config = [PSCustomObject]$c

        $AuditState = New-InfraspecAuditState

        $AuditState.Configuration = $config
        $AuditState.SessionState = $PSCmdlet.SessionState
        $logging = $config.Logging

        $Files = @()
    }
    process {
        $AuditState.Discovery = $true
        foreach ($target in $logging.Keys) {
            Add-LoggingTarget -Name $target -Configuration $logging[$target]
        }

        Write-Log -Level INFO -Message "$($MyInvocation.MyCommand.Name) Starting"
        Write-Log -Level DEBUG -Message "Looking for audit files in $($Path) using Filter $($config.Audit.Filter)"
        $audit_files = Get-ChildItem -Path $Path -Filter $config.Audit.Filter
        Write-Log -Level DEBUG -Message "Found $($audit_files.Count) audit files"
        foreach ($f in $audit_files) {
            Write-Log -Level DEBUG -Message "Running audit $($f.Name)"
            & $f.FullName | Write-Output
        }
        Write-Log -Level INFO -Message "$($MyInvocation.MyCommand.Name) Complete"
    }
    end {
    }
}


function New-InfraspecAuditState {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(

    )
    begin {
    }
    process {
        if ($PSCmdlet.ShouldProcess('AuditState', 'Initialize timers')) {
            #TODO: is there a reason not to create the state variable?
        }
        $auditState = [PSCustomObject]@{
            PSTypeName    = 'Infraspective.AuditState'
            Depth         = 0
            Discovery     = $false
            Configuration = $null
            CurrentBlock  = $null
            CurrentPath   = $null
            SessionState  = $null
            Functions     = @{}
            Variables     = [System.Collections.Generic.List[PSVariable]]@()
            Arguments     = @()
            Stack         = [System.Collections.Stack]@()

            AuditTimer    = [System.Diagnostics.Stopwatch]::StartNew()
        }
    }
    end {
        $auditState.AuditTimer.Restart()
        $auditState
    }
}

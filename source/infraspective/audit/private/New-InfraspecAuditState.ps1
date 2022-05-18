
function New-InfraspecAuditState {
    <#
    .SYNOPSIS
        Create a new State object to keep track of the current state of an Audit.
    .DESCRIPTION
        The state object is used to store and track the current audit variables and values
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

                AuditTimer = [System.Diagnostics.Stopwatch]::StartNew()
            }
        }

    }
    end {
        $auditState.AuditTimer.Restart()
        $auditState
    }
}

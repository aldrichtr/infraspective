
function New-InfraspecAuditState {
    <#
    .SYNOPSIS
        Create a new State object to keep track of the current state of an Audit.
    #>
    [CmdletBinding()]
    param(

    )
    begin {
    }
    process {
        $auditState = [PSCustomObject]@{
            PSTypeName    = 'Infraspective.AuditState'
            Depth         = 0
            Discovery     = $false
            Configuration = $null
            CurrentBlock  = $null
            SessionState  = $null
            Functions     = @{}
            Variables     = [System.Collections.Generic.List[PSVariable]]@()
            Arguments     = @()
            Stack         = [System.Collections.Stack]@()

            AuditTimer = [System.Diagnostics.Stopwatch]::StartNew()
        }

    }
    end {
        $auditState.AuditTimer.Restart()
        $auditState
    }
}

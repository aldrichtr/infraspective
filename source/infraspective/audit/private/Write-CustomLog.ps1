
function Write-CustomLog {
    <#
    .SYNOPSIS
        Wrap the Write-Log function
    .DESCRIPTION
        Check the Configuration prior to writing to the log
    #>

    [CmdletBinding()]
    param(

        # The module that the caller is logging from
        [Parameter(
            Position = 0
        )]
        [string]$Scope,

        # The Logging Level
        [Parameter(
            Position = 1
        )]
        [string]$Level,

        # The Message
        [Parameter(
            Position = 2
        )]
        [string]$Message,

        [Parameter(
            Position = 3
        )]
        [array]$Arguments,

        [Parameter(
        )]
        [object]$Body = $null,

        [Parameter(
        )]
        [System.Management.Automation.ErrorRecord]$ExceptionInfo = $null

    )
    begin {
        Write-Debug "-- Begin $($MyInvocation.MyCommand.Name)"
        $caller_scope = Get-LoggingCallerScope
        #TODO: This is a hack, I would really rather call the Logging\Get-LevelNumber function
        #      but it is a private function...

        $log_level = @{
            NOTSET  = 0
            DEBUG   = 10
            INFO    = 20
            WARNING = 30
            ERROR   = 40
        }

        Set-LoggingCallerScope 2 # Log in the scope of the function that called this one
    }
    process {
        $config = $audit_state.Configuration.Logging
        $config_level = $log_level[$config.$Scope] ?? $log_level.INFO
        $log_level    = $log_level[$Level]

        if ($log_level -ge $config_level) {
            $options = @{
                Level         = $Level
                Message       = $Message
                Arguments     = $Arguments
                Body          = $Body
                ExceptionInfo = $ExceptionInfo
            }
            Write-Log @options
        }


    }
    end {
        Set-LoggingCallerScope $caller_scope # return the scope to the previous value
        Write-Debug "-- End $($MyInvocation.MyCommand.Name)"
    }
}

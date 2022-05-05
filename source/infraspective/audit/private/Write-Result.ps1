
function Write-Result {
    <#
    .SYNOPSIS
        Write the results to the screen
    #>
    [CmdletBinding()]
    param(
        # Type of result.  'Pass', 'Fail', 'Skip', etc.
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Type,

        # The message to write
        [Parameter(
            Mandatory,
            Position = 1
        )]
        [string]$Message

    )
    begin {
        $map = @{
            Passed  = "`e[92m"
            Failed  = "`e[91m"
            Skipped = "`e[90m"
        }
        $reset = "`e[0m"
    }
    process {
        if (-not($map.Keys -contains $Type)) {
            $fmt = $reset
        } else {
            $fmt = $map[$Type]
        }
        $output = "$fmt[$Type]$reset $Message"
        Write-Information $output -InformationAction Continue
    }
    end {}
}

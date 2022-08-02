
function Measure-Firewall {
    <#
    .SYNOPSIS
        Firewall Settings
    .DESCRIPTION
        Used To Determine if Firewall is Running Desired Settings
    .EXAMPLE
        Firewall putty.exe Enabled { Should -Be "$True" }
    .EXAMPLE
        Firewall putty.exe Action { Should -Be 'Allow' }
    .EXAMPLE
        Firewall putty.exe Private { Should -Be 'Public' }
    .NOTES
        Assertions: Be
    #>
    [Alias('Firewall')]
    [CmdletBinding()]
    param(
        # The name of the Firewall DisplayName to be Tested
        [Parameter(Mandatory, Position = 1)]
        [Alias('Name')]
        [string]$Target,

        # The name of the Property of the Firewall Object to be Tested
        [Parameter(Position = 2)]
        [ValidateSet("Name", "DisplayName", "Description", "DisplayGroup", "Group", "Enabled",
            "Profile", "Direction", "Action", "EdgeTraversalPolicy", "LooseSourceMapping",
            "LocalOnlyMapping", "PrimaryStatus", "Status", "EnforcementStatus", "PolicyStoreSource",
            "PolicyStoreSourceType")]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 3)]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $expression = { Get-NetFirewallRule -DisplayName '$Target' -ErrorAction SilentlyContinue }
        $params = Get-PoshspecParam -TestName Firewall -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

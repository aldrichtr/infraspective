
function Measure-Firewall {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Firewall')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias('Name')]
        [string]$Target,

        [Parameter(
            Position = 2
        )]
        [ValidateSet("Name", "DisplayName", "Description", "DisplayGroup", "Group", "Enabled",
            "Profile", "Direction", "Action", "EdgeTraversalPolicy", "LooseSourceMapping",
            "LocalOnlyMapping", "PrimaryStatus", "Status", "EnforcementStatus", "PolicyStoreSource",
            "PolicyStoreSourceType")]
        [string]$Property,

        [Parameter(
            Position = 3,
            Mandatory
        )]
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

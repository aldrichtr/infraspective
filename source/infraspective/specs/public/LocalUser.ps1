
function LocalUser {
    <#
    .SYNOPSIS
        Test if a local user exists and is enabled.
    .DESCRIPTION
        Test if a local user exists and is enabled.
    .EXAMPLE
        LocalUser 'Guest' { should -Not -BeNullOrEmpty }
    .EXAMPLE
        LocalUser 'Guest' Disabled { should -Be $true }
    .NOTES
        Assertions: Be, BeExactly, BeNullOrEmpty, Match, MatchExactly
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # The local user name to test for. Eg 'Guest'
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Property")]
        [Alias('Name')]
        [string]$Target,

        # The property of the account to test
        [Parameter(Position = 2, ParameterSetName = "Property")]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 2, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 3, ParameterSetName = "Property")]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $expression = { Get-CimInstance -ClassName Win32_UserAccount -filter "LocalAccount=True AND` Name='$Target'" }
        $params = Get-PoshspecParam -TestName LocalUser -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

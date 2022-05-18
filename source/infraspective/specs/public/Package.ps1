
function Package {
    <#
    .SYNOPSIS
        Test for installed package.
    .DESCRIPTION
        Test that a specified package is installed.
    .EXAMPLE
        Package 'Microsoft Visual Studio Code' { should -Not -BeNullOrEmpty }
    .EXAMPLE
        Package 'Microsoft Visual Studio Code' version { should -Be '1.1.0' }
    .EXAMPLE
        Package 'NonExistentPackage' { should -BeNullOrEmpty }
    .NOTES
        Assertions: Be, BeNullOrEmpty
    #>

    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # Specifies the Display Name of the package to search for.
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Property")]
        [Alias('Name')]
        [string]$Target,

        # Specifies an optional property to test for on the package.
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
        $expression = { Get-Package -Name "$Target" -ErrorAction SilentlyContinue | Select-Object -First 1 }
        $params = Get-PoshspecParam -TestName Package -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

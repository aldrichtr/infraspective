function SoftwareProduct {
    <#
    .SYNOPSIS
        Test the installed Software Packages.
    .DESCRIPTION
        Test the Existance of a Software Package or the Value of a given Property.
    .EXAMPLE
        SoftwareProduct 'Microsoft .NET Framework 4.6.1' { Should -Exist }
    .EXAMPLE
        SoftwareProduct 'Microsoft SQL Server 2016' DisplayVersion { Should -Be 13.0.1100.286  }
    .EXAMPLE
        SoftwareProduct 'IIS 10.0 Express' InstallLocation { Should -Match 'C:\Program Files (x86)' }
    .NOTES
        Assertions: Be, BeExactly, Exist, Match, MatchExactly
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # Specifies the path to an item.
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Property")]
        [Alias("Path")]
        [string]$Target,

        # Specifies a property at the specified Path.
        [Parameter(Position = 2, ParameterSetName = "Property")]
        [ValidateSet("DisplayVersion", "InstallLocation", "EstimatedSize")]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 2, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 3, ParameterSetName = "Property")]
        [scriptblock]$Should
    )

    begin {
    }
    process {
        $expression = {
            @( 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') |
                Where-Object { Test-Path `$_ } |
                    Get-ItemProperty | Where-Object DisplayName -Match '$Target'
        }
        $params = Get-PoshspecParam -TestName SoftwareProduct -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }


}


function Measure-SoftwareProduct {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('SoftwareProduct')]
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        [Parameter(
            ParameterSetName = "Default",
            Position = 1,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = "Property",
            Position = 1,
            Mandatory
        )]
        [Alias("Path")]
        [string]$Target,

        [Parameter(
            ParameterSetName = "Property",
            Position = 2
        )]
        [ValidateSet("DisplayVersion", "InstallLocation", "EstimatedSize")]
        [string]$Property,

        [Parameter(
            ParameterSetName = "Default",
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = "Property",
            Position = 3,
            Mandatory
        )]
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

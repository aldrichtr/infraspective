
function Measure-Package {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Package')]
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
        [Alias('Name')]
        [string]$Target,

        [Parameter(
            ParameterSetName = "Property",
            Position = 2
        )]
        [string]$Property,

        [Parameter(
            ParameterSetName = "Default",
            , Position = 2,
            Mandatory
            )]
        [Parameter(
            ParameterSetName = "Property",
            , Position = 3,
            Mandatory
            )]
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

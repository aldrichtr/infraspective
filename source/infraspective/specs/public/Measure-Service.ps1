
function Measure-Service {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Service')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias("Name")]
        [string]$Target,

        [Parameter(
            ParameterSetName = 'Default',
            Position = 2
        )]
        [string]$Property = 'Status',

        [Parameter(
            ParameterSetName = 'NoProperty',
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Default',
            Position = 3,
            Mandatory
        )]
        [scriptblock]$Should
    )

    begin {
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('Property')) {
            $Property = 'Status'
            $PSBoundParameters.Add('Property', $Property)
        }

        $params = Get-PoshspecParam -TestName Service -TestExpression {
            Get-Service -Name '$Target' } @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }

}

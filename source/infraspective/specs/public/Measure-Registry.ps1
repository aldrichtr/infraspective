function Measure-Registry {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Registry')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(
            ParameterSetName = 'Default',
            Position = 1,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Property',
            Position = 1,
            Mandatory
        )]
        [Alias('Path')]
        [string]$Target,

        [Parameter(
            ParameterSetName = 'Property',
            Position = 2
        )]
        [string]$Property,

        [Parameter(
            ParameterSetName = 'Default',
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Property',
            Position = 3,
            Mandatory
        )]
        [scriptblock]$Should
    )

    $name = Split-Path -Path $Target -Leaf

    if ($PSBoundParameters.ContainsKey('Property')) {
        $expression = { Get-ItemProperty -Path '$Target' }
    } else {
        $expression = { '$Target' }
    }

    $params = Get-PoshspecParam -TestName Registry -TestExpression $expression -FriendlyName $name @PSBoundParameters

    Invoke-PoshspecExpression @params
}

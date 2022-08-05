
function Measure-LocalGroup {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('LocalGroup')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias('Name')]
        [string]$Target,

        [Parameter(
            Position = 2,
            Mandatory
        )]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $expression = { Get-CimInstance -ClassName Win32_Group -Filter "Name = '$Target'" }
        $params = Get-PoshspecParam -TestName LocalGroup -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

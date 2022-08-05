
function Measure-Share {
    <#
    .EXERNALHELP infraspective-help.xml
    #>
    [Alias('Share')]
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
        $expression = {
            Get-CimInstance -ClassName Win32_Share -Filter "Name = '$Target'"
        }
        $params = Get-PoshspecParam -TestName Share -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

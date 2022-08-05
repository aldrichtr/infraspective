
function Measure-Folder {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Folder')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias('Path')]
        [string]$Target,

        [Parameter(
            Position=2,
            Mandatory
        )]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $params = Get-PoshspecParam -TestName Folder -TestExpression {'$Target'} @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

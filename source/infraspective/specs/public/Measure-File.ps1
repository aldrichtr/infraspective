
function Measure-File {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('File')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias("Path")]
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
        $name = Split-Path -Path $Target -Leaf
        $params = Get-PoshspecParam -TestName File -TestExpression { '$Target' } -FriendlyName $name @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

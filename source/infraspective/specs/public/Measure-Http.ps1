
function Measure-Http {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Http')]
    [CmdletBinding()]
    param(

        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias("Uri")]
        [string]$Target,

        [Parameter(
            Position=2,
            Mandatory
        )]
        [ValidateSet("BaseResponse", "Content", "Headers", "RawContent",
         "RawContentLength", "RawContentStream", "StatusCode", "StatusDescription")]
        [string]$Property,

        [Parameter(
            Position=3,
            Mandatory
        )]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $params = Get-PoshspecParam -TestName Http -TestExpression {
            Invoke-WebRequest -Uri '$Target' -UseBasicParsing -ErrorAction SilentlyContinue
        } @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

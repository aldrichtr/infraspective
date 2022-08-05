
function Measure-Hotfix {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Hotfix')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias("Id")]
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
         $params = Get-PoshspecParam -TestName Hotfix -TestExpression {
             Get-HotFix -Id $Target -ErrorAction SilentlyContinue
            } @PSBoundParameters
     }
     end {
         Invoke-PoshspecExpression @params
     }
}

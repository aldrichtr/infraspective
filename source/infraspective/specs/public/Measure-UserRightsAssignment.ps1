
function Measure-UserRightsAssignment {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('UserRightsAssignment')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [ValidateSet('ByRight', 'ByAccount')]
        [string]$Qualifier,

        [Parameter(
            Position = 2,
            Mandatory
        )]
        [Alias('Right')]
        [string]$Target,

        [Parameter(
            Position = 3,
            Mandatory
        )]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        if (Test-RunAsAdmin) {
            if ($Qualifier -eq 'ByRight') {
                $expression = { Get-AccountsWithUserRight -Right '$Target' | Select-Object -ExpandProperty Account }
            } elseif ($Qualifier -eq 'ByAccount') {
                $expression = { Get-UserRightsGrantedToAccount -Account '$Target' | Select-Object -ExpandProperty Right }
            }
        } else {
            throw 'You must run as Administrator to test UserRightsAssignment'
        }
        $params = Get-PoshspecParam -TestName UserRightsAssignment -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

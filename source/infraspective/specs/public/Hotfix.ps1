
function Hotfix {
     <#
    .SYNOPSIS
        Test if a Hotfix is installed.
    .DESCRIPTION
        Test if a Hotfix is installed.
    .EXAMPLE
        Hotfix KB3116900 { Should -Not -BeNullOrEmpty}
    .EXAMPLE
        Hotfix KB1112233 { Should -BeNullOrEmpty}
    .NOTES
        Assertions: BeNullOrEmpty
    #>
    [CmdletBinding()]
    param(
        # The Hotfix ID. Eg KB1112233
        [Parameter(Mandatory,Position=1)]
        [Alias("Id")]
        [string]$Target,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position=2)]
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

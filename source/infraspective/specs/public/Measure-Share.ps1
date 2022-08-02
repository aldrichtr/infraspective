
function Measure-Share {
    <#
    .SYNOPSIS
        Test if a share exists.
    .DESCRIPTION
        Test if a share exists.
    .EXAMPLE
        Share 'MyShare' { should -Not -BeNullOrEmpty }
    .EXAMPLE
        Share 'BadShare' { should -BeNullOrEmpty }
    .NOTES
        Assertions: BeNullOrEmpty
    #>
    [Alias('Share')]
    [CmdletBinding()]
    param(
        # The share name to test for. Eg 'C$' or 'MyShare'
        [Parameter(Mandatory, Position = 1)]
        [Alias('Name')]
        [string]$Target,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 2)]
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

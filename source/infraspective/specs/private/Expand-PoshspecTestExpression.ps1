
function Expand-PoshspecTestExpression {
    <#
    .SYNOPSIS
        Expand the given expression into a scriptblock
    .DESCRIPTION
        Expand the input object into a scriptblock that can be executed by Pester
    #>
    [CmdletBinding()]
    param(
        # The expression string
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ObjectExpression,

        # The property string
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $PropertyExpression
    )
    begin {
    }
    process {
        Write-Debug "Expanding  ObjectExpression $ObjectExpression PropertyExpression $PropertyExpression"
        $cmd = [scriptblock]::Create('(' + $ObjectExpression + ')' + '.' + $PropertyExpression)
        Write-Debug "To $($cmd.ToString())"
    }
    end {
        $cmd.ToString()
    }
}

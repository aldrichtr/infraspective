
function Expand-PoshspecTestExpression {
    <#
    .EXTERNALHELP infraspective-help.xml
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
        Write-Debug "Expanding ObjectExpression $ObjectExpression PropertyExpression $PropertyExpression"
        $cmd = [scriptblock]::Create('(' + $ObjectExpression + ')' + '.' + $PropertyExpression)
        Write-Debug "To $($cmd.ToString())"
    }
    end {
        $cmd.ToString()
    }
}

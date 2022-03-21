
function Expand-PoshspecTestExpression
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $ObjectExpression,

    [Parameter(Mandatory=$true, Position=1)]
    [string]
    $PropertyExpression
  )
    Write-Debug "Expanding  ObjectExpression $ObjectExpression PropertyExpression $PropertyExpression"
    
    $cmd = [scriptblock]::Create('(' + $ObjectExpression + ')' + '.' + $PropertyExpression)
    Write-Debug "To $($cmd.ToString())"
    Write-Output $cmd.ToString()
}

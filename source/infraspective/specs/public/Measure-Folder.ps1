
function Measure-Folder {
    <#
    .SYNOPSIS
    Test if a folder exists.
    .DESCRIPTION
    Test if a folder exists.
    .EXAMPLE
    folder $env:ProgramData { Should -Exist }
    .EXAMPLE
    folder C:\badfolder { Should -Not -Exist }
    .NOTES
    Assertions: Exist
    #>
    [Alias('Folder')]
    [CmdletBinding()]
    param(
        # The path of the folder to search for.
        [Parameter(Mandatory, Position = 1)]
        [Alias('Path')]
        [string]$Target,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position=2)]
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

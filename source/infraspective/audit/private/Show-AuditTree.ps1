
function Show-AuditTree {
    <#
    .SYNOPSIS
        Pretty print an Audit AST
    #>
    [CmdletBinding()]
    param(
        # The tree to print
        [Parameter(
        )]
        [Object]$Tree,

        # Current depth
        [Parameter(
        )]
        [int]$Level
    )
    begin {
        if ($PSBoundParameters['Level']) {
            $currentLevel = $Level
        } else {
            $currentLevel = 0
        }
    }
    process {
        $indent = ('  ' * $currentLevel)
        $name = $Tree.Name ? $Tree.Name : "Name: (none)"
        $title = $Tree.Title ? $Tree.Title : "Title: (none)"
        Write-Output ("{0,-4}- {1,-24} {2,-32} {3}" -f $indent, $name, $title, $Tree.psobject.TypeNames[0])

        $currentLevel++
        foreach ($c in $Tree.Children) {
            Show-AuditTree $c -Level $currentLevel
        }
    }
    end {}
}

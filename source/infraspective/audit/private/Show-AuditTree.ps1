
function Show-AuditTree {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            ValueFromPipeline
        )]
        [Object]$Tree,

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
        $leader = "|  "
    }
    process {
        $indent = ($leader * $currentLevel)

        $name = $Tree.Name ? $Tree.Name : "none"
        $title = $Tree.Title ? $Tree.Title : "none"
        $out = ("+- [{0}] : {1} ({2})" -f ($Tree.psobject.TypeNames[0] -replace 'Infraspective\.', ''), $name, $title)
        Write-Output "$indent$out"

        $currentLevel++

        foreach ($c in $Tree.Children) {
            Show-AuditTree $c -Level $currentLevel
        }
    }
    end {}
}

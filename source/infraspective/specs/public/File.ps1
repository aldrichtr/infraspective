
function File {
    <#
    .SYNOPSIS
        Test a File.
    .DESCRIPTION
        Test the Existance or Contents of a File..
    .EXAMPLE
        File C:\inetpub\wwwroot\iisstart.htm { Should Exist }
    .EXAMPLE
        File C:\inetpub\wwwroot\iisstart.htm { Should Contain 'text-align:center' }
    .NOTES
        Assertions: Exist and Contain
    #>
    [CmdletBinding()]
    param(
        # Specifies the path to an item.
        [Parameter(Mandatory, Position = 1)]
        [Alias("Path")]
        [string]$Target,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 2)]
        [scriptblock]$Should
    )
    begin {

    }
    process {
        $name = Split-Path -Path $Target -Leaf
        $params = Get-PoshspecParam -TestName File -TestExpression { '$Target' } -FriendlyName $name @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

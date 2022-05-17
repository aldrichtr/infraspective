function LocalGroup {
    <#
    .SYNOPSIS
        Test if a local group exists.
    .DESCRIPTION
        Test if a local group exists.
    .EXAMPLE
        LocalGroup 'Administrators' { Should -Not -BeNullOrEmpty }
    .EXAMPLE
        LocalGroup 'BadGroup' { Should -BeNullOrEmpty }
    .NOTES
        Assertions: BeNullOrEmpty
    #>

    [CmdletBinding()]
    param(
        # The local group name to test for. Eg 'Administrators'
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
        $expression = { Get-CimInstance -ClassName Win32_Group -Filter "Name = '$Target'" }

        $params = Get-PoshspecParam -TestName LocalGroup -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}


function Measure-DnsHost {
    <#
    .SYNOPSIS
    Test DNS resolution to a host.
    .DESCRIPTION
    Test DNS resolution to a host.
    .EXAMPLE
    dnshost nonexistenthost.mymadeupdomain.tld { Should -Be $null }
    .EXAMPLE
    dnshost www.google.com { Should -Not -Be $null }
    .NOTES
    Assertions: be
    #>
    [Alias('DnsHost')]
    [CmdletBinding()]
    param(
        # The hostname to resolve in DNS.
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
        $expression = { Resolve-DnsName -Name $Target -DnsOnly -NoHostsFile -ErrorAction SilentlyContinue }
        $params = Get-PoshspecParam -TestName DnsHost -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

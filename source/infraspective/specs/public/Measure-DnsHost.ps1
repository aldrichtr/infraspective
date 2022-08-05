
function Measure-DnsHost {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('DnsHost')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias('Name')]
        [string]$Target,

        [Parameter(
            Position = 2,
            Mandatory
        )]
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

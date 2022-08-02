
function Measure-TcpPort {
    <#
    .SYNOPSIS
        Test a a Tcp Port.
    .DESCRIPTION
        Test that a Tcp Port is listening and optionally validate any TestNetConnectionResult property.
    .EXAMPLE
        TcpPort localhost 80 PingSucceeded  { Should Be $true }
    .EXAMPLE
        TcpPort localhost 80 TcpTestSucceeded { Should Be $true }
    .NOTES
        Assertions: Be, BeExactly, Match, MatchExactly
    #>
    [Alias('TcpPort')]
    [CmdletBinding()]
    param(
        # Specifies the Domain Name System (DNS) name or IP address of the target computer.
        [Parameter(Mandatory, Position=1)]
        [Alias("ComputerName")]
        [string]$Target,

        # Specifies the TCP port number on the remote computer.
        [Parameter(Mandatory, Position=2)]
        [Alias("Port")]
        [string]$Qualifier,

        # Specifies a property of the TestNetConnectionResult object to test.
        [Parameter(Mandatory, Position=3)]
        [ValidateSet("AllNameResolutionResults", "BasicNameResolution", "ComputerName", "Detailed", "DNSOnlyRecords", "InterfaceAlias",
        "InterfaceDescription", "InterfaceIndex", "IsAdmin", "LLMNRNetbiosRecords", "MatchingIPsecRules", "NameResolutionSucceeded",
        "NetAdapter", "NetRoute", "NetworkIsolationContext", "PingReplyDetails", "PingSucceeded", "RemoteAddress", "RemotePort",
        "SourceAddress", "TcpClientSocket", "TcpTestSucceeded", "TraceRoute")]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position=4)]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $params = Get-PoshspecParam -TestName TcpPort -TestExpression {
            Test-NetConnection -ComputerName $Target -Port $Qualifier -ErrorAction SilentlyContinue
        } @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

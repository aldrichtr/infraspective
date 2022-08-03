
function Measure-TcpPort {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('TcpPort')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias("ComputerName")]
        [string]$Target,

        [Parameter(
            Position = 2,
            Mandatory
        )]
        [Alias("Port")]
        [string]$Qualifier,

        [Parameter(
            Position = 3,
            Mandatory
        )]
        [ValidateSet(
            "AllNameResolutionResults", "BasicNameResolution", "ComputerName",
            "Detailed", "DNSOnlyRecords", "InterfaceAlias", "InterfaceDescription",
            "InterfaceIndex", "IsAdmin", "LLMNRNetbiosRecords", "MatchingIPsecRules",
            "NameResolutionSucceeded", "NetAdapter", "NetRoute", "NetworkIsolationContext",
            "PingReplyDetails", "PingSucceeded", "RemoteAddress", "RemotePort",
            "SourceAddress", "TcpClientSocket", "TcpTestSucceeded", "TraceRoute"
        )]
        [string]$Property,

        [Parameter(
            Position = 4,
            Mandatory
        )]
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

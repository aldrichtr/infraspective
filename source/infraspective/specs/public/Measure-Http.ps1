
function Measure-Http {
    <#
    .SYNOPSIS
        Test a Web Service.
    .DESCRIPTION
        Test that a Web Service is reachable and optionally returns specific content.
    .EXAMPLE
        Http http://localhost StatusCode { Should -Be 200 }
    .EXAMPLE
        Http http://localhost RawContent { Should -Match 'X-Powered-By: ASP.NET' }
    .EXAMPLE
        Http http://localhost RawContent { Should -Not -Match 'X-Powered-By: Cobal' }
    .NOTES
        Assertions: Be, BeExactly, Match, MatchExactly
    #>
    [Alias('Http')]
    [CmdletBinding()]
    param(
        # Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent.
        [Parameter(Mandatory, Position = 1)]
        [Alias("Uri")]
        [string]$Target,

        # Specifies a property of the WebResponseObject object to test.
        [Parameter(Mandatory, Position=2)]
        [ValidateSet("BaseResponse", "Content", "Headers", "RawContent",
         "RawContentLength", "RawContentStream", "StatusCode", "StatusDescription")]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position=3)]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $params = Get-PoshspecParam -TestName Http -TestExpression {
            Invoke-WebRequest -Uri '$Target' -UseBasicParsing -ErrorAction SilentlyContinue
        } @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

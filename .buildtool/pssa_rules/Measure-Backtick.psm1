function Measure-Backtick {
    <#
    .SYNOPSIS
        Removes backticks from your script and use "splatting" instead.
    .DESCRIPTION
        In general, the community feels you should avoid using those backticks as “line continuation characters” when possible.
        They’re hard to read, easy to miss, and easy to mis-type. Also, if you add an extra whitespace after the backtick in the above example, then the command won’t work.
        To fix a violation of this rule, please remove backticks from your script and use "splatting" instead. You can run "Get-Help about_splatting" to get more details.
    .EXAMPLE
        Measure-Backtick -Token $Token
    .INPUTS
        [System.Management.Automation.Language.Token[]]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Document nested structures, Windows PowerShell Best Practices.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.Token[]]
        $Token
    )

    Process {
        $results = @()

        try {
            # Finds LineContinuation tokens
            $lcTokens = $Token | Where-Object { $PSItem.Kind -eq [System.Management.Automation.Language.TokenKind]::LineContinuation }

            foreach ($lcToken in $lcTokens) {
                $result = New-Object `
                    -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                    -ArgumentList $Messages.MeasureBacktick, $lcToken.Extent, $PSCmdlet.MyInvocation.InvocationName, Warning, $null

                $results += $result
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

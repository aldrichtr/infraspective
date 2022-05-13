function Measure-OverComment {
    <#
    .SYNOPSIS
        Removes these unnecessary comments.
    .DESCRIPTION
        Don't precede each line of code with a comment. Doing so breaks up the code and makes it harder to follow. A well-written PowerShell command, with full command and parameter names, can be pretty self-explanatory.
        Don't comment-explain it unless it isn't self-explanatory.To fix a violation of this rule, please remove these unnecessary comments.
    .EXAMPLE
        Measure-OverComment -Token $Token
    .INPUTS
        [System.Management.Automation.Language.Token[]]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: DOC-07 Don't over-comment, The Community Book of PowerShell Practices.
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
            # Calculates comment tokens length
            foreach ($subToken in $Token) {
                $allTokensLength += $subToken.Text.Length
                if ($subToken.Kind -eq [System.Management.Automation.Language.TokenKind]::Comment) {
                    $commentTokensLength += $subToken.Text.Length
                } else {
                    $otherTokensLength += $subToken.Text.Length
                }
            }

            $actualPercentage = [int]($commentTokensLength / $allTokensLength * 100)

            if ($actualPercentage -ge 80) {
                $result = New-Object `
                    -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                    -ArgumentList $Messages.MeasureOverComment, $Token[0].Extent, $PSCmdlet.MyInvocation.InvocationName, Warning, $null

                $results += $result
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

function Measure-QuestionVariable {
    <#
    .SYNOPSIS
        Considers to use try-catch-finally statements instead of using $?.
    .DESCRIPTION
        When you need to examine the error that occurred, try to avoid using $?. It actually doesn’t mean an error did or did not occur; it’s reporting whether or not the last-run command considered itself to have completed successfully.
        You get no details on what happened. To fix a violation of this rule, please consider to use try-catch-finally statements.
    .EXAMPLE
        Measure-QuestionVariable -ScriptBlockAst $ScriptBlockAst
    .INPUTS
        [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Trapping and Capturing Errors, Windows PowerShell Best Practices.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    Process {
        $results = @()

        try {
            $tokens = $null
            $errors = $null

            # Parses the input to get tokens.
            $sbAst = [System.Management.Automation.Language.Parser]::ParseInput($ScriptBlockAst, [ref]$tokens, [ref]$errors)

            # Gets question variables
            $questionVariables = $tokens | Where-Object { $PSItem.Name -eq '?' }

            foreach ($questionVariable in $questionVariables) {
                $result = New-Object `
                    -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                    -ArgumentList $Messages.MeasureQuestionVariable, $questionVariable.Extent, $PSCmdlet.MyInvocation.InvocationName, Warning, $null

                $results += $result
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

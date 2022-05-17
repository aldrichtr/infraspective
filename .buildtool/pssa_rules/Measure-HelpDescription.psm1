function Measure-HelpDescription {
    <#
    .SYNOPSIS
        Confirm the function has a help description
    .DESCRIPTION
        Comment-based help is written as a series of comments. You can write comment-based help topics for end users to better understand your functions. Additionally, it’s better to explain the detail about how the function works.
        To fix a violation of this rule, add a .DESCRIPTION keyword in your comment-based help. You can get more details by running “Get-Help about_Comment_Based_Help” command in Windows PowerShell.
    .EXAMPLE
        Measure-HelpNote -FunctionDefinitionAst $FunctionDefinitionAst
    .INPUTS
        [System.Management.Automation.Language.FunctionDefinitionAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Writing Help and Comments, Windows PowerShell Best Practices.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.FunctionDefinitionAst]
        $FunctionDefinitionAst
    )

    Process {
        $results = @()

        try {
            #region Define predicates to find ASTs.

            # Finds CmdletBinding attribute.
            [ScriptBlock]$predicate = {
                param ([System.Management.Automation.Language.Ast]$Ast)

                [bool]$returnValue = $false

                if ($Ast -is [System.Management.Automation.Language.AttributeAst]) {
                    [System.Management.Automation.Language.AttributeAst]$attrAst = $ast;
                    if ($attrAst.TypeName.Name -eq 'CmdletBinding') {
                        $returnValue = $true
                    }
                }

                return $returnValue
            }

            #endregion

            # Return directly if function is not an advanced function.
            [System.Management.Automation.Language.AttributeAst[]]$attrAsts = $FunctionDefinitionAst.Find($predicate, $true)
            if ($FunctionDefinitionAst.IsWorkflow -or !$attrAsts) {
                return $results
            }

            if (-not($FunctionDefinitionAst.GetHelpContent().Description)) {
                $result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Function should have a Description section"
                    RuleName = 'AdvancedFunctionHelpDescription'
                    Severity = 'Error'
                    Extent = $FunctionDefinitionAst.Extent
                }
                $results += $result
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

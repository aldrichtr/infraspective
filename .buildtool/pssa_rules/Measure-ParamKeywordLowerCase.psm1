function Measure-ParamKeywordLowerCase {
    <#
    .SYNOPSIS
        Param block keyword should be PascalCase.
    .DESCRIPTION
        The "p" of "param" should be lowercase
        This rule can auto-fix violations.
    .EXAMPLE
        # BAD
        Param()
        #GOOD
        param()
    .INPUTS
        [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Personal preference
        Note: Whether you prefer PascalCase or otherwise, consistency is what matters most.
    #>
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )
    begin {
        $Results = @()
        $Predicate = {
            param(
                [System.Management.Automation.Language.Ast] $Ast
            )
            ($Ast -is [System.Management.Automation.Language.ParamBlockAst]) -and -not ($Ast.Extent.Text -cmatch 'param\(')
        }
    }
    process {
        try {
            $Violations = $ScriptBlockAst.FindAll($Predicate, $False)
            foreach ($Violation in $Violations) {
                $Extent = $Violation.Extent
                $Correction = $Extent.Text -replace '^Param\s*\(', 'param('
                $CorrectionExtent = New-Object 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent' @($Extent.StartLineNumber, $Extent.EndLineNumber, $Extent.StartColumnNumber, $Extent.EndColumnNumber, $Correction, '')
                $SuggestedCorrections = New-Object System.Collections.ObjectModel.Collection['Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent']
                [Void]$SuggestedCorrections.Add($CorrectionExtent)
                $Results += [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]@{
                    Message              = 'Param block keyword should be lowercase with no trailing spaces'
                    RuleName             = 'ParamKeywordLowerCase'
                    Severity             = 'Warning'
                    Extent               = $Extent
                    SuggestedCorrections = $SuggestedCorrections
                }
            }
            return $Results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

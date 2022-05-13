function Measure-NamedBlockPascalCase {
    <#
    .SYNOPSIS
        Named script blocks (Begin, Process, etc...) should be PascalCase.
    .DESCRIPTION
        The named script block names should be lowercase.  This rule can auto-fix violations.
    .EXAMPLE
        # BAD
        Process {...}
        #GOOD
        process {...}
    .INPUTS
        [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Personal preference
        Note: Whether you prefer title case named script blocks or otherwise, consistency is what matters most.
    #>
    [CmdletBinding()]
    [OutputType([Object[]])]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )
    begin {
        $Results = @()
        $Predicate = {
            Param(
                [System.Management.Automation.Language.Ast] $Ast
            )
            ($Ast -is [System.Management.Automation.Language.NamedBlockAst]) -and -not $Ast.Unnamed -and -not ($Ast.Extent.Text -cmatch '^[a-z]')
        }
    }
    process {
        try {
            $Violations = $ScriptBlockAst.FindAll($Predicate, $False)
            foreach ($Violation in $Violations) {
                $Extent = $Violation.Extent
                $Correction = $Extent.Text[0].ToString().ToLower() + $Extent.Text.Substring(1)
                $CorrectionExtent = New-Object 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent' @($Extent.StartLineNumber, $Extent.EndLineNumber, $Extent.StartColumnNumber, $Extent.EndColumnNumber, $Correction, '')
                $SuggestedCorrections = New-Object System.Collections.ObjectModel.Collection['Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent']
                [Void]$SuggestedCorrections.Add($CorrectionExtent)
                $Results += [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]@{
                    Message              = 'Named script block names should be lowercase'
                    RuleName             = 'NamedBlockLowerCase'
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

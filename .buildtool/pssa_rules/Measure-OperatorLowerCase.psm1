
function Measure-OperatorLowerCase {
    <#
    .SYNOPSIS
        Operators (-join, -split, etc...) should be lowercase.
    .DESCRIPTION
        Operators should not be capitalized.
        This rule can auto-fix violations.
    .EXAMPLE
        # BAD
        $Foo -Join $Bar
        #GOOD
        $Foo -join $Bar
    .INPUTS
        [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Personal preference
        Note: Whether you prefer lowercase operators or otherwise, consistency is what matters most.
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
            ($Ast -is [System.Management.Automation.Language.BinaryExpressionAst]) -and ($Ast.ErrorPosition.Text -cmatch '[A-Z]')
        }
    }
    process {
        try {
            $Violations = $ScriptBlockAst.FindAll($Predicate, $False)
            foreach ($Violation in $Violations) {
                $Extent = $Violation.Extent
                $ErrorPosition = $Violation.ErrorPosition
                $StartColumnNumber = $Extent.StartColumnNumber
                $Start = $ErrorPosition.StartColumnNumber - $StartColumnNumber
                $End = $ErrorPosition.EndColumnNumber - $StartColumnNumber
                $Correction = $Extent.Text.SubString(0, $Start) + $ErrorPosition.Text.ToLower() + $Extent.Text.SubString($End)
                $CorrectionExtent = New-Object 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent' @($Extent.StartLineNumber, $Extent.EndLineNumber, $StartColumnNumber, $Extent.EndColumnNumber, $Correction, '')
                $SuggestedCorrections = New-Object System.Collections.ObjectModel.Collection['Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent']
                [Void]$SuggestedCorrections.Add($CorrectionExtent)
                $Results += [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]@{
                    Message              = 'Operators should be lowercase'
                    RuleName             = 'OperatorLowerCase'
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

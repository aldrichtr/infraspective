function Measure-RequiresRunAsAdministrator {
    <#
    .SYNOPSIS
        Uses #Requires -RunAsAdministrator instead of your own methods.
    .DESCRIPTION
        The #Requires statement prevents a script from running unless the Windows PowerShell version, modules, snap-ins, and module and snap-in version prerequisites are met.
        From Windows PowerShell 4.0, the #Requires statement let script developers require that sessions be run with elevated user rights (run as Administrator).
        Script developers does not need to write their own methods any more.
        To fix a violation of this rule, please consider to use #Requires -RunAsAdministrator instead of your own methods.
    .EXAMPLE
        Measure-RequiresRunAsAdministrator -ScriptBlockAst $ScriptBlockAst
    .INPUTS
        [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        None
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
            #region Define predicates to find ASTs.

            # Finds specific method, IsInRole.
            [ScriptBlock]$predicate1 = {
                param ([System.Management.Automation.Language.Ast]$Ast)

                [bool]$returnValue = $false

                if ($Ast -is [System.Management.Automation.Language.MemberExpressionAst]) {
                    [System.Management.Automation.Language.MemberExpressionAst]$meAst = $ast;
                    if ($meAst.Member -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                        [System.Management.Automation.Language.StringConstantExpressionAst]$sceAst = $meAst.Member;
                        if ($sceAst.Value -eq "isinrole") {
                            $returnValue = $true;
                        }
                    }
                }

                return $returnValue
            }

            # Finds specific value, [system.security.principal.windowsbuiltinrole]::administrator.
            [ScriptBlock]$predicate2 = {
                param ([System.Management.Automation.Language.Ast]$Ast)

                [bool]$returnValue = $false

                if ($ast -is [System.Management.Automation.Language.AssignmentStatementAst]) {
                    [System.Management.Automation.Language.AssignmentStatementAst]$asAst = $Ast;
                    if ($asAst.Right.ToString() -eq "[system.security.principal.windowsbuiltinrole]::administrator") {
                        $returnValue = $true
                    }
                }

                return $returnValue
            }

            #endregion

            #region Finds ASTs that match the predicates.

            [System.Management.Automation.Language.Ast[]]$methodAst = $ScriptBlockAst.FindAll($predicate1, $true)
            [System.Management.Automation.Language.Ast[]]$assignmentAst = $ScriptBlockAst.FindAll($predicate2, $true)

            if ($null -ne $ScriptBlockAst.ScriptRequirements) {
                if ((!$ScriptBlockAst.ScriptRequirements.IsElevationRequired) -and
                    ($methodAst.Count -ne 0) -and ($assignmentAst.Count -ne 0)) {
                    $result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                        Message = "Should use #Requires -RunAsAdministrator"
                        RuleName = $PSCmdlet.MyInvocation.InvocationName
                        Severity = 'Information'
                        Extent = $assignmentAst.Extent
                    }
                    $results += $result
                }
            } else {
                if (($methodAst.Count -ne 0) -and ($assignmentAst.Count -ne 0)) {
                    $result = New-Object `
                        -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                        -ArgumentList $Messages.MeasureRequiresRunAsAdministrator, $assignmentAst.Extent, $PSCmdlet.MyInvocation.InvocationName, 'Information', $null
                    $results += $result
                }
            }

            return $results

            #endregion
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

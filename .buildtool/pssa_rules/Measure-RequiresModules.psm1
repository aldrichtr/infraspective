function Measure-RequiresModules {
    <#
    .SYNOPSIS
        Uses #Requires -Modules instead of Import-Module.
    .DESCRIPTION
        The #Requires statement prevents a script from running unless the Windows PowerShell version, modules, snap-ins, and module and snap-in version prerequisites are met.
        From Windows PowerShell 3.0, the #Requires statement let script developers specify Windows PowerShell modules that the script requires.
        To fix a violation of this rule, please consider to use #Requires -Modules { <Module-Name> | <Hashtable> } instead of using Import-Module.
    .EXAMPLE
        Measure-RequiresModules -ScriptBlockAst $ScriptBlockAst
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

            # Finds specific command name, import-module.
            [ScriptBlock]$predicate = {
                param ([System.Management.Automation.Language.Ast]$Ast)

                [bool]$returnValue = $false

                if ($Ast -is [System.Management.Automation.Language.CommandAst]) {
                    [System.Management.Automation.Language.CommandAst]$cmdAst = $Ast;
                    if ($null -ne $cmdAst.GetCommandName()) {
                        if ($cmdAst.GetCommandName() -eq "import-module") {
                            $returnValue = $true
                        }
                    }
                }

                return $returnValue
            }

            #endregion

            #region Finds ASTs that match the predicates.

            [System.Management.Automation.Language.Ast[]]$asts = $ScriptBlockAst.FindAll($predicate, $true)

            if ($null -ne $ScriptBlockAst.ScriptRequirements) {
                if (($ScriptBlockAst.ScriptRequirements.RequiredModules.Count -eq 0) -and
                    ($null -ne $asts)) {
                    foreach ($ast in $asts) {
                        $result = New-Object `
                            -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                            -ArgumentList $Messages.MeasureRequiresModules, $ast.Extent, $PSCmdlet.MyInvocation.InvocationName, 'Information', $null

                        $results += $result
                    }
                }
            } else {
                if ($null -ne $asts) {
                    foreach ($ast in $asts) {
                        $result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                            Message = "Should use #Requires module"
                            RuleName = $PSCmdlet.MyInvocation.InvocationName
                            Extent =  $ast.Extent
                            Severity = 'Information'
                        }

                        $results += $result
                    }
                }
            }

            return $results

            #endregion
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

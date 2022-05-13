function Measure-ComObject {
    <#
    .SYNOPSIS
        Please do not use COM objects when calling New-Object.
    .DESCRIPTION
        If you can't use just PowerShell, use .NET, external commands or COM objects, in that order of preference. COM objects are rarely well-documented, making them harder for someone else to research and understand.
        They do not always work flawlessly in PowerShell, as they must be used through .NET's Interop layer, which isn't 100% perfect.
        To fix a violation of this rule, please do not use COM objects when calling New-Object.
    .EXAMPLE
        Measure-ComObject -CommandAst $CommandAst
    .INPUTS
        [System.Management.Automation.Language.CommandAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: The Purity Laws, The Community Book of PowerShell Practices.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.CommandAst]
        $CommandAst
    )

    Process {
        $results = @()

        # The StaticParameterBinder help us to find the argument of TypeName.
        $spBinder = [System.Management.Automation.Language.StaticParameterBinder]

        # Checks New-Object without ComObject parameter command only.
        if ($null -ne $CommandAst.GetCommandName()) {
            if ($CommandAst.GetCommandName() -ne "new-object") {
                return $results
            }
        } else {
            return $results
        }

        try {
            [System.Management.Automation.Language.StaticBindingResult]$sbResults = $spBinder::BindCommand($CommandAst, $true)
            foreach ($sbResult in $sbResults) {
                if ($sbResults.BoundParameters.ContainsKey("ComObject")) {
                    # $sbResult.BoundParameters["TypeName"].Value is a CommandElementAst, so we can return an extent.
                    $result = New-Object `
                        -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                        -ArgumentList $Messages.MeasureComObject, $sbResult.BoundParameters["ComObject"].Value.Extent, $PSCmdlet.MyInvocation.InvocationName, Warning, $null

                    $results += $result
                }
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }


    }
}

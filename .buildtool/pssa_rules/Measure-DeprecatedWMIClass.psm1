function Measure-DeprecatedWMIClass {
    <#
    .SYNOPSIS
        Do not use deprecated WMI class in your script.
    .DESCRIPTION
        With the release of new Microsoft Windows, some WMI classes are marked as deprecated. When writing Windows PowerShell scripts, you should not use these WMI classes.
        You can run this command to get the deprecated WMI classes list, "Get-CimClass * -QualifierName deprecated"
        To fix a violation of this rule, please do not use the deprecated WMI classes in your script.
    .EXAMPLE
        Measure-DeprecatedWMIClass -StringConstantExpressionAst $StringConstantExpressionAst
    .INPUTS
        [System.Management.Automation.Language.StringConstantExpressionAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Filtering classes by qualifier, Windows PowerShell Best Practics
    #>

    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.StringConstantExpressionAst]
        $StringConstantExpressionAst
    )

    Process {
        $results = @()

        $deprecatedWMIClasses = @("Win32_PageFile", "Win32_DisplayConfiguration", "Win32_DisplayControllerConfiguration",
            "Win32_VideoConfiguration", "Win32_AllocatedResource")

        try {
            if ($StringConstantExpressionAst.Value -in $deprecatedWMIClasses) {
                $result = New-Object `
                    -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                    -ArgumentList $Messages.MeasureDeprecatedWMIClass, $StringConstantExpressionAst.Extent, $PSCmdlet.MyInvocation.InvocationName, 'Information', $null

                $results += $result
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

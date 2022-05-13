function Measure-LongClassName {
    <#
    .SYNOPSIS
        You can store the type name in a variable or using -f operator to reduce the amount of redundant information in your script.
    .DESCRIPTION
        When interacting with classes that have long type names, you want to reduce the amount of redundant information in your script.
        To fix a violation of this rule, please store the type name in a variable or using -f operator. For example:
        $namespace = "System.Collections.{0}"; $arrayList = New-Object ($namespace -f "ArrayList"); $queue = New-Object ($namespace -f "Queue")
    .EXAMPLE
        Measure-LongClassName -CommandAst $CommandAst
    .INPUTS
        [System.Management.Automation.Language.CommandAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: 3.11. Reduce Typying for Long Class Names, Windows PowerShell Cookbook, Third Edition
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
                # TypeName cannot be found if user run command like, New-Object -ComObject Scripting.FileSystemObject.
                if ($null -eq $sbResult.BoundParameters["TypeName"].ConstantValue) { continue }

                if ($sbResult.BoundParameters["TypeName"].ConstantValue.ToString().Split('.').Length -ge 3) {
                    # $sbResult.BoundParameters["TypeName"].Value is a CommandElementAst, so we can return an extent.
                    $result = New-Object `
                        -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                        -ArgumentList $Messages.MeasureLongClassName, $sbResult.BoundParameters["TypeName"].Value.Extent, $PSCmdlet.MyInvocation.InvocationName, 'Information', $null

                    $results += $result
                }
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }


    }
}

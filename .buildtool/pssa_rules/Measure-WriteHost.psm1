function Measure-WriteHost {
    <#
    .SYNOPSIS
        You should never use Write-Host to create any script output whatsoever.
    .DESCRIPTION
        It is generally accepted that you should never use Write-Host to create any script output whatsoever, unless your script (or function, or whatever) uses the Show verb (as in, Show-Performance).
        That verb explicitly means “show on the screen, with no other possibilities.” Like Show-Command.
        To fix a violation of this rule, please replace Write-Host with Write-Output in most scenarios.
    .EXAMPLE
        Measure-WriteHost -CommandAst $CommandAst
    .INPUTS
        [System.Management.Automation.Language.CommandAst]
    .OUTPUTS
        [Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
        Reference: Output, The Community Book of PowerShell Practices.
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

        try {
            # Checks command name, if the command name matches Write-Host or
            # user-defined aliases, this rule is triggered.

            if ($null -ne $CommandAst.GetCommandName()) {
                $alias = (Get-Alias -Definition "Write-Host" -ErrorAction SilentlyContinue).Name

                if (($CommandAst.GetCommandName() -eq "Write-Host") -or
                    ($CommandAst.GetCommandName() -eq $alias)) {
                    $result = New-Object `
                        -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                        -ArgumentList $Messages.MeasureWriteHost, $CommandAst.Extent, $PSCmdlet.MyInvocation.InvocationName, Warning, $null

                    $results += $result
                }
            }

            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}


Set-Alias -Name Checklist -Value 'Invoke-InfspecChecklist' -Description 'Execute a infraspective Checklist'


function Invoke-InfspecChecklist {
    <#
.SYNOPSIS
    A collection of security controls to check against one or more systems.
    #>
    [OutputType('Infraspective.Checklist.ResultInfo')]
    [CmdletBinding()]
    param(
        # A unique name for this checklist
        [Parameter(
        )]
        [string]$Name,

        # A descriptive title for this checklist
        [Parameter(
        )]
        [string]$Title,

        # A unique version for this checklist
        [Parameter()]
        [version]$Version,

        # The checklist body containing controls
        [Parameter()]
        [scriptblock]$Body
    )

    begin {
        $config = $AuditState.Configuration
        $isDiscovery = $AuditState.Discovery

        Write-Log -Level INFO -Message "Evaluating checklist '$Name v$($Version.ToString())"

        if ($isDiscovery) {
            Write-Log -Level INFO -Message "Discovering"
            $chk = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Checklist'
                Name       = $Name
                Title      = $Title
                Version    = $Version
                Profiles   = @()
                Container  = $null
                Block      = $null
                Controls     = @()
                Children   = [System.Collections.Stack]@()
            }
        } else {
            Write-Log -Level INFO -Message "Running"
            $chk = [PSCustomObject]@{
                PSTypeName   = 'Infraspective.Checklist.ResultInfo'
                Name         = $Name
                Title        = $Title
                Version      = $Version
                Profile      = $null
                Result       = ''
                FailedCount  = 0
                PassedCount  = 0
                SkippedCount = 0
                NotRunCount  = 0
                TotalCount   = 0
                Groups       = @()
                Controls     = @()
            }

        }
    }
    process {
        if ($isDiscovery) {
            $chk.Block = $Body
            $currentContainer = $chk
            $currentLevel = 1
            try {
                $Body.InvokeWithContext( $AuditState.Functions,
                    $AuditState.Variables, $AuditState.Arguments) | Foreach-Object {
                    # The objects returned during discovery need to be added to the "AST".
                    #
                    # First, set Child to the current object.  This is mostly a convenience, because
                    # '$_' gets reset in the 'switch' down below
                    $Child = $_
                    # Next, Place the object in the appropriate spot in the "Tree"
                    $currentContainer.Children.Push($Child)
                    $Child.Container = $chk

                    switch -Exact ($child.PSobject.TypeNames[0]) {
                        'Infraspective.Group' {
                            $currentContainer = $Child
                            $currentLevel++
                        }
                        'Infraspective.Control' {
                            $chk.Controls += $Child
                        }
                    }
                }
            } catch {
                Write-Log -Level ERROR -Message "There was an error executing Checklist $($chk.Title)`n$_"
            }
        }

    }
    end {
        Write-Log -Level INFO -Message "Completed checklist '$Name v$($Version.ToString())'"
        $chk
    }
}

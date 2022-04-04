
Set-Alias -Name Checklist -Value 'Invoke-InfraspecChecklist' -Description 'Execute a infraspective Checklist'


function Invoke-InfraspecChecklist {
    <#
    .SYNOPSIS
        A collection of security controls to check against one or more systems.
    #>
    [OutputType('Infraspective.Checklist.ResultInfo')]
    [CmdletBinding()]
    param(
        # A unique name for this checklist
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Name,

        # The checklist body containing controls
        [Parameter(
            Mandatory,
            Position = 1
        )]
        [scriptblock]$Body,

        # A descriptive title for this checklist
        [Parameter(
        )]
        [string]$Title,

        # A unique version for this checklist
        [Parameter()]
        [version]$Version
    )

    begin {
        $config = $AuditState.Configuration
        $isDiscovery = $AuditState.Discovery


        if ($isDiscovery) {
            Write-Log -Level INFO -Message "Discovered checklist '$Name v$($Version.ToString())'"
            $chk = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Checklist'
                Name       = $Name
                Title      = $Title
                Version    = $Version
                Profiles   = @()
                Container  = $null
                Block      = $null
                Groups     = @()
                Controls   = @()
                Children   = [System.Collections.Stack]@()
            }
        } else {
            Write-Log -Level INFO -Message "Running checklist '$Name v$($Version.ToString())'"
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
        }
        try {
            $Body.InvokeWithContext( $AuditState.Functions,
                $AuditState.Variables, $AuditState.Arguments) | Foreach-Object {
                # The objects returned during discovery need to be added to the "AST".
                #
                # First, set Child to the current object.  This is mostly a convenience, because
                # '$_' gets reset in the 'switch' down below
                $Child = $_
                if ($isDiscovery) {
                    # Next, Place the object in the appropriate spot in the "Tree"
                    $chk.Children.Push($Child)
                    $Child.Container = $chk

                } else {
                    switch ($Child.Result) {
                        'Failed' {
                            $chk.FailedCount += $Child.FailedCount
                        }
                        'Passed' {
                            $chk.PassedCount += $Child.PassedCount
                        }
                        'Skipped' {
                            $chk.SkippedCount += $Child.SkippedCount
                        }
                        Default {
                            Write-Log -Level WARNING -Message "'$($Child.Name)' result is $($Child.Result)"
                        }
                    }
                    $chk.TotalCount += $Child.TotalCount

                    switch -regex ($Child.PSobject.TypeNames[0]) {
                        '^Infraspective.Group' {
                            Write-Log -Level DEBUG -Message "Setting Group $($Child.Name) As current container"
                            $chk.Groups += $Child
                        }
                        '^Infraspective.Control' {
                            Write-Log -Level DEBUG -Message "Adding control $($Child.Name)"
                            $chk.Controls += $Child
                        }
                    }
                }
            }
        } catch {
            Write-Log -Level ERROR -Message "There was an error executing Checklist $($chk.Title)`n$_"
        }

    }
    end {
        if ($isDiscovery) {
            Write-Log -Level DEBUG -Message "Completed Discovery of Checklist '$Name v$($Version.ToString())"
        } else {
            Write-Log -Level DEBUG -Message "Completed running Checklist '$Name v$($Version.ToString())"
            if ($chk.FailedCount -gt 0) {
                $chk.Result = 'Failed'
            } elseif ($chk.PassedCount -eq ($chk.TotalCount - $chk.SkippedCount)) {
                $chk.Result = 'Passed'
            } elseif ($chk.SkippedCount -eq $chk.TotalCount) {
                $chk.Result = 'Skipped'
            } else {
                $chk.Result = 'NotRun'
            }
        }
        $chk
    }
}


Set-Alias -Name Grouping -Value 'Invoke-InfraspecGroup' -Description 'A collection of infraspective controls'

function Invoke-InfraspecGroup {
    <#
    .SYNOPSIS
        A collection of security controls.
    .DESCRIPTION
        This function is aliased by the `Grouping` keyword and maps to the concept of a collection of Controls.

    #>
    [CmdletBinding()]
    param(
        # The name of the Grouping
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Name,

        # The controls associated with this Grouping
        [Parameter(
            Position = 1
        )]
        [ValidateNotNull()]
        [scriptblock]$Body,

        # The title of the Grouping
        [Parameter(
        )]
        [string]$Title,

        # The description of the Grouping
        [Parameter(
        )]
        [string]$Description
    )
    begin {
        $config = $AuditState.Configuration
        $isDiscovery = $AuditState.Discovery


        if ($isDiscovery) {
            Write-Log -Level INFO -Message "Discovered Group '$Name : $Title'"
            $grp = [PSCustomObject]@{
                PSTypeName  = 'Infraspective.Group'
                Name        = $Name
                Title       = $Title
                Description = $Description
                Block       = $null
                Container   = $null
                Groups      = @()
                Controls    = @()
                Children    = [System.Collections.Stack]@()
            }
        } else {
            Write-Log -Level INFO -Message "Running Group '$Name : $Title'"
            $grp = [PSCustomObject]@{
                PSTypeName   = 'Infraspective.Group.ResultInfo'
                Name         = $Name
                Title        = $Title
                Description  = $Description
                Result       = ''
                FailedCount  = 0
                PassedCount  = 0
                SkippedCount = 0
                NotRunCount  = 0
                TotalCount   = 0
                Groups      = @()
                Controls    = @()
            }
        }
    }
    process {
        if ($isDiscovery) {
            $grp.Block = $Body
        }
        try {
            $Body.InvokeWithContext($AuditState.Functions,
                $AuditState.Variables, $AuditState.Arguments) | Foreach-Object {
                $Child = $_
                if ($isDiscovery) {
                    # Next, Place the object in the appropriate spot in the "Tree"
                    $grp.Children.Push($Child)
                    $Child.Container = $grp

                } else {
                    switch ($Child.Result) {
                        'Failed' {
                            $grp.FailedCount += $Child.FailedCount
                        }
                        'Passed' {
                            $grp.PassedCount += $Child.PassedCount
                        }
                        'Skipped' {
                            $grp.SkippedCount += $Child.SkippedCount
                        }
                        Default {
                            Write-Log -Level WARNING -Message "'$($Child.Name)' result is $($Child.Result)"
                        }
                    }
                    $grp.TotalCount += $Child.TotalCount

                    switch -regex ($Child.PSobject.TypeNames[0]) {
                        '^Infraspective.Group' {
                            Write-Log -Level DEBUG -Message "Setting Group $($Child.Name) As current container"
                            $grp.Groups += $Child
                        }
                        '^Infraspective.Control' {
                            Write-Log -Level DEBUG -Message "Adding control $($Child.Name)"
                            $grp.Controls += $Child
                        }
                    }
                }
            }
        } catch {
            Write-Log -Level ERROR -Message "There was an error executing Group $($grp.Title)`n$_"
        }

    }
    end {
        if ($isDiscovery) {
            Write-Log -Level DEBUG -Message "Completed Discovery of Group '$Name'"
        } else {
            if ($grp.FailedCount -gt 0) {
                $grp.Result = 'Failed'
            } elseif ($grp.PassedCount -eq ($grp.TotalCount - $grp.SkippedCount)) {
                $grp.Result = 'Passed'
            } elseif ($grp.SkippedCount -eq $grp.TotalCount) {
                $grp.Result = 'Skipped'
            } else {
                $grp.Result = 'NotRun'
            }
            Write-Log -Level INFO -Message "Completed checklist '$Name v$($Version.ToString())'"
        }
        $grp
    }
}

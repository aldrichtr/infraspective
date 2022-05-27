
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
        if ($null -eq $audit_state) {
            Write-Log -Level WARNING -Message "Audit state missing.  Was $($MyInvocation.MyCommand.Name) invoked directly?"

            $audit_state = New-InfraspecAuditState
        }

        Write-Log -Level INFO -Message "Group '$Name : $Title' start"
        $grp = [PSCustomObject]@{
            PSTypeName   = 'Infraspective.Group.ResultInfo'
            Name         = $Name
            Title        = $Title
            Description  = $Description
            Result       = $null
            FailedCount  = 0
            PassedCount  = 0
            SkippedCount = 0
            NotRunCount  = 0
            TotalCount   = 0
            Groups       = @{
                Passed  = @()
                Failed  = @()
                Skipped = @()
            }
            Controls     = @{
                Passed  = @()
                Failed  = @()
                Skipped = @()
            }
        }
    }
    process {
        try {
            $audit_state.Depth += 1
            Write-Result Grouping 'Start' "Group $Name : $Title"
            Write-Log -Level DEBUG -Message "Invoking Body of Group $Name"
            $counter = 1
            $Body.InvokeWithContext($audit_state.Functions,
                $audit_state.Variables, $audit_state.Arguments) | Foreach-Object {
                $Child = $_
                Write-Log -Level DEBUG -Message "Result #$counter : $($Child.Result)"
                switch -regex ($Child.PSobject.TypeNames[0]) {
                    '^Infraspective.Control' {
                        Write-Log -Level DEBUG -Message "Adding control $($Child.Name)"
                        $grp.TotalCount += 1
                        switch ($Child.Result) {
                            'Failed' {
                                $grp.Controls.Failed += $Child
                                $grp.Result = 'Failed'
                                $grp.FailedCount += 1
                                continue
                            }
                            'Passed' {
                                if ($null -like $grp.Result) { $grp.Result = 'Passed' }
                                $grp.Controls.Passed += $Child
                                $grp.PassedCount += 1
                                continue
                            }
                            'Skipped' {
                                if ($null -like $grp.Result) { $grp.Result = 'Skipped' }
                                $grp.Controls.Skipped += $Child
                                $grp.SkippedCount += 1
                                continue
                            }
                            Default {
                                Write-Log -Level WARNING -Message "'$($Child.Name)' unhandled result: '$($Child.Result)'"
                            }
                        }
                    }
                    '^Infraspective.Group' {
                        Write-Log -Level DEBUG -Message "Setting Group $($Child.Name) As current container"
                        $grp.TotalCount   += $Child.TotalCount
                        $grp.FailedCount  += $Child.FailedCount
                        $grp.PassedCount  += $Child.PassedCount
                        $grp.SkippedCount += $Child.SkippedCount
                        switch ($Child.Result) {
                            'Failed' {
                                $grp.Groups.Failed += $Child
                                $grp.Result = 'Failed'
                                continue
                            }
                            'Passed' {
                                if (-not($grp.Result)) { $grp.Result = 'Passed' }
                                $grp.Groups.Passed += $Child
                                continue
                            }
                            'Skipped' {
                                if (-not($grp.Result)) { $grp.Result = 'Skipped' }
                                $grp.Groups.Skipped += $Child
                                continue
                            }
                            Default {
                                Write-Log -Level WARNING -Message "'$($Child.Name)' unhandled result: '$($Child.Result)'"
                            }
                        }
                    }
                }
            }
            $counter++
        } catch {
            Write-Log -Level ERROR -Message "There was an error executing Group $($grp.Title)`n$_"
        }
    }
    end {
        # Ensure the appropriate Result is set
        if ($grp.FailedCount -gt 0) {
            $grp.Result = 'Failed'
        } elseif ($grp.PassedCount -eq ($grp.TotalCount - $grp.SkippedCount)) {
            $grp.Result = 'Passed'
        } elseif ($grp.SkippedCount -eq $grp.TotalCount) {
            $grp.Result = 'Skipped'
        } else {
            $grp.Result = 'NotRun'
        }
        Write-Result Grouping 'End' "Group $Name $Title" -Stats @{
            Total   = $grp.TotalCount
            Failed  = $grp.FailedCount
            Passed  = $grp.PassedCount
            Skipped = $grp.SkippedCount
        }

        $audit_state.Depth -= 1
        Write-Log -Level INFO -Message "Group '$Name $Title' complete"
        $grp
    }
}

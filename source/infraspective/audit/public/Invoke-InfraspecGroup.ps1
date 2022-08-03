
Set-Alias -Name Grouping -Value 'Invoke-InfraspecGroup' -Description 'A collection of infraspective controls'

function Invoke-InfraspecGroup {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [string]$Name,

        [Parameter(
            Position = 2
        )]
        [ValidateNotNull()]
        [scriptblock]$Body,

        [Parameter(
        )]
        [string]$Title,

        [Parameter(
        )]
        [string]$Description
    )
    begin {
        $log_option = @{
            Scope = 'Group'
            Level = 'INFO'
            Message = ''
            Arguments = ''
        }

        if ($null -eq $audit_state) {
            Write-CustomLog @log_option -Level WARNING -Message "Audit state missing.  Was $($MyInvocation.MyCommand.Name) invoked directly?"

            $audit_state = New-InfraspecAuditState
        }

        Write-CustomLog @log_option -Message "Group '$Name : $Title' start"
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

            $result_options = $PSBoundParameters
            $null = $result_options.Remove('Body')

            Write-Result Grouping 'Start' -Data $result_options

            Write-CustomLog @log_option -Level DEBUG -Message "Invoking Body of Group $Name"
            $counter = 1
            $Body.InvokeWithContext($audit_state.Functions,
                $audit_state.Variables, $audit_state.Arguments) | Foreach-Object {
                $Child = $_
                Write-CustomLog @log_option -Level DEBUG -Message "Result #$counter : $($Child.Result)"
                switch -regex ($Child.PSobject.TypeNames[0]) {
                    '^Infraspective.Control' {
                        Write-CustomLog @log_option -Level DEBUG -Message "Adding control $($Child.Name)"
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
                                Write-CustomLog @log_option -Level WARNING -Message "'$($Child.Name)' unhandled result: '$($Child.Result)'"
                            }
                        }
                    }
                    '^Infraspective.Group' {
                        Write-CustomLog @log_option -Level DEBUG -Message "Setting Group $($Child.Name) As current container"
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
                                Write-CustomLog @log_option -Level WARNING -Message "'$($Child.Name)' unhandled result: '$($Child.Result)'"
                            }
                        }
                    }
                }
            }
            $counter++
        } catch {
            Write-CustomLog @log_option -Level ERROR -Message "There was an error executing Group $($grp.Title)`n$_"
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


        $result_options['Total']   = $grp.TotalCount
        $result_options['Failed']  = $grp.FailedCount
        $result_options['Passed']  = $grp.PassedCount
        $result_options['Skipped'] = $grp.SkippedCount

        Write-Result Checklist 'End' -Data $result_options

        $audit_state.Depth -= 1
        Write-CustomLog @log_option -Message "Group '$Name $Title' complete"
        $grp
    }
}

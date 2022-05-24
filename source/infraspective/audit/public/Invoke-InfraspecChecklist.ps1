
Set-Alias -Name Checklist -Value 'Invoke-InfraspecChecklist' -Description 'Execute a infraspective Checklist'


function Invoke-InfraspecChecklist {
    <#
    .SYNOPSIS
        A collection of security controls to check against one or more systems.
    .DESCRIPTION
        A collection of Groupings, and or Controls.
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
        if ($null -eq $audit_state) {
            Write-Log -Level WARNING -Message "Audit state missing.  Was $($MyInvocation.MyCommand.Name) invoked directly?"

            $audit_state = New-InfraspecAuditState
        }

        Write-Log -Level INFO -Message "Checklist '$Name v$($Version.ToString())' start"
        $chk = [PSCustomObject]@{
            PSTypeName   = 'Infraspective.Checklist.ResultInfo'
            Container    = $null
            Path         = ""
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
            Write-Result Checklist 'Start' "Checklist '$Name v$($Version.ToString())'"
            $counter = 1
            $Body.InvokeWithContext( $audit_state.Functions,
                $audit_state.Variables, $audit_state.Arguments) | Foreach-Object {
                    $Child = $_
                    Write-Log -Level DEBUG -Message "Result #$counter : $($Child.Result)"
                switch -regex ($Child.PSobject.TypeNames[0]) {
                    '^Infraspective.Control' {
                        Write-Log -Level DEBUG -Message "Adding control $($Child.Name)"
                        $chk.TotalCount += 1
                        switch ($Child.Result) {
                            'Failed' {
                                $chk.Controls.Failed += $Child
                                $chk.Result = 'Failed'
                                $chk.FailedCount += 1
                                continue
                            }
                            'Passed' {
                                if (-not($chk.Result)) { $chk.Result = 'Passed' }
                                $chk.Controls.Passed += $Child
                                $chk.PassedCount += 1
                                continue
                            }
                            'Skipped' {
                                if (-not($chk.Result)) { $chk.Result = 'Skipped' }
                                $chk.Controls.Skipped += $Child
                                $chk.SkippedCount += 1
                                continue
                            }
                            Default {
                                Write-Log -Level WARNING -Message "'$($Child.Name)' unhandled result: '$($Child.Result)'"
                            }
                        }
                    }
                    '^Infraspective.Group' {
                        Write-Log -Level DEBUG -Message "Setting Group $($Child.Name) As current container"
                        $chk.TotalCount += $Child.TotalCount
                        $chk.FailedCount += $Child.FailedCount
                        $chk.PassedCount += $Child.PassedCount
                        $chk.SkippedCount += $Child.SkippedCount
                        switch ($Child.Result) {
                            'Failed' {
                                $chk.Groups.Failed += $Child
                                $chk.Result = 'Failed'
                                continue
                            }
                            'Passed' {
                                if (-not($chk.Result)) { $chk.Result = 'Passed' }
                                $chk.Groups.Passed += $Child
                                continue
                            }
                            'Skipped' {
                                if (-not($chk.Result)) { $chk.Result = 'Skipped' }
                                $chk.Groups.Skipped += $Child
                                continue
                            }
                            Default {
                                Write-Log -Level WARNING -Message "'$($Child.Name)' unhandled result: '$($Child.Result)'"
                            }
                        }
                    }
                }

                $counter++
            }
        } catch {
            Write-Log -Level ERROR -Message ((
                "There was an error executing Checklist $($chk.Title)",
                $_,
                "$($MyInvocation.ScriptName):$($MyInvocation.ScriptLineNumber)"
                ) -join "`n")
        }

    }
    end {
        if ($chk.FailedCount -gt 0) {
            $chk.Result = 'Failed'
        } elseif ($chk.PassedCount -eq ($chk.TotalCount - $chk.SkippedCount)) {
            $chk.Result = 'Passed'
        } elseif ($chk.SkippedCount -eq $chk.TotalCount) {
            $chk.Result = 'Skipped'
        } else {
            $chk.Result = 'NotRun'
        }
        Write-Log -Level INFO -Message "Checklist '$Name v$($Version.ToString()) complete"
        Write-Result Checklist 'End' "Checklist $Name v$($Version.ToString())" -Stats @{
            Total  = $chk.TotalCount
            Failed = $chk.FailedCount
            Passed = $chk.PassedCount
            Skipped = $chk.SkippedCount
        }
        $audit_state.Depth -= 1
        $chk
    }
}

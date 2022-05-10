
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
        Write-Log -Level INFO -Message "Group '$Name : $Title' start"
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
            Groups       = @()
            Controls     = @()
        }
    }
    process {
        try {
            Write-Log -Level DEBUG -Message "Invoking Body of Group $Name"
            $counter = 1
            $Body.InvokeWithContext($AuditState.Functions,
                $AuditState.Variables, $AuditState.Arguments) | Foreach-Object {
                $Child = $_
                Write-Log -Level DEBUG -Message "Result #$counter : $($Child.Result)"
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
                $counter++
            }
        } catch {
            Write-Log -Level ERROR -Message "There was an error executing Group $($grp.Title)`n$_"
        }
    }
    end {
        if ($grp.FailedCount -gt 0) {
            $grp.Result = 'Failed'
        } elseif ($grp.PassedCount -eq ($grp.TotalCount - $grp.SkippedCount)) {
            $grp.Result = 'Passed'
        } elseif ($grp.SkippedCount -eq $grp.TotalCount) {
            $grp.Result = 'Skipped'
        } else {
            $grp.Result = 'NotRun'
        }
        Write-Log -Level INFO -Message "Group '$Name $Title' complete"
        $grp
    }
}
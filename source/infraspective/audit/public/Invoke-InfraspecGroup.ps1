
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

        # The title of the Grouping
        [Parameter(
        )]
        [string]$Title = "",

        # The description of the Grouping
        [Parameter(
        )]
        [string]$Description = "",

        # The controls associated with this Grouping
        [Parameter(
            Position = 1
        )]
        [ValidateNotNull()]
        [scriptblock]$Body
    )
    begin {
        $config = $AuditState.Configuration
        $isDiscovery = $AuditState.Discovery

        Write-Log -Level INFO -Message "Evaluating Group '$Name : $Title'"

        if ($isDiscovery) {
            Write-Log -Level INFO -Message "Discovering"
            $grp = [PSCustomObject]@{
                PSTypeName  = 'Infraspective.Group'
                Name        = $Name
                Title       = $Title
                Description = $Description
                Block       = $null
                Container   = $null
                Controls    = @()
                Children    = [System.Collections.Stack]@()
            }
        } else {
            Write-Log -Level INFO -Message "Running"
            $grp = [PSCustomObject]@{
                PSTypeName   = 'Infraspective.Group.ResultInfo'
                Name         = $Name
                Title        = $Title
                Description  = $Description
                Version      = $Version
                Result       = ''
                FailedCount  = 0
                PassedCount  = 0
                SkippedCount = 0
                NotRunCount  = 0
                TotalCount   = 0
            }
        }
    }
    process {
        if ($isDiscovery) {
            $grp.Block = $Body
            # We process the AST up in the Checklist, so just return the object to the pipeline,
            # and any objects in the body as well
            $grp | Write-Output
            $Body.InvokeWithContext($AuditState.Functions,
                $AuditState.Variables, $AuditState.Arguments) | Write-Output
        }

    }
    end {
    }
}

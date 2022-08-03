
Set-Alias -Name Control -Value 'Invoke-InfraspecControl' -Description 'Execute a infraspective Control'

Function Invoke-InfraspecControl {
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
        [string]$Impact,

        [Parameter(
        )]
        [string]$Title,

        [Parameter(
        )]
        [string[]]$Reference,

        [Parameter(
        )]
        [string[]]$Tags,

        [Parameter(
        )]
        [string]$Resource,

        # An optional description of the test
        [Parameter(
        )]
        [string[]]$Description
    )
    begin {
        $log_option = @{
            Scope     = 'Control'
            Level     = 'INFO'
            Message   = ''
            Arguments = ''
        }
        if ($null -eq $audit_state) {
            Write-CustomLog @log_option -Level WARNING -Message "Audit state missing.  Was $($MyInvocation.MyCommand.Name) invoked directly?"

            $audit_state = New-InfraspecAuditState
        }

        Write-CustomLog @log_option -Message "Control '$Name' start"
        $ctl = [PSCustomObject]@{
            PSTypeName   = 'Infraspective.Control.ResultInfo'
            Result       = $null
            FailedCount  = 0
            PassedCount  = 0
            SkippedCount = 0
            NotRunCount  = 0
            TotalCount   = 0
            Duration     = 0
            Tests        = @()
            Name         = $Name
            Title        = $Title
            Description  = $Description
            Impact       = $Impact
            Tags         = $Tags
            Reference    = $Reference
            Resource     = $Resource
        }
        try {
            $PesterContainer = New-PesterContainer -ScriptBlock $Body
        } catch {
            Write-CustomLog @log_option -Level ERROR -Message "Failed to create Pester Container with scriptblock`n--`n$Body`n--`n$_"
        }
        function processBlock {
            param(
                [Parameter(
                    Mandatory,
                    Position = 0
                )]
                [object]$Block
            )
            $audit_state.Depth += 1
            Write-Result Block 'Start' -Data @{ Name = $block.Name }
            if ($block.Tests.Count -gt 0) {
                foreach ($t in $block.Tests) {
                    $audit_state.Depth += 1
                    Write-Result Test $t.Result -Data @{ Name = $t.Name }
                    $audit_state.Depth -= 1
                }
            }
            if ($block.Blocks.Count -gt 0) {
                foreach ($b in $block.Blocks) {
                    processBlock $b
                }
            }
            Write-Result Block $block.Result -Data @{ Name = $block.Name }
            $audit_state.Depth -= 1

        }

    }
    process {

        $result_options = $PSBoundParameters
        $null = $result_options.Remove('Body')

        $audit_state.Depth += 1
        Write-Result Control 'Start' -Data $result_options
        Write-CustomLog @log_option -Level DEBUG -Message 'Invoking Pester on tests'
        Invoke-Pester -Container $PesterContainer -Output 'None' -PassThru | ForEach-Object {
            $pester = $_
            Write-CustomLog @log_option -Message "Control $Name test result: $($pester.Result)"

            $ctl.Result       = $pester.Result
            $ctl.FailedCount  = $pester.FailedCount
            $ctl.PassedCount  = $pester.PassedCount
            $ctl.SkippedCount = $pester.SkippedCount
            $ctl.NotRunCount  = $pester.NotRunCount
            $ctl.TotalCount   = $pester.TotalCount
            $ctl.Duration     = $pester.Duration
            $ctl.Tests        = $pester.Tests
            $pester.Containers[0].Blocks | ForEach-Object { processBlock $_ }
        }
    }
    end {
        $result_options['Duration'] = $audit_state.AuditTimer
        $result_options['Total']    = $pester.TotalCount
        $result_options['Failed']   = $pester.FailedCount
        $result_options['Skipped']  = $pester.SkippedCount
        $result_options['Passed']   = $pester.PassedCount
        $result_options['Name']     = $Name

        Write-Result Control 'End' -Data $result_options
        $audit_state.Depth -= 1

        Write-CustomLog @log_option -Message "Control '$Name' complete"
        $ctl
    }
}

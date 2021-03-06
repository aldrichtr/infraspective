
Set-Alias -Name Control -Value 'Invoke-InfraspecControl' -Description 'Execute a infraspective Control'

Function Invoke-InfraspecControl {
    <#
.SYNOPSIS
    A security control consisting of one or more tests and metadata about the test.
.DESCRIPTION
    This function is aliased by the `Control` keyword, and maps directly to the concept of a Security Control found
    in many frameworks such as CIS, STIG, HIPAA, etc.  A control consists of one or more tests, such as the
    existence of a file permission, or the status of a service and maps that to a recommended setting for that test
    found in one of those frameworks, or your corporate or personal security policy.

    A passing test(s) means that the system under test complies with the given control, while a failing test means
    that the system is not in compliance
    The tests are regular Pester tests, using the standard "Describe/Context/It/Should" keywords.  These tests are
    passed directly to Pester (Invoke-Pester) and the results are returned.

.EXAMPLE
    ``` powershell
    Control "xccdf_blah" -Resource "Windows" -Impact 1 -Reference 'CVE:123' {
        Describe "cis control 123" {
            It "Should have foo set to bar" {
                $p.foo | Should -Be "bar"
            }
        }
    }
    ```
    #>
    [CmdletBinding()]
    param(
        # The unique ID for this control
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        # The tests associated with this control
        [Parameter(Position = 1)]
        [ValidateNotNull()]
        [scriptblock]$Body,

        # The criticality, if this control fails
        [Parameter(
        )]
        [string]$Impact,

        # The human readable title
        [Parameter()]
        [string]$Title,

        # References to external tools and databases
        [Parameter()]
        [string[]]$Reference,

        # Tags associated with this control
        [Parameter()]
        [string[]]$Tags,

        # The type of resource to test
        [Parameter()]
        [string]$Resource,

        # An optional description of the test
        [Parameter()]
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

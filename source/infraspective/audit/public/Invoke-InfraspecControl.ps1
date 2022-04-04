
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
            ValueFromPipeline
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
        [string[]]
        $Tags,

        # The type of resource to test
        [Parameter()]
        [string]$Resource,

        # An optional description of the test
        [Parameter()]
        [string[]]$Description
    )
    begin {
        $config = $AuditState.Configuration
        $isDiscovery = $AuditState.Discovery

        if ($isDiscovery) {
            Write-Log -Level INFO -Message "Discovered control '$Name : $Title'"
            $ctl = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Control'
                Name       = $Name
                Title      = $Title
                Version    = $Version
                Profiles   = @()
                Container  = $null
                Block      = $null
                Children   = [System.Collections.Stack]@()
            }
        } else {
            Write-Log -Level INFO -Message "Running control '$Name : $Title'"
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
                Write-Log -Level ERROR -Message "Failed to create Pester Container with scriptblock`n--`n$Body`n--`n$_"
            }
        }

    }
    process {
        Write-Log -Level DEBUG -Message "Discovery : $isDiscovery"
        if ($isDiscovery) {
            $ctl.Block = $Body
        } else {
            Write-Log -Level DEBUG -Message "Invoking Pester on tests"
            Invoke-Pester -Container $PesterContainer -Output 'None' -PassThru | Foreach-Object {
                $pester_result = $_
                Write-Log -Level INFO -Message "Control $Name test result: $($pester_result.Result)"
                $ctl.Result       = $pester_result.Result
                $ctl.FailedCount  = $pester_result.FailedCount
                $ctl.PassedCount  = $pester_result.PassedCount
                $ctl.SkippedCount = $pester_result.SkippedCount
                $ctl.NotRunCount  = $pester_result.NotRunCount
                $ctl.TotalCount   = $pester_result.TotalCount
                $ctl.Duration     = $pester_result.Duration
                $ctl.Tests        = $pester_result.Tests

            }
        }
    }
    end {
        $ctl
    }
}

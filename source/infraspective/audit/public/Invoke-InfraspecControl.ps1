
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
        [string[]]$Description,

        # The tests associated with this control
        [Parameter(Position = 1)]
        [ValidateNotNull()]
        [scriptblock]$Test
    )
    begin {
        $config = New-PesterConfiguration @{
            Run = @{
                PassThru = $true
            }
            Output = @{
                Verbosity = 'None'
            }
        }
    }
    process {
        $container = New-PesterContainer -ScriptBlock $Test

        $pester_result = Invoke-Pester -Container $container -Output 'None' -PassThru


        <#------------------------------------------------------------------
          TODO: Can I just splat the PSBoundParameters here?
        ------------------------------------------------------------------#>
        $result = [PSCustomObject]@{
            PSTypeName   = 'Infraspective.Control.ResultInfo'
            Result       = $pester_result.Result
            FailedCount  = $pester_result.FailedCount
            PassedCount  = $pester_result.PassedCount
            SkippedCount = $pester_result.SkippedCount
            NotRunCount  = $pester_result.NotRunCount
            TotalCount   = $pester_result.TotalCount
            Duration     = $pester_result.Duration
            Tests        = $pester_result.Tests
            Name         = $Name
            Title        = $Title
            Description  = $Description
            Impact       = $Impact
            Tags         = $Tags
            Reference    = $Reference
            Resource     = $Resource
        }
    }
    end {
        $result
    }
}

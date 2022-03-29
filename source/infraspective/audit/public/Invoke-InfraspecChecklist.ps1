
Set-Alias -Name Checklist -Value 'Invoke-InfspecChecklist' -Description 'Execute a infraspective Checklist'


function Invoke-InfspecChecklist {
    <#
.SYNOPSIS
    A collection of security controls to check against one or more systems.
    #>
    [OutputType('Infraspective.Checklist.ResultInfo')]
    [CmdletBinding()]
    param(
        # A unique name for this checklist
        [Parameter(
        )]
        [string]$Name,

        # A descriptive title for this checklist
        [Parameter(
        )]
        [string]$Title,

        # A unique version for this checklist
        [Parameter()]
        [version]$Version,

        # The checklist body containing controls
        [Parameter()]
        [scriptblock]$Body,

        <# The Session object has three components
           - Functions : a Hash of functions to provide to the controls
           - Variables : An array of Variables to provide to the controls
           - Arguments : Any runtime arguments to be passed in.
        #>
        [Parameter()]
        [Object]$Session
    )

    begin {
        $config = Import-Configuration
        Write-Log -Level INFO -Message "Evaluating checklist '$Name v$($Version.ToString())"
        $chk = [PSCustomObject]@{
            PSTypeName = 'Infraspective.Checklist.ResultInfo'
            Name       = $Name
            Title      = $Title
            Version    = $Version
            Result     = ''
            FailedCount  = 0
            PassedCount  = 0
            SkippedCount = 0
            NotRunCount  = 0
            TotalCount   = 0
            Controls   = @()
        }

        <#
        If we want to provide the Controls with any session information, we can do that when we invoke the
        scriptblock.  This way, we can pass in any type of data we may need, including functions, variables or
        arguments
        #>
        $functionsToDefine = @{}
        [System.Collections.Generic.List[PSVariable]]$variablesToDefine = @()
        [Object[]]$invocationArgs = @()

    }
    process {
        try {
            <#
             Making a design decision here, using the ternary operator '?' rather than a big if / else
             Which forces Powershell Core 7.
            #>
            $functionsToDefine = $PSBoundParameters['Session'] ? $Session.Functions : @{}
            $variablesToDefine = $PSBoundParameters['Session'] ? $Session.Variables : @()
            $invocationArgs    = $PSBoundParameters['Session'] ? $Session.Arguments : @()

            $Body.InvokeWithContext( $functionsToDefine, $variablesToDefine, $invocationArgs ) | Foreach-Object {
                $c = $_ # Output of the Controls, tests, etc. defined in the Checklist body.
                switch ($c.Result) {
                    'Failed' {
                        $chk.FailedCount++
                    }
                    'Passed' {
                        $chk.PassedCount++
                    }
                    'Skipped' {
                        $chk.SkippedCount++
                    }
                    Default {
                        Write-Log -Level WARNING -Message "Control '$($c.Name)' result is $($c.Result)"
                    }
                }
                $chk.TotalCount++
                $chk.Controls += $c
            }

            if ($chk.FailedCount -gt 0) {
                $chk.Result = 'Failed'
            }
            elseif ($chk.PassedCount -eq ($chk.TotalCount - $chk.SkippedCount)) {
                $chk.Result = 'Passed'
            }
            elseif ($chk.SkippedCount -eq $chk.TotalCount) {
                $chk.Result = 'Skipped'
            }
            else {
                $chk.Result = 'NotRun'
            }
        } catch {
            Write-Log -Level ERROR -Message "There was an error with checklist '$Name-$($Version.ToString())'`n$_"
        }
    }
    end {
        Write-Log -Level INFO -Message "Completed checklist '$Name v$($Version.ToString())"
        $chk
    }
}

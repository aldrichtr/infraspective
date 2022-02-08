
Set-Alias -Name Checklist -Value 'Invoke-InfspecChecklist' -Description 'Execute a infraspective Checklist'


function Invoke-InfspecChecklist {
    <#
.SYNOPSIS
    A collection of security controls to check against one or more systems.
    #>
    [CmdletBinding()]
    param(
        # A unique name for this checklist
        [Parameter()]
        [string]$Name,

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
            Name    = $Name
            Version = $Version
            Result  = @()
        }

        <#
        If we want to provide the Controls with any session information, we can do that when we invoke the
        scriptblock.  This way, we can pass in any type of data we may need, including functions, variables or
        arguments
        #>
        $functionsToDefine = @{}
        [System.Collections.Generic.List[PSVariable]]$variablesToDefine = @()
        [Object[]]$invocationArgs    = @()

    }
    process {
        try {
            <#
             Making a design decision here, using the ternary operator '?' rather than a big if / else
            #>
            $functionsToDefine = $PSBoundParameters['Session'] ? $Session.Functions : @{}
            $variablesToDefine = $PSBoundParameters['Session'] ? $Session.Variables : @()
            $invocationArgs    = $PSBoundParameters['Session'] ? $Session.Arguments : @()
            $chk.Result = $Body.InvokeWithContext( $functionsToDefine, $variablesToDefine, $invocationArgs )

        } catch {
            Write-Log -Level ERROR -Message "There was an error with checklist '$Name-$($Version.ToString())'`n$_"
        }
    }
    end {
        Write-Log -Level INFO -Message "Completed checklist '$Name v$($Version.ToString())"
        $chk
    }
}

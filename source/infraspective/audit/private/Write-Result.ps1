
function Write-Result {
    <#
    .SYNOPSIS
        Write the results to the screen
    .DESCRIPTION
        `Write-Result` sends formatted output to the Information stream (6).  The format
        of the output is controlled by the 'Output' key in the Configuration settings.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        # Scope of result.  'File', 'Checklist', etc.
        # See also: about_infraspective_output
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [ResultScope]$Scope,

        # Type of Event. 'Start', 'End', 'Pass', 'Fail', 'Skip', etc.
        # See also: about_infraspective_configuration
        [Parameter(
            Mandatory,
            Position = 1
        )]
        [string]$Type,

        # Each Element passes their Parameters, Statistics and other Metadata in a HashTable
        # so that it can be used in the Output template.  For example:
        # Data.Impact = 1 would be available as <%= $Impact %>
        [Parameter()]
        [hashtable]$Data

    )
    begin {
        $config = $audit_state.Configuration.Output
        $map = $config.StatusMap

        # audit_state is initialized in `Invoke-Infraspective`, and each infraspective Element
        # increments and decrements the Depth accordingly
        $output = ($map.Leader * $audit_state.Depth)

        # Used to control the level of Results
        $max_scope = ([ResultScope]$config.Scope).value__
    }
    process {
        # check to see if the requested Scope is higher than the configured scope
        # break early if it isnt
        $this_scope = $Scope.value__
        if ($this_scope -gt $max_scope) { return }

        # Add these to 'Data' for use in the template
        $Data['Scope'] = $Scope
        $Data['Type']  = $Type
        ## Templates can access the config using $Map.Leader, etc.
        ## Means arbitrary items can be added to the map
        ## StatusMap.Ticket = '#INC1234'
        ## and then used like
        ## Related to ticket: <%= $Map.Ticket %>
        $Data['Map']   = $map


        if (($map.Keys -contains $Scope) -and
            ($map."$Scope".Keys -contains $Type)) {
            Write-CustomLog -Scope 'Result' -Level 'DEBUG' -Message '{0} has custom format for {1}' -Arguments $Scope, $Type
            # only replace the keys that are present in the Scope "Custom" config
            foreach ($k in $map."$Scope".Keys) {
                $map."$k" = $map."$Scope"."$k"
            }
        }

        $fmt = Invoke-EpsTemplate -Template $map["$Type"].Format -Safe -Binding $Data

        if (-not($map."$Type".Render ?? $map.Default.Render)) {
            Write-CustomLog -Scope 'Result' -Level 'DEBUG' -Message "Entities will not be rendered for $Scope $Type"
        }

        $text_options = @{
            Object          = $ExecutionContext.InvokeCommand.ExpandString($fmt)
            ForegroundColor = $map."$Type".Foreground    ?? $map.Default.Foreground
            BackgroundColor = $map."$Type".Background    ?? $map.Default.Background
            IgnoreEntities  = (-not ($map."$Type".Render ?? $map.Default.Render))
            LeaveColor      = (-not ($map."$Type".Reset  ?? $map.Default.Reset))
        }
        # Note we are appending the results of the `New-Text` to the indent above
        $text = New-Text @text_options
        $output += $text.ToString()
    }
    end {
        Write-Information $output -InformationAction Continue
    }
}

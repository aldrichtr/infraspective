<#
in [PlatyPS.psm1](https://github.com/PowerShell/platyPS/blob/master/src/platyPS/platyPS.psm1)

starting on line 1528

```powershell

    if ($IncludeModulePage)
    {
        $filter = '*.md'
    }
    else
    {
        $filter = '*-*.md'
    }

    $aboutFilePrefixPattern = 'about_*'

Any md file that is not '*-*.md' is not going to be picked up by the filter



The next issue I need to figure out is why the help system is still using the comment help instead of
the markdown.  The Example titles are not being used.
#>




Document 'MarkdownHelp' {
    $ENABLE_DEBUG_OUTPUT = $false

    $common_params = @(
        'Debug',
        'ErrorAction',
        'ErrorVariable',
        'InformationAction',
        'InformationVariable',
        'OutVariable',
        'OutBuffer',
        'PipelineVariable',
        'Verbose',
        'WarningAction',
        'WarningVariable'
    )

    $h = $InputObject
    <#------------------------------------------------------------------
      Content starts here
    ------------------------------------------------------------------#>
    Metadata @{
        'external help file' = "$($h.ModuleName)-help.xml"
        'Module Name'        = $h.ModuleName
        'online version'     = "https://github.com/aldrichtr/infraspective/blob/main/docs/help/$($h.Name).md"
        'schema'             = '2.0.0'
    }

    Title $h.Name

    Section 'SYNOPSIS' {
        $h.Synopsis
    }

    Section 'SYNTAX' {
        $ENABLE_DEBUG_OUTPUT = $false

        for ($i = 0; $i -lt $h.ParameterSets.count; $i++) {
            $debug_string = "DEBUG for Syntax $i $('-' * 20)`n"
            $set = $h.ParameterSets[$i]
            if ($set.Name -match '__AllParameterSets') {
                $syntax_name = 'Default'
            } else {
                $syntax_name = $set.Name
            }

            if ($set.IsDefault) { $syntax_name += ' (Default)' }

            # The syntax string starts with the command name
            $syntax = '{0} {1}' -f $h.Name, $set.ToString()

            Section $syntax_name {
                $ENABLE_DEBUG_OUTPUT ? $debug_string : $null
                $syntax | Code -Info 'powershell'
            }
        }
        #>
        $ENABLE_DEBUG_OUTPUT = $false
    }

    Section 'DESCRIPTION' { $h.Description.Text }

    Section 'EXAMPLES' {
        # each EXAMPLE section consists of:
        # 1 or more non-blank lines is interpreted as the actual example code == .code property
        #
        # all lines of text are split by blank lines into the .remarks array property
        #  note that two consecutive blank lines will create a .remarks entry with a blank line.
        ##
        # My conventions for Example text
        # Place the actual example on the first line, continuing on to as many contiguous lines
        # as necessary
        # leave one blank line after the code
        # if output should be on a separate line, mark it with '```Output' line
        # every line up to the next ``` is considered "Output Code block"
        # leave one blank line after the output
        # To add a title to the Example, write a line with 'Title:' at the start
        # leave one blank line after the Title
        # Add anything you want after that

        :example foreach ($example in $h.examples.example) {
            $null = $example.Title -match 'EXAMPLE (\d+)'
            $num = $Matches.1
            $output_code = @()
            $commentary = @()
            $debug_string = "DEBUG:$('-' * 10)`nFor Example number $num`n"

            :contents foreach ($remark in $example.remarks) {
                # if the remark is just full of blanks, we don't need to save it and
                # each 'section' of the remark is separated by blank lines, and we want to
                # remove those, so set a flag to determine if the blank is significant or
                # not
                $skip_next_blank = $false
                $has_content = $false
                $lines = $remark.Text -split '\n'

                $debug_string += "remark $($example.remarks.IndexOf($remark)) has $($lines.Count) lines`n"
                :lines foreach ($line in $lines) {
                    $line_number = $lines.IndexOf($line)
                    $debug_string += " $line_number This line is '$line'`n"
                    switch -regex ($line) {
                        '^```Output' {
                            #starting an output code section, that needs to go after the code.
                            $output = $true
                            $debug_string += "  found output on line $line_number`n"
                        }
                        '^```$' {
                            $skip_next_blank = $true
                            # we found the end of the output, turn off output processing
                            if ($output) { $output = $false }
                            $debug_string += "  ending output on line $line_number`n"
                        }
                        '^Title:' {
                            $skip_next_blank = $true
                            # if there was a title identified, add that as the title
                            # of the example
                            $null = $line -imatch '^Title:\s+(?<title>.*)$'
                            $debug_string += "  found title on line $line_number`n"
                            $title = $Matches.title
                        }
                        '^\s*$' {
                            # it's ok to add blanks if there is something to add it too
                            $debug_string += "  line $line_number is blank`n"
                            if ($line_number -eq 0) {
                                $skip_next_blank = $true
                                $debug_string += "   Skip the blank line if it's the first line`n"
                            }
                            if ($skip_next_blank) {
                                $debug_string += "   'Skip' was set, Not adding the blank line`n"
                                $skip_next_blank = $false
                            } else {
                                if ($output) {
                                    $debug_string += "   adding a blank line to output $line_number`n"
                                    $output_code += $line
                                } else {
                                    $debug_string += "   adding a blank line to commentary on line $line_number`n"
                                    $commentary += $line
                                }
                            }
                        }
                        Default {
                            # if the line was blank it would have been caught by now
                            $has_content = $true
                            if ($output) {
                                $debug_string += "  adding output on line $line_number`n"
                                $output_code += $line
                            } else {
                                $debug_string += "  adding commentary on line $line_number`n"
                                $commentary += $line
                            }
                        }
                    }
                }
            }

            if ($null -ne $title) {
                $new_title = 'Example {0}: {1}' -f $num, $title
            } else {
                $new_title = 'Example {0}' -f $num
            }

            # we have all the components of the original example parsed now
            # Assemble a new Example section
            Section $new_title {
                $example.code | Code -Info 'powershell'
                if ($output_code.length -gt 0) {
                    ($output_code -join "`n") | Code -Info 'Output'
                }
                ($commentary -join "`n")

                $ENABLE_DEBUG_OUTPUT ? $debug_string : $null
            }
        }
    }

    Section 'PARAMETERS' {
        # get all the ParameterSet names:
        # if there is only one, and it's name is '__AllParameterSets', then
        # Make a pretty-printing name for the Parameter Sets field
        #
        foreach ($key in $h.CommandParameters.Keys) {
            if ($common_params -notcontains $key) {
                $cmd_param = $h.CommandParameters[$key]
                $hlp_param = $h.parameters.parameter | Where-Object -Property 'name' -EQ -Value $key
                $sets = @($cmd_param.ParameterSets.Keys)
                $sets = $sets -replace '__AllParameterSets', '(all)'

                Section ('-{0}' -f $hlp_param.Name) {
                    $hlp_param.description.Text

                    @( "Type:  $($hlp_param.type.name)",
                        "Parameter Sets: $($sets -join ', ')",
                        "Aliases: $($cmd_param.Aliases)",
                        "Required: $($hlp_param.Required)",
                        "Position: $($hlp_param.Position)",
                        "Default value: $($hlp_param.defaultValue ?? 'none')",
                        "Accept pipeline input: $($hlp_param.pipelineInput)",
                        "Accept wildcard characters: $($hlp_param.globbing)"
                    ) -join "`n" | Code -Info 'yaml'
                }
            }
        }
    }

    Section 'INPUTS' {
        foreach ($t in $h.inputTypes) {
            $t.type.name
        }
    }

    Section 'OUTPUTS' {
        foreach ($t in $h.returnValues) {
            $t.type.name
        }
    }

    Section 'NOTES' {
        foreach ($set in $h.alertSet) {
            $set.alert.Text
        }
    }

    Section 'RELATED LINKS' {
        <#
        The content of the .LINK section will be interpreted as either a uri or a
        "local link", handle both
        #>
        foreach ($link in $h.relatedLinks.navigationLink) {
            if ($link.uri) {
                '[{0}]({0})' -f $link.uri
            }
            elseif ($link.linkText) {
                if ($link.linkText -match '\[.*\]\(.*\)') {
                    # this is already formatted as a markdown link, just drop it
                    # in unchanged
                    $link.linkText
                } else {
                    '[{0}]({0}.md)' -f $link.linkText
                }

            }
        }
    }
}

# $Command.CommandType
# $Command.Name
# $Command.ModuleName
# $Command.DefaultParameterSet
# $Command.CmdletBinding
# $ParameterSet in $Command.ParameterSets
#     $ParameterSet.Name
#     $ParameterSet.IsDefault
#     $Parameter in $ParameterSet.Parameters
#         $Parameter.Name
#         $Parameter.IsMandatory
#         $Parameter.Aliases
#         $Parameter.HelpMessage
#         $Parameter.Type
#         $Parameter.ParameterType
#            $Parameter.ParameterType.Name
#            $Parameter.ParameterType.GenericTypeArguments.Name
#            $Parameter.ParameterType.IsGenericType
#            $Parameter.ParameterType.ToString() - we get that for free from expand

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

    Metadata @{
        'external_help_file' = "$($h.ModuleName)-help.xml"
        'Module_Name'        = $h.ModuleName
        'online_version'     = "https://github.com/aldrichtr/infraspective/blob/main/docs/help/$($h.Name).md"
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
            $syntax = $h.Name

            # we want to order the params according to their position if they have one
            # so, make a copy of the params array, move the positional ones first, then
            # add what's left to the end

            $positional = @()

            $positional += $set.Parameters |
                Where-Object -Property 'Position' -GE 0 |
                    Sort-Object -Property 'Position'
                    $debug_string += "  found {0} positional parameters`n" -f $positional.Count

            $positional += $set.Parameters |
                    Where-Object -Property 'Position' -LT 0 |
                    Where-Object {
                        $common_params -notcontains $_.Name
                    }
            $debug_string += "  found {0} total parameters`n" -f $positional.Count

            foreach ($p in $positional) {
                if ($p.IsMandatory) {
                    $syntax += ' -[{0}] <{1}>' -f $p.Name, $p.ParameterType.Name
                } else {
                    $syntax += ' [[-{0}] <{1}>]' -f $p.Name, $p.ParameterType.Name
                }
            }
            $syntax += ' [<CommonParameters>]'
            Section $syntax_name {
                $ENABLE_DEBUG_OUTPUT ? $debug_string : $null
                $syntax | Code -Info 'powershell'
            }
        }
        $ENABLE_DEBUG_OUTPUT = $false
    }

    Section 'DESCRIPTION' { $h.Description.Text }

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

    Section 'EXAMPLES' {
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
                $new_title = 'EXAMPLE {0} - {1}' -f $num, $title
            } else {
                $new_title = 'EXAMPLE {0}' -f $num
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

    Section 'NOTES' {
        foreach ($alert in $h.alertSet) {
            $alert.Text
        }
    }
}

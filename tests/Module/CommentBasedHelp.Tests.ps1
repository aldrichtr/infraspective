
BeforeDiscovery {
    $ShouldProcessParameters = 'WhatIf', 'Confirm'

    # Generate command list for generating Context / TestCases
    $LoadedModule = Get-Module $ModuleName
    # Hold a list of all of the commands and each of their help content
    $CommandList = @()
    # For each exported function, collect the help and store it in a table for use
    # in the tests below
    foreach ($c in $LoadedModule.ExportedFunctions.Keys) {
        # The help content as an object
        $h = Get-Help -Name $c -Full | Select-Object -Property *
        # Just help for the parameters
        $p = Get-Help -Name $c -Parameter * -ErrorAction Ignore |
        Where-Object { $_.Name -and ($_.Name -notin $ShouldProcessParameters) } |
        ForEach-Object {
            @{
                Name        = $_.name
                Description = $_.Description.Text
            }
        }
        # Just the examples
        $e = $h.Help.Examples.Example | ForEach-Object { @{ Example = $_ } }
        # The AST of the function
        $a = (Get-Content -Path "function:/$c" -ErrorAction Ignore).Ast
        # Build a table of the help compenents we want to use
        $cmd = @{
            Command  = $c
            Help     = $h
            AST      = $a
            Examples = $e
        }
        # finally, add it to the array of Commands to test
        $CommandList += $cmd
    }
}

Describe "Comment-based help for <Command>" -Tags @('analyze', 'help') -ForEach $CommandList {
    Context "Main help sections" {
        It "<Command> should have help content" {
            $Help | Should -Not -BeNullOrEmpty
        }

        It "<Command> should contain a synopsis" {
            $Help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "<Command> should contain a description" {
            $Help.Description | Should -Not -BeNullOrEmpty
        }
    }

    Context "Examples" {
        It "Should have at least one usage example" {
            $Help.Examples.Example.Code.Count | Should -BeGreaterOrEqual 1
        }

        It "lists a description for $Command example: <Title>" -TestCases $Examples {
            $Example.Remarks | Should -Not -BeNullOrEmpty -Because "example $($Example.Title) should have a description!"
        }
    }


    Context "Parameters" {
        It "Should have parameter help available" {
            $Parameters.Count | Should -BeGreaterThan 0
        }

        It "Should have a help entry for all parameters" {
            $Parameters.Count | Should -Be $AST.Body.ParamBlock.Parameters.Count -Because 'the number of parameters in the help should match the number in the function script'
        }

        It "-<Name> should have a Description" -Foreach $Parameters {
            $Description | Should -Not -BeNullOrEmpty
        }
    }
}

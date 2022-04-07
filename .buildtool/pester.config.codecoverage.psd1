@{
    Run = @{
        Path = @{
            Default = @(
                '.'
            )
            Description = 'Directories to be searched for tests, paths directly to test files, or combination of both.'
            Value = @(
                '.'
            )
        }
        ExcludePath = @{
            Default = @()
            Description = 'Directories or files to be excluded from the run.'
            Value = @()
        }
        ScriptBlock = @{
            Default = @()
            Description = 'ScriptBlocks containing tests to be executed.'
            Value = @()
        }
        Container = @{
            Default = @()
            Description = 'ContainerInfo objects containing tests to be executed.'
            Value = @()
        }
        TestExtension = @{
            Default = '.Tests.ps1'
            Description = 'Filter used to identify test files.'
            Value = '.Tests.ps1'
        }
        Exit = @{
            Default = $false
            Description = 'Exit with non-zero exit code when the test run fails. When used together with Throw, throwing an exception is preferred.'
            Value = $false
        }
        Throw = @{
            Default = $false
            Description = 'Throw an exception when test run fails. When used together with Exit, throwing an exception is preferred.'
            Value = $false
        }
        PassThru = @{
            Default = $false
            Description = 'Return result object to the pipeline after finishing the test run.'
            Value = $false
        }
        SkipRun = @{
            Default = $false
            Description = 'Runs the discovery phase but skips run. Use it with PassThru to get object populated with all tests.'
            Value = $false
        }
        SkipRemainingOnFailure = @{
            Default = 'None'
            Description = 'Skips remaining tests after failure for selected scope, options are None, Run, Container and Block.'
            Value = 'None'
        }
    }
    Filter = @{
        Tag = @{
            Default = @()
            Description = 'Tags of Describe, Context or It to be run.'
            Value = @()
        }
        ExcludeTag = @{
            Default = @()
            Description = 'Tags of Describe, Context or It to be excluded from the run.'
            Value = @()
        }
        Line = @{
            Default = @()
            Description = 'Filter by file and scriptblock start line, useful to run parsed tests programatically to avoid problems with expanded names. Example: ''C:\tests\file1.Tests.ps1:37'''
            Value = @()
        }
        ExcludeLine = @{
            Default = @()
            Description = 'Exclude by file and scriptblock start line, takes precedence over Line.'
            Value = @()
        }
        FullName = @{
            Default = @()
            Description = 'Full name of test with -like wildcards, joined by dot. Example: ''*.describe Get-Item.test1'''
            Value = @()
        }
    }
    CodeCoverage = @{
        Enabled = @{
            Default = $false
            Description = 'Enable CodeCoverage.'
            Value = $false
        }
        OutputFormat = @{
            Default = 'JaCoCo'
            Description = 'Format to use for code coverage report. Possible values: JaCoCo, CoverageGutters'
            Value = 'JaCoCo'
        }
        OutputPath = @{
            Default = 'coverage.xml'
            Description = 'Path relative to the current directory where code coverage report is saved.'
            Value = 'coverage.xml'
        }
        OutputEncoding = @{
            Default = 'UTF8'
            Description = 'Encoding of the output file.'
            Value = 'UTF8'
        }
        Path = @{
            Default = @()
            Description = 'Directories or files to be used for codecoverage, by default the Path(s) from general settings are used, unless overridden here.'
            Value = @()
        }
        ExcludeTests = @{
            Default = $true
            Description = 'Exclude tests from code coverage. This uses the TestFilter from general configuration.'
            Value = $true
        }
        RecursePaths = @{
            Default = $true
            Description = 'Will recurse through directories in the Path option.'
            Value = $true
        }
        CoveragePercentTarget = @{
            Default = 75
            Description = 'Target percent of code coverage that you want to achieve, default 75%.'
            Value = 75
        }
        UseBreakpoints = @{
            Default = $true
            Description = 'EXPERIMENTAL: When false, use Profiler based tracer to do CodeCoverage instead of using breakpoints.'
            Value = $true
        }
        SingleHitBreakpoints = @{
            Default = $true
            Description = 'Remove breakpoint when it is hit.'
            Value = $true
        }
    }
    TestResult = @{
        Enabled = @{
            Default = $false
            Description = 'Enable TestResult.'
            Value = $false
        }
        OutputFormat = @{
            Default = 'NUnitXml'
            Description = 'Format to use for test result report. Possible values: NUnitXml, NUnit2.5 or JUnitXml'
            Value = 'NUnitXml'
        }
        OutputPath = @{
            Default = 'testResults.xml'
            Description = 'Path relative to the current directory where test result report is saved.'
            Value = 'testResults.xml'
        }
        OutputEncoding = @{
            Default = 'UTF8'
            Description = 'Encoding of the output file.'
            Value = 'UTF8'
        }
        TestSuiteName = @{
            Default = 'Pester'
            Description = 'Set the name assigned to the root ''test-suite'' element.'
            Value = 'Pester'
        }
    }
    Should = @{
        ErrorAction = @{
            Default = 'Stop'
            Description = 'Controls if Should throws on error. Use ''Stop'' to throw on error, or ''Continue'' to fail at the end of the test.'
            Value = 'Stop'
        }
    }
    Debug = @{
        ShowFullErrors = @{
            Default = $false
            Description = 'Show full errors including Pester internal stack. This property is deprecated, and if set to true it will override Output.StackTraceVerbosity to ''Full''.'
            Value = $false
        }
        WriteDebugMessages = @{
            Default = $false
            Description = 'Write Debug messages to screen.'
            Value = $false
        }
        WriteDebugMessagesFrom = @{
            Default = @(
                'Discovery'
                'Skip'
                'Mock'
                'CodeCoverage'
            )
            Description = 'Write Debug messages from a given source, WriteDebugMessages must be set to true for this to work. You can use like wildcards to get messages from multiple sources, as well as * to get everything.'
            Value = @(
                'Discovery'
                'Skip'
                'Mock'
                'CodeCoverage'
            )
        }
        ShowNavigationMarkers = @{
            Default = $false
            Description = 'Write paths after every block and test, for easy navigation in VSCode.'
            Value = $false
        }
        ReturnRawResultObject = @{
            Default = $false
            Description = 'Returns unfiltered result object, this is for development only. Do not rely on this object for additional properties, non-public properties will be renamed without previous notice.'
            Value = $false
        }
    }
    Output = @{
        Verbosity = @{
            Default = 'Normal'
            Description = 'The verbosity of output, options are None, Normal, Detailed and Diagnostic.'
            Value = 'Normal'
        }
        StackTraceVerbosity = @{
            Default = 'Filtered'
            Description = 'The verbosity of stacktrace output, options are None, FirstLine, Filtered and Full.'
            Value = 'Filtered'
        }
        CIFormat = @{
            Default = 'Auto'
            Description = 'The CI format of error output in build logs, options are None, Auto, AzureDevops and GithubActions.'
            Value = 'Auto'
        }
    }
    TestDrive = @{
        Enabled = @{
            Default = $true
            Description = 'Enable TestDrive.'
            Value = $true
        }
    }
    TestRegistry = @{
        Enabled = @{
            Default = $true
            Description = 'Enable TestRegistry.'
            Value = $true
        }
    }
}

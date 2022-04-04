@{
    Run          = @{
        # Default = @('.')
        # Description = 'Directories to be searched for tests, paths directly to test files, or combination of both.'
        Path                   = @(
            './tests'
        )

        # Default = @()
        # Description = 'Directories or files to be excluded from the run.'
        ExcludePath            = @()

        # Default = @()
        # Description = 'ScriptBlocks containing tests to be executed.'
        ScriptBlock            = @()

        # Default = @()
        # Description = 'ContainerInfo objects containing tests to be executed.'
        Container              = @()

        # Default = '.Tests.ps1'
        # Description = 'Filter used to identify test files.'
        TestExtension          = '.Tests.ps1'

        # Default = $false
        # Description = 'Exit with non-zero exit code when the test run fails. When used together with Throw, throwing an exception is preferred.'
        Exit                   = $false

        # Default = $false
        # Description = 'Throw an exception when test run fails. When used together with Exit, throwing an exception is preferred.'
        Throw                  = $false

        # Default = $false
        # Description = 'Return result object to the pipeline after finishing the test run.'
        PassThru               = $false

        # Default = $false
        # Description = 'Runs the discovery phase but skips run. Use it with PassThru to get object populated with all tests.'
        SkipRun                = $false

        # Default = 'None'
        # Description = 'Skips remaining tests after failure for selected scope, options are None, Run, Container and Block.'
        SkipRemainingOnFailure = 'None'
    }

    Filter       = @{
        # Default = @()
        # Description = 'Tags of Describe, Context or It to be run.'
        Tag         = @("analyze")

        # Default = @()
        # Description = 'Tags of Describe, Context or It to be excluded from the run.'
        ExcludeTag  = @()

        # Default = @()
        # Description = 'Filter by file and scriptblock start line, useful to run parsed tests programatically to avoid problems with expanded names. Example: ''C:\tests\file1.Tests.ps1:37'''
        Line        = @()

        # Default = @()
        # Description = 'Exclude by file and scriptblock start line, takes precedence over Line.'
        ExcludeLine = @()

        # Default = @()
        # Description = 'Full name of test with -like wildcards, joined by dot. Example: ''*.describe Get-Item.test1'''
        FullName    = @()

    }
    CodeCoverage = @{
        # Default = $false
        # Description = 'Enable CodeCoverage.'
        Enabled               = $false

        # Default = 'JaCoCo'
        # Description = 'Format to use for code coverage report. Possible values: JaCoCo, CoverageGutters'
        OutputFormat          = 'JaCoCo'

        # Default = 'coverage.xml'
        # Description = 'Path relative to the current directory where code coverage report is saved.'
        OutputPath            = 'coverage.xml'

        # Default = 'UTF8'
        # Description = 'Encoding of the output file.'
        OutputEncoding        = 'UTF8'

        # Default = @()
        # Description = 'Directories or files to be used for codecoverage, by # Default the Path(s) from general settings are used, unless overridden here.'
        Path                  = @()

        # Default = $true
        # Description = 'Exclude tests from code coverage. This uses the TestFilter from general configuration.'
        ExcludeTests          = $true

        # Default = $true
        # Description = 'Will recurse through directories in the Path option.'
        RecursePaths          = $true

        # Default = 75
        # Description = 'Target percent of code coverage that you want to achieve, # Default 75%.'
        CoveragePercentTarget = 75

        # Default = $true
        # Description = 'EXPERIMENTAL: When false, use Profiler based tracer to do CodeCoverage instead of using breakpoints.'
        UseBreakpoints        = $true

        # Default = $true
        # Description = 'Remove breakpoint when it is hit.'
        SingleHitBreakpoints  = $true

    }

    TestResult   = @{
        # Default = $false
        # Description = 'Enable TestResult.'
        Enabled        = $false

        # Default = 'NanalyzeXml'
        # Description = 'Format to use for test result report. Possible values: NanalyzeXml, Nanalyze2.5 or JanalyzeXml'
        OutputFormat   = 'NanalyzeXml'

        # Default = 'testResults.xml'
        # Description = 'Path relative to the current directory where test result report is saved.'
        OutputPath     = 'testResults.xml'

        # Default = 'UTF8'
        # Description = 'Encoding of the output file.'
        OutputEncoding = 'UTF8'

        # Default = 'Pester'
        # Description = 'Set the name assigned to the root ''test-suite'' element.'
        TestSuiteName  = 'Pester'

    }

    Should       = @{
        # Default = 'Stop'
        # Description = 'Controls if Should throws on error. Use ''Stop'' to throw on error, or ''Continue'' to fail at the end of the test.'
        ErrorAction = 'Continue'

    }

    Debug        = @{
        # Default = $false
        # Description = 'Show full errors including Pester internal stack. This property is deprecated, and if set to true it will override Output.StackTraceVerbosity to ''Full''.'
        ShowFullErrors         = $false

        # Default = $false
        # Description = 'Write Debug messages to screen.'
        WriteDebugMessages     = $false

        # Default = @(
        #    'Discovery'
        #    'Skip'
        #    'Mock'
        #    'CodeCoverage'
        # )
        # Description = 'Write Debug messages from a given source, WriteDebugMessages must be set to true for this to work. You can use like wildcards to get messages from multiple sources, as well as * to get everything.'
        WriteDebugMessagesFrom = @(
            'Discovery'
            'Skip'
            'Mock'
            'CodeCoverage'
        )

        # Default = $false
        # Description = 'Write paths after every block and test, for easy navigation in VSCode.'
        ShowNavigationMarkers  = $false

        # Default = $false
        # Description = 'Returns unfiltered result object, this is for development only. Do not rely on this object for additional properties, non-public properties will be renamed without previous notice.'
        ReturnRawResultObject  = $false
    }

    Output       = @{
        # Default = 'Normal'
        # Description = 'The verbosity of output, options are None, Normal, Detailed and Diagnostic.'
        Verbosity           = 'Normal'

        # Default = 'Filtered'
        # Description = 'The verbosity of stacktrace output, options are None, FirstLine, Filtered and Full.'
        StackTraceVerbosity = 'None'

        # Default = 'Auto'
        # Description = 'The CI format of error output in build logs, options are None, Auto, AzureDevops and GithubActions.'
        CIFormat            = 'Auto'
    }

    TestDrive    = @{
        # Default = $true
        # Description = 'Enable TestDrive.'
        Enabled = $true
    }

    TestRegistry = @{
        # Default = $true
        # Description = 'Enable TestRegistry.'
        Enabled = $true
    }
}


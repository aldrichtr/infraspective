@{
    PSDependOptions = @{
        Target = ".\out"
        AddToPath = $true
    }

    # used to write logging messages to various targets
    Logging = @{
        Version = '4.8.3'
        Tags    = 'dev', 'prod', 'ci'
    }

    # Used to maintain a module configuration
    Configuration = @{
        Version = '1.5.0'
        Tags    = 'dev', 'prod', 'ci'
    }

    # Not much of a testing application without the testing module
    Pester  = @{
        Version = '5.3'
        Tags    = 'dev', 'prod', 'ci'
    }

    # used during development and testing
    PSScriptAnalyzer = @{
        Version = '1.20.0'
        Tags    = 'dev', 'ci'
    }
    # Used to create a new audit folder
    Plaster = @{
        Version = '1.1.3'
        Tags    = 'dev', 'prod', 'ci'
    }
}

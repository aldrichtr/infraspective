@{
    PSDependOptions = @{
        Target = ".\out"
        AddToPath = $true
    }

    # Not much of a testing application without the testing module
    Pester  = @{
        Version = '5.3'
        Tags    = 'dev', 'prod', 'ci'
    }

    # Used to maintain a module configuration
    Configuration = @{
        Version = '1.5.0'
        Tags    = 'dev', 'prod', 'ci'
    }

    # used to write logging messages to various targets
    Logging = @{
        Version = '4.8.3'
        Tags    = 'dev', 'prod', 'ci'
    }

    # The template system for flexible, configurable Output
    EPS = @{
        Version = '1.0'
        Tags    = 'dev', 'prod', 'ci'
    }

    # Provides colors, emojis and symbols to Output
    Pansies = @{
        Version = '2.3'
        Tags    = 'dev', 'prod', 'ci'
        # This module wants to "Clobber" `Write-Host`, which personally, I think is a good thing....
        Parameters = @{
            AllowClobber = $true
            AllowPrerelease = $true
        }
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

@{
    # used to write logging messages to various targets
    Logging = @{
        Version = '4.8.3'
        Tags    = 'dev', 'prod', 'ci'
    }

    Configuration = @{
        Version = '1.5.0'
        Tags    = 'dev', 'prod', 'ci'
    }
    # Not much of a testing application without the testing module
    Pester  = @{
        Version = '5.3'
        Tags    = 'dev', 'prod', 'ci'
    }
    # Used to create a new audit folder
    Plaster = @{
        Version = '1.1.3'
        Tags    = 'dev', 'prod', 'ci'
    }
}

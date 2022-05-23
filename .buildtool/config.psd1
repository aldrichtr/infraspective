@{
    Project = @{
        Name = 'infraspective'
        Type = 'single'
        Path = 'C:\Users\taldrich\projects\github\infraspective'
        Modules = @{
            Root = @{
                Name = 'infraspective'
                Path = 'source\infraspective'
                Module = 'source\infraspective\infraspective.psm1'
                Manifest = 'source\infraspective\infraspective.psd1'
                Types = @(
                    'enum'
                    'classes'
                    'private'
                    'public'
                )
                CustomLoadOrder = ''
            }
        }
    }

    Source = @{
        Path = 'source'
    }

    Staging = @{
        Path = 'stage'
    }

    Artifact = @{
        Path = 'out'
    }

    Build = @{
        Tasks = 'build/Tasks'
        Config = 'build/Config'
        Rules = 'build/Rules'
        Tools = 'build/Tools'
        Path = 'build'
    }

    Tests = @{
        Path = 'tests'
        Config = @{
            Unit = '.buildtool/pester.config.unittests.psd1'
            Analyzer = '.buildtool/pester.config.analyzertests.psd1'
            Performance = '.buildtool/pester.config.performancetests.psd1'
            Coverage = '.buildtool/pester.config.codecoverage.psd1'
        }
    }

    Docs = @{
        Path = 'docs'
    }



    Plaster = @{
        Path = 'build/PlasterTemplates'
    }
}

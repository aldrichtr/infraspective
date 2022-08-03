
function Measure-ServerFeature {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('ServerFeature')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [string]$Target,

        [Parameter(
            ParameterSetName = 'Default',
            Position = 2
        )]
        [ValidateSet(
            'BestPracticesModelId', 'DependsOn', 'Depth',
            'DisplayName', 'FeatureType', 'Installed', 'InstallState',
            'Name', 'Notification', 'Parent', 'Path', 'ServerComponentDescriptor',
            'SubFeatures', 'SystemService'
        )]
        [string]$Property = 'Installed',

        # A Script Block defining a Pester Assertion.
        [Parameter(
            ParameterSetName = 'NoProperty',
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Default',
            Position = 3,
            Mandatory
        )]
        [scriptblock]$Should
    )
    begin {
        function getFeature {
            <#
            .SYNOPSIS
                Wrap Get-WindowsFeature
            .DESCRIPTION
                Wrap 'Get-WindowsFeature' in a function mainly so the progress bar can be supressed
            #>
            param(
                [Parameter(
                )]
                [string]$Name
            )

            $progPref = $ProgressPreference
            $ProgressPreference = 'SilentlyContinue'
            $f = Get-WindowsFeature -Name $Name -ErrorAction SilentlyContinue
            $ProgressPreference = $progPref
            $f
        }

    }
    process {
        if (-not $PSBoundParameters.ContainsKey('Property')) {
            $Property = 'Installed'
            $PSBoundParameters.Add('Property', $Property)
        }

        $expression = { getFeature -Name $Target }

        $params = Get-PoshspecParam -TestName ServerFeature -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }

}

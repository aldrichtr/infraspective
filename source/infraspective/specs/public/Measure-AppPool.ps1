
function Measure-AppPool {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [OutputType([System.String])]
    [Alias('AppPool')]
    [CmdletBinding(
        DefaultParameterSetName = 'Default'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'Measure-RequiresModules\Measure-RequiresModules', ''
    )]

    param(
        # The name of the App Pool to be Tested
        [Parameter(
            ParameterSetName='Default',
            Mandatory,
            Position = 0
            )]
        [Parameter(
            ParameterSetName='Property',
            Mandatory,
            Position = 0
        )]
        [Alias('Path')]
        [string]$Target,

        # The Property to be expanded. If Ommitted, Property Will Default to Status.
        # Can handle nested objects within properties
        [Parameter(
            ParameterSetName = 'Property',
            Position = 1
        )]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(
            ParameterSetName='Default',
            Mandatory,
            Position = 1
        )]
        [Parameter(
            ParameterSetName='Property',
            Mandatory,
            Position = 2
        )]
        [scriptblock]$Should
    )
    begin {
        $IISAdmin = Get-Module -Name 'IISAdministration'
        if ($IISAdmin) {
            Import-Module IISAdministration
        } else {
            function Get-IISSite {
                <#
        .SYNOPSIS
            Get the IIS Site from the localhost using the ServerManager
        .DESCRIPTION
            If the IISAdministration module is not installed, this function can be used to retrieve the IIS site
            using ServerManager.  This function will clash with the IISAdministration module function if it exists,
            so only load it if it isn't.
        .EXAMPLE
            Get-IISSite -Name "default"
        #>
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true,
                        Position = 0)]
                    [string]$Name
                )

                begin {
                    [System.Reflection.Assembly]::LoadFrom("$($Env:windir)\system32\inetsrv\Microsoft.Web.Administration.dll") | Out-Null
                    $ServerManager = [Microsoft.Web.Administration.ServerManager]::OpenRemote('localhost')
                }

                process {
                    try {
                        Write-Verbose "Getting site $Name"
                        Write-Output $ServerManager.Sites[$Name]
                    }

                    catch {
                        Write-Warning $Error[0]
                    }
                }

                end {
                    $ServerManager.Dispose()
                }
            }
        }
        $expression = $null
        $params = $null

    }
    process {
        if (-not $PSBoundParameters.ContainsKey('Property')) {
            $Property = 'State'
            $PSBoundParameters.add('Property', $Property)
            $expression = { Get-IISAppPool -Name '$Target' -ErrorAction SilentlyContinue }
            $params = Get-PoshspecParam -TestName AppPool -TestExpression $expression @PSBoundParameters
        }

        if ($Property -like '*.*' -or $Property -like '*(*' -or $Property -like '*)*') {
            $expression = { Get-IISAppPool -Name '$Target' -ErrorAction SilentlyContinue }
            $params = Get-PoshspecParam -TestName AppPool -TestExpression $expression -Target $Target -Should $Should -PropertyExpression $Property
        }

        else {
            $expression = { Get-IISAppPool -Name '$Target' -ErrorAction SilentlyContinue }
            $params = Get-PoshspecParam -TestName AppPool -TestExpression $expression @PSBoundParameters
        }
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

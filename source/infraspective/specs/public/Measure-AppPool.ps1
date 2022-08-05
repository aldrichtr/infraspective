
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
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory,
            Position = 1
        )]
        [Parameter(
            ParameterSetName = 'Property',
            Mandatory,
            Position = 1
        )]
        [Alias('Path')]
        [string]$Target,

        [Parameter(
            ParameterSetName = 'Property',
            Position = 2
        )]
        [string]$Property,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory,
            Position = 2
        )]
        [Parameter(
            ParameterSetName = 'Property',
            Mandatory,
            Position = 3
        )]
        [scriptblock]$Should
    )
    begin {
        $IISAdmin = Get-Module -Name 'IISAdministration'
        if ($IISAdmin) {
            Import-Module IISAdministration
        } else {
            function Get-IisAppPool {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true,
                        Position = 1)]
                    [string]$Name
                )
                begin {
                    [System.Reflection.Assembly]::LoadFrom("$($Env:windir)\system32\inetsrv\Microsoft.Web.Administration.dll") | Out-Null
                    $ServerManager = [Microsoft.Web.Administration.ServerManager]::OpenRemote('localhost')
                }

                process {
                    try {
                        Write-Verbose "Getting application pool $Name"
                        Write-Output $ServerManager.ApplicationPools[$Name]
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

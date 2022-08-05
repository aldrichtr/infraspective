
function Measure-WebSite {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('WebSite')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(
            ParameterSetName = 'Default',
            Position = 1,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Property',
            Position = 1,
            Mandatory
        )]
        [Alias('Path')]
        [string]$Target,

        [Parameter(
            ParameterSetName = 'Property',
            Position = 2
            )]
        [Parameter(
            ParameterSetName = 'Index',
            Position = 2
            )]
        [string]$Property,

        [Parameter(
            ParameterSetName = 'Default',
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Property',
            Position = 3,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Index',
            Position = 3
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
                        Position = 1)]
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
            $expression = { Get-IISSite -Name '$Target' -ErrorAction SilentlyContinue }
            $params = Get-PoshspecParam -TestName WebSite -TestExpression $expression @PSBoundParameters
        }

        if ($Property -like '*.*' -or $Property -like '*(*' -or $Property -like '*)*') {
            $expression = { Get-IISSite -Name '$Target' -ErrorAction SilentlyContinue }
            $params = Get-PoshspecParam -TestName Website -TestExpression $expression -Target $Target -Should $Should -PropertyExpression $Property
        } else {
            $expression = { Get-IISSite -Name '$Target' -ErrorAction SilentlyContinue }
            $params = Get-PoshspecParam -TestName WebSite -TestExpression $expression @PSBoundParameters
        }
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

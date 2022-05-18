
function CimObject {
    <#
    .SYNOPSIS
        Test the value of a CimObject Property.
    .DESCRIPTION
        Test the value of a CimObject Property. The Class can be provided with the Namespace. See Example.
    .EXAMPLE
        CimObject Win32_OperatingSystem SystemDirectory { Should -Be C:\WINDOWS\system32 }
    .EXAMPLE
        CimObject root/StandardCimv2/MSFT_NetOffloadGlobalSetting ReceiveSideScaling { Should -Be Enabled }
    .NOTES
        Assertions: Be, BeExactly, Match, MatchExactly
    #>
    [CmdletBinding()]
    param(
        # Specifies the name of the CIM class for which to retrieve the CIM instances. Can be just the ClassName
        # in the default namespace or in the form of namespace/className to access other namespaces.
        [Parameter(Mandatory, Position = 1)]
        [Alias("ClassName")]
        [string]$Target,

        # Specifies an instance property to retrieve.
        [Parameter(Mandatory, Position = 2)]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 3)]
        [scriptblock]$Should
    )

    begin {
        $expression = $null
        $class = $null
        $namespace = $null
    }
    process {
        if ($Target -match '/') {
            $lastIndexOfSlash = $Target.LastIndexOf('/')

            $class = $Target.Substring($lastIndexOfSlash + 1)
            $namespace = $Target.Substring(0, $lastIndexOfSlash)

            $PSBoundParameters["Target"] = $class
            $PSBoundParameters.Add("Qualifier", $namespace)

            $expression = { Get-CimInstance -ClassName $Target -Namespace $Qualifier }
        } else {
            $expression = { Get-CimInstance -ClassName $Target }
        }

        if ($Property -like '*.*' -or $Property -like '*(*' -or $Property -like '*)*') {
            $PSBoundParameters.Remove("Property")
            $PSBoundParameters.Add("PropertyExpression", $Property)
            $params = Get-PoshspecParam -TestName CimObject -TestExpression $expression @PSBoundParameters
        }

        else {
            $params = Get-PoshspecParam -TestName CimObject -TestExpression $expression @PSBoundParameters
        }
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

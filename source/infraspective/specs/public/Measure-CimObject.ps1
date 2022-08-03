
function Measure-CimObject {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('CimObject')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [Alias("ClassName")]
        [string]$Target,

        [Parameter(
            Position = 2,
            Mandatory
        )]
        [string]$Property,

        [Parameter(
            Position = 3,
            Mandatory
        )]
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

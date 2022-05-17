
function Get-PoshspecParam {
    <#
    .SYNOPSIS
        Returns an object which is used with Invoke-PoshspecExpression to execute a Pester 'It' block with the
        generated name and test expression values.
    .DESCRIPTION
        Returns an object which is used with 'Name' and 'Expression'
    .EXAMPLE
        Get-PoshspecParam -TestName File -TestExpression { 'C:\Temp' } -Target 'C:\Temp' -Should { Should -Exist }
    .NOTES
        This function was originally part of the [poshspec](https://github.com/Ticketmaster/poshspec) module.
    .LINK
        Invoke-PoshspecExpression
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # The name of the Test
        [Parameter(Mandatory, ParameterSetName = "Default")]
        [Parameter(Mandatory, ParameterSetName = "PropertyExpression")]
        [string]
        $TestName,

        # The Expression to be used
        [Parameter(Mandatory, ParameterSetName = "Default")]
        [Parameter(Mandatory, ParameterSetName = "PropertyExpression")]
        [string]
        $TestExpression,

        # The object that the function will test against.
        [Parameter(Mandatory, ParameterSetName = "Default")]
        [Parameter(Mandatory, ParameterSetName = "PropertyExpression")]
        [string]
        $Target,

        # A display name
        [Parameter(ParameterSetName = "Default")]
        [string]
        $FriendlyName,

        # The property of the object to test
        [Parameter(ParameterSetName = "Default")]
        [string]
        $Property,

        # An expression that is used to get the properties
        [Parameter(Mandatory, ParameterSetName = "PropertyExpression")]
        [string]
        $PropertyExpression,

        # The value to test against
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "PropertyExpression")]
        [string]
        $Qualifier,

        # The 'Should' test expression
        [Parameter(Mandatory, ParameterSetName = "Default")]
        [Parameter(Mandatory, ParameterSetName = "PropertyExpression")]
        [scriptblock]
        $Should
    )
    begin {
        # convert to text
        $assertion = $Should.ToString().Trim()
        $expressionString = $TestExpression.ToString().Trim()
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "PropertyExpression") {
            $PropertyExpression = $PropertyExpression.ToString().Trim()
            $expressionString = $ExecutionContext.InvokeCommand.ExpandString($expressionString)
            $expressionString = Expand-PoshspecTestExpression $expressionString $PropertyExpression

            <#
            if the PropertyExpression contains a '.' like:
              : AppPool TestSite ProcessModel.IdentityType { Should be 'ApplicationPoolIdentity'}

              then split it into <Qualifier>.<NewProperty>  and create the It name like:
              : "AppPool property 'IdentityType' for 'TestSite' at 'ProcessModel' Should be 'ApplicationPoolIdentity'"

            otherwise, the PropertyExpression is something like:
              : AppPool TestSite ManagedPipelineMode { Should be 'Integrated' }
              and the It name will be like:
              : "AppPool property 'ManagedPipelineMode' for TestSite Should be 'Integrated'
            #>
            if ($PropertyExpression -like '*.*') {
                $lastIndexOfPeriod = $PropertyExpression.LastIndexOf('.')
                $Qualifier = $PropertyExpression.substring(0, $lastIndexOfPeriod)
                $NewProperty = $PropertyExpression.substring($lastIndexOfPeriod + 1)
                $nameString = "{0} property '{1}' for '{2}' at '{3}' {4}" -f $TestName, $NewProperty, $Target, $Qualifier, $assertion
            } else {
                $nameString = "{0} property '{1}' for '{2}' {3}" -f $TestName, $PropertyExpression, $Target, $assertion
            }

            $expressionString += " | $assertion"
            Write-Output -InputObject ([PSCustomObject]@{Name = $nameString; Expression = $expressionString })
        } else {
            if (-not $PSBoundParameters.ContainsKey("FriendlyName")) {
                $FriendlyName = $Target
            }

            $expressionString = $TestExpression.ToString().Trim()

            if ($PSBoundParameters.ContainsKey("Property")) {
                $expressionString += " | Select-Object -ExpandProperty '$Property'"

                if ($PSBoundParameters.ContainsKey("Qualifier")) {
                    $nameString = "{0} property '{1}' for '{2}' at '{3}' {4}" -f $TestName, $Property, $FriendlyName, $Qualifier, $assertion
                } else {
                    $nameString = "{0} property '{1}' for '{2}' {3}" -f $TestName, $Property, $FriendlyName, $assertion
                }
            } else {
                $nameString = "{0} '{1}' {2}" -f $TestName, $FriendlyName, $assertion
            }
            $expressionString += " | $assertion"
            $expressionString = $ExecutionContext.InvokeCommand.ExpandString($expressionString)
        }
    }
    end {
        ([PSCustomObject]@{
                Name       = $nameString
                Expression = $expressionString
            })
    }
}

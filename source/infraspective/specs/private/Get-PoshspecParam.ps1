
function Get-PoshspecParam {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter( ParameterSetName = 'Default',
            Mandatory
        )]
        [Parameter( ParameterSetName = 'PropertyExpression',
            Mandatory
        )]
        [string]$TestName,

        [Parameter( ParameterSetName = 'Default',
            Mandatory
        )]
        [Parameter( ParameterSetName = 'PropertyExpression',
            Mandatory
        )]
        [string]$TestExpression,

        [Parameter( ParameterSetName = 'Default',
        Mandatory
        )]
        [Parameter( ParameterSetName = 'PropertyExpression',
            Mandatory
        )]
        [string]$Target,

        [Parameter( ParameterSetName = 'Default'
        )]
        [string]$FriendlyName,

        [Parameter( ParameterSetName = 'Default'
        )]
        [string]$Property,

        [Parameter( ParameterSetName = 'PropertyExpression',
            Mandatory
        )]
        [string]$PropertyExpression,

        [Parameter( ParameterSetName = 'Default'
        )]
        [Parameter( ParameterSetName = 'PropertyExpression'
        )]
        [string]$Qualifier,

        [Parameter( ParameterSetName = 'Default',
            Mandatory
        )]
        [Parameter( ParameterSetName = 'PropertyExpression',
            Mandatory
        )]
        [scriptblock]$Should
    )
    begin {
        # convert to text
        $assertion = $Should.ToString().Trim()
        $expressionString = $TestExpression.ToString().Trim()
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'PropertyExpression') {
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
            if (-not $PSBoundParameters.ContainsKey('FriendlyName')) {
                $FriendlyName = $Target
            }

            $expressionString = $TestExpression.ToString().Trim()

            if ($PSBoundParameters.ContainsKey('Property')) {
                $expressionString += " | Select-Object -ExpandProperty '$Property'"

                if ($PSBoundParameters.ContainsKey('Qualifier')) {
                    $nameString = "{0} property '{1}' for '{2}' at '{3}' {4}" -f $TestName, $Property, $FriendlyName, $Qualifier, $assertion
                } else {
                    $nameString = "{0} property '{1}' for '{2}' {3}" -f $TestName, $Property, $FriendlyName, $assertion
                }
            } else {
                $nameString = "{0} '{1}' {2}" -f $TestName, $FriendlyName, $assertion
            }
            $expressionString += " | $assertion"
            $expressionString = $ExecutionContext.InvokeCommand.ExpandString($expressionString)

            Write-Output -InputObject ([PSCustomObject]@{
                    Name       = $nameString
                    Expression = $expressionString
                })
        }
    }
    end {
    }
}

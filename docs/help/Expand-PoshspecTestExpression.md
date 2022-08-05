---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Expand-PoshspecTestExpression.md
schema: 2.0.0
---

# Expand-PoshspecTestExpression

## SYNOPSIS

Expand the given expression into a scriptblock containing a well formed function
to be used in a Pester test

## SYNTAX

```powershell
Expand-PoshspecTestExpression [-ObjectExpression] <String> [-PropertyExpression] <String> [<CommonParameters>]
```

## DESCRIPTION

`Expand-PoshspecTestExpression` converts the `ObjectExpression` and the
`PropertyExpression into an executable statement within a scriptblock.  When a
given poshspec function is testing a property (or nested property), the
scriptblock body needs to:

1. Call the underlying function

2. Get the requested property of the object returned by the function.

## EXAMPLES

### EXAMPLE 1: Expand a test expression with a property


```powershell
$expression = { Get-IISAppPool -Name 'TestSite' }
$exp_string = Expand-PoshspecTestExpression $expression 'ProcessModel.IdentityType'

# result:
"(Get-IISAppPool -Name 'TestSite').ProcessModel.IdentityType"
```

For this example, the test has the following syntax that we want to expand:

`AppPool TestSite ProcessModel.IdentityType { Should -Be 'ApplicationPoolIdentity' }`

Get-PoshspecParam needs to expand the function `Get-IISAppPool` and get the
Property `ProcessModel.IdentityType`


## PARAMETERS

### -ObjectExpression

The expression string

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyExpression

The property string

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-PoshspecParam](Get-PoshspecParam.md)

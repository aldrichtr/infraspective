---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Get-PoshspecParam.md
schema: 2.0.0
---

# Get-PoshspecParam

## SYNOPSIS
Returns an object which is used with Invoke-PoshspecExpression to execute a Pester 'It' block with the
generated name and test expression values.

## SYNTAX

### Default (Default)
```
Get-PoshspecParam -TestName <String> -TestExpression <String> -Target <String> [-FriendlyName <String>]
 [-Property <String>] [-Qualifier <String>] -Should <ScriptBlock> [<CommonParameters>]
```

### PropertyExpression
```
Get-PoshspecParam -TestName <String> -TestExpression <String> -Target <String> -PropertyExpression <String>
 [-Qualifier <String>] -Should <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Returns an object which is used with 'Name' and 'Expression'

## EXAMPLES

### EXAMPLE 1
```
Get-PoshspecParam -TestName File -TestExpression { 'C:\Temp' } -Target 'C:\Temp' -Should { Should -Exist }
```

## PARAMETERS

### -TestName
The name of the Test

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestExpression
The Expression to be used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
The object that the function will test against.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
A display name

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
The property of the object to test

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyExpression
An expression that is used to get the properties

```yaml
Type: String
Parameter Sets: PropertyExpression
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Qualifier
The value to test against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Should
The 'Should' test expression

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function was originally part of the \[poshspec\](https://github.com/Ticketmaster/poshspec) module.

## RELATED LINKS

[Invoke-PoshspecExpression]()


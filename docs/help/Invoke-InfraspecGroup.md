---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Invoke-InfraspecGroup.md
schema: 2.0.0
---

# Invoke-InfraspecGroup

## SYNOPSIS

A collection of security controls.

## SYNTAX

```powershell
Invoke-InfraspecGroup [-Name] <String> [[-Body] <ScriptBlock>] [-Title <String>] [-Description <String>]
 [<CommonParameters>]
```

## DESCRIPTION

This function is aliased by the `Grouping` keyword and maps to the concept of a
collection of Controls.

## EXAMPLES

### Example 1

```powershell
Grouping 'Windows client' -Title 'Tests for Windows clients' {
    # Groupings, Controls, etc
}
```

## PARAMETERS

### -Name

The name of the Grouping

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

### -Body

The controls associated with this Grouping

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

The title of the Grouping

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

### -Description

The description of the Grouping

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction,
-ErrorVariable, -InformationAction, -InformationVariable, -OutVariable,
-OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

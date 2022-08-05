---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Invoke-InfraspecChecklist.md
schema: 2.0.0
---

# Invoke-InfraspecChecklist

## SYNOPSIS

A collection of security controls to check against one or more systems.

## SYNTAX

```powershell
Invoke-InfraspecChecklist [-Name] <String> [-Body] <ScriptBlock> [-Title <String>] [-Version <Version>]
 [<CommonParameters>]
```

## DESCRIPTION

A collection of Groupings, and or Controls.

## EXAMPLES

### Example 1

```powershell
Invoke-InfraspecChecklist 'Win10-STIG' -Title 'Windows 10 STIG' {
    # Groupings, Controls, etc
}
```

## PARAMETERS

### -Name

A unique name for this checklist

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

The checklist body containing controls

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

A descriptive title for this checklist

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

### -Version

A unique version for this checklist

```yaml
Type: Version
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

### Infraspective.Checklist.ResultInfo

## NOTES

## RELATED LINKS

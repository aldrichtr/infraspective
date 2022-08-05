---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Invoke-Infraspective.md
schema: 2.0.0
---

# Invoke-Infraspective

## SYNOPSIS

Perform an audit on the specified hosts

## SYNTAX

```powershell
Invoke-Infraspective [[-Path] <String[]>] [[-Configuration] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Run checklists, groupings and controls in files specified in the configuration.

## EXAMPLES

### EXAMPLE 1: Run an audit using the defaults

```powershell
Invoke-Infraspective
```

### EXAMPLE 2: Run an audit using a specific configuration

```powershell
Invoke-Infraspective -Configuration './audit.psd1'
```

## PARAMETERS

### -Path

Specify a path to the files containing the checklists, controls, etc.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Configuration

Alternate configuration file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

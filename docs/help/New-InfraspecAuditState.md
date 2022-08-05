---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/New-InfraspecAuditState.md
schema: 2.0.0
---

# New-InfraspecAuditState

## SYNOPSIS

Create a new State object to keep track of the current state of an Audit.

## SYNTAX

```powershell
New-InfraspecAuditState [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The state object is used to store and track the current audit variables and values

## EXAMPLES

### Example 1

```powershell
$state = New-InfraspecAuditState
```

## PARAMETERS

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

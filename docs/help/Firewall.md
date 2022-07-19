---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Firewall.md
schema: 2.0.0
---

# Firewall

## SYNOPSIS
Firewall Settings

## SYNTAX

```
Firewall [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Used To Determine if Firewall is Running Desired Settings

## EXAMPLES

### EXAMPLE 1
```
Firewall putty.exe Enabled { Should -Be "$True" }
```

### EXAMPLE 2
```
Firewall putty.exe Action { Should -Be 'Allow' }
```

### EXAMPLE 3
```
Firewall putty.exe Private { Should -Be 'Public' }
```

## PARAMETERS

### -Property
The name of the Property of the Firewall Object to be Tested

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Should
A Script Block defining a Pester Assertion.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
The name of the Firewall DisplayName to be Tested

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

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
Assertions: Be

## RELATED LINKS

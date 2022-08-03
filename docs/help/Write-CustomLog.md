---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Write-CustomLog.md
schema: 2.0.0
---

# Write-CustomLog

## SYNOPSIS

Wrap the Write-Log function

## SYNTAX

```powershell
Write-CustomLog [[-Scope] <String>] [[-Level] <String>] [[-Message] <String>] [[-Arguments] <Array>]
 [-Body <Object>] [-ExceptionInfo <ErrorRecord>] [<CommonParameters>]
```

## DESCRIPTION

A wrapper around `Write-Log` to allow for additional configuration options such
as setting logging levels by component.

## EXAMPLES

### EXAMPLE 1

```powershell
$log_option = @{
            Scope     = 'Audit'
            Level     = 'INFO'
            Message   = ''
            Arguments = ''
        }
Write-CustomLog @log_option -Message "Logging initialized"
```

## PARAMETERS

### -Scope

The module that the caller is logging from

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Level

The Logging Level

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

### -Message

The Message

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

### -Arguments

Arguments supplied to the message format

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body

An object that can contain additional log metadata

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExceptionInfo

An optional ErrorRecord

```yaml
Type: ErrorRecord
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

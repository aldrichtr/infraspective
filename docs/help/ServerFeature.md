---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/ServerFeature.md
schema: 2.0.0
---

# ServerFeature

## SYNOPSIS
Test if a Windows feature is installed.

## SYNTAX

### prop (Default)
```
ServerFeature [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

### noprop
```
ServerFeature [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Test if a Windows feature is installed.

Note that this function uses 'Get-WindowsFeature' to retrieve the list of features installed.
This cmdlet does not work on a desktop operating system to retieve the list of locally installed
features and as such is not supported on the desktop.

## EXAMPLES

### EXAMPLE 1
```
ServerFeature Web-Server { Should -Be $true }
```

### EXAMPLE 2
```
ServerFeature TelnetClient { Should -Be $false }
```

### EXAMPLE 3
```
ServerFeature Web-Server InstallState { Should -Be 'Installed' }
```

### EXAMPLE 4
```
ServerFeature Remote-Access InstallState { Should -Be 'Available' }
```

## PARAMETERS

### -Property
The optional property on the feature to test for.
If not specified, will default to the 'Installed' property.

```yaml
Type: String
Parameter Sets: prop
Aliases:

Required: False
Position: 3
Default value: Installed
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
The Windows feature name to test for

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
Assertions: Be, BeNullOrEmpty

## RELATED LINKS

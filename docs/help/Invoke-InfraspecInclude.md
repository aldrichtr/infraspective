---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Invoke-InfraspecInclude.md
schema: 2.0.0
---

# Invoke-InfraspecInclude

## SYNOPSIS

Include the contents of the given files.

## SYNTAX

```powershell
Invoke-InfraspecInclude [-Path] <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>]
 [-FollowSymlink] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION

Include the contents of the given file and execute the tests.

## EXAMPLES

### EXAMPLE 1: Include a file

```powershell
    Include 'Controls/dns-services.Control.ps1'
```

### EXAMPLE 2: Include a directory of files with filters

```powershell
Include 'Controls/' -Filter "*.Control.ps1" -Recurse
```

## PARAMETERS

### -Path

Specifies a path to one or more locations.
Wildcards are accepted.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter

Specifies a filter to qualify the Path parameter

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

### -Include

Specifies an array of one or more string patterns to be matched as the cmdlet
gets child items

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude

Specifies an array of one or more string patterns to be matched as the cmdlet
gets child items

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FollowSymlink

Use the FollowSymlink parameter to search the directories that target those
symbolic links

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse

Gets the items in the specified locations and in all child items of the
locations

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

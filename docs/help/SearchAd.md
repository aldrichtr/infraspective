---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/SearchAd.md
schema: 2.0.0
---

# SearchAd

## SYNOPSIS

Search Active Directory for the object

## SYNTAX

```powershell
SearchAd [-Name] <String> [-ObjectType] <String> [<CommonParameters>]
```

## DESCRIPTION

Search ActiveDirectory using ADSI searcher

## EXAMPLES

### EXAMPLE 1

```powershell
SearchAd -Name 'taldrich' -ObjectType 'User'
```

## PARAMETERS

### -Name

The property name to search

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

### -ObjectType

The type of ADSI object. Accepted values are `User`, `Group`, and
`OrganizationalUnit`

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

This cmdlet supports the common parameters: -Debug, -ErrorAction,
-ErrorVariable, -InformationAction, -InformationVariable, -OutVariable,
-OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

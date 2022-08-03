---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Get-UserRightsGrantedToAccount.md
schema: 2.0.0
---

# Get-UserRightsGrantedToAccount

## SYNOPSIS

Gets all user rights granted to an account

## SYNTAX

```powershell
Get-UserRightsGrantedToAccount [-Account] <String[]> [-ComputerName <String>] [<CommonParameters>]
```

## DESCRIPTION

Retrieves a list of all the user rights (privileges) granted to one or more accounts.
The rights retrieved
are those granted directly to the user account, and does not include those rights obtained as part of
membership to a group.

## EXAMPLES

### EXAMPLE 1: list all user rights granted to account on the local computer

```powershell
Get-UserRightsGrantedToAccount "bilbo.baggins"
```

### EXAMPLE 2: list all user rights to a list of accounts

```powershell
Get-UserRightsGrantedToAccount -Account "Edward","Karen" -Computer TESTPC
```

## PARAMETERS

### -Account

Logon name of the account.  More than one account can be listed.  If the account
is not found on the computer, the default domain is searched.  To specify a
domain, you may use either "DOMAIN\username" or "username@domain.dns" formats.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: User, Username

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ComputerName

Specifies the name of the computer on which to run this cmdlet.  If the input
for this parameter is omitted, then the cmdlet runs on the local computer.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### [string] Account

### [PS_LSA.Rights] Right

## NOTES

## RELATED LINKS

[Enumerate rights](http://msdn.microsoft.com/en-us/library/ms721790.aspx)

[Privilege constants](http://msdn.microsoft.com/en-us/library/bb530716.aspx)

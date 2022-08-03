---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Get-AccountsWithUserRight.md
schema: 2.0.0
---

# Get-AccountsWithUserRight

## SYNOPSIS

Gets all accounts that are assigned a specified privilege

## SYNTAX

```powershell
Get-AccountsWithUserRight [-Right] <Rights[]> [-ComputerName <String>] [<CommonParameters>]
```

## DESCRIPTION

Retrieves a list of all accounts that hold a specified right (privilege).  The
accounts returned are those that hold the specified privilege directly through
the user account, not as part of membership to a group.

## EXAMPLES

### EXAMPLE 1: Get all accounts that hold the "Log on as a service" right

```powershell
Get-AccountsWithUserRight SeServiceLogonRight
```

### EXAMPLE 2: Get all accounts that hold a list of rights on a specific computer

```powershell
Get-AccountsWithUserRight -Right SeServiceLogonRight,SeDebugPrivilege -ComputerName TESTPC
```

## PARAMETERS

### -Right

Name of the right to query.  More than one right may be listed.
Possible values:

```
Right                             |   Description
----------------------------------|---------------------------------------------------------------
SeTrustedCredManAccessPrivilege   |  Access Credential Manager as a trusted caller
SeNetworkLogonRight               |  Access this computer from the network
SeTcbPrivilege                    |  Act as part of the operating system
SeMachineAccountPrivilege         |  Add workstations to domain
SeIncreaseQuotaPrivilege          |  Adjust memory quotas for a process
SeInteractiveLogonRight           |  Allow log on locally
SeRemoteInteractiveLogonRight     |  Allow log on through Remote Desktop Services
SeBackupPrivilege                 |  Back up files and directories
SeChangeNotifyPrivilege           |  Bypass traverse checking
SeSystemtimePrivilege             |  Change the system time
SeTimeZonePrivilege               |  Change the time zone
SeCreatePagefilePrivilege         |  Create a pagefile
SeCreateTokenPrivilege            |  Create a token object
SeCreateGlobalPrivilege           |  Create global objects
SeCreatePermanentPrivilege        |  Create permanent shared objects
SeCreateSymbolicLinkPrivilege     |  Create symbolic links
SeDebugPrivilege                  |  Debug programs
SeDenyNetworkLogonRight           |  Deny access this computer from the network
SeDenyBatchLogonRight             |  Deny log on as a batch job
SeDenyServiceLogonRight           |  Deny log on as a service
SeDenyInteractiveLogonRight       |  Deny log on locally
SeDenyRemoteInteractiveLogonRight |  Deny log on through Remote Desktop Services
SeEnableDelegationPrivilege       |  Enable computer and user accounts to be trusted for delegation
SeRemoteShutdownPrivilege         |  Force shutdown from a remote system
SeAuditPrivilege                  |  Generate security audits
SeImpersonatePrivilege            |  Impersonate a client after authentication
SeIncreaseWorkingSetPrivilege     |  Increase a process working set
SeIncreaseBasePriorityPrivilege   |  Increase scheduling priority
SeLoadDriverPrivilege             |  Load and unload device drivers
SeLockMemoryPrivilege             |  Lock pages in memory
SeBatchLogonRight                 |  Log on as a batch job
SeServiceLogonRight               |  Log on as a service
SeSecurityPrivilege               |  Manage auditing and security log
SeRelabelPrivilege                |  Modify an object label
SeSystemEnvironmentPrivilege      |  Modify firmware environment values
SeManageVolumePrivilege           |  Perform volume maintenance tasks
SeProfileSingleProcessPrivilege   |  Profile single process
SeSystemProfilePrivilege          |  Profile system performance
SeUnsolicitedInputPrivilege       |  Read unsolicited input from a terminal device
SeUndockPrivilege                 |  Remove computer from docking station
SeAssignPrimaryTokenPrivilege     |  Replace a process level token
SeRestorePrivilege                |  Restore files and directories
SeShutdownPrivilege               |  Shut down the system
SeSyncAgentPrivilege              |  Synchronize directory service data
SeTakeOwnershipPrivilege          |  Take ownership of files or other objects
```

```yaml
Type: Rights[]
Parameter Sets: (All)
Aliases: Privilege
Accepted values: SeTrustedCredManAccessPrivilege, SeNetworkLogonRight, SeTcbPrivilege, SeMachineAccountPrivilege, SeIncreaseQuotaPrivilege, SeInteractiveLogonRight, SeRemoteInteractiveLogonRight, SeBackupPrivilege, SeChangeNotifyPrivilege, SeSystemtimePrivilege, SeTimeZonePrivilege, SeCreatePagefilePrivilege, SeCreateTokenPrivilege, SeCreateGlobalPrivilege, SeCreatePermanentPrivilege, SeCreateSymbolicLinkPrivilege, SeDebugPrivilege, SeDenyNetworkLogonRight, SeDenyBatchLogonRight, SeDenyServiceLogonRight, SeDenyInteractiveLogonRight, SeDenyRemoteInteractiveLogonRight, SeEnableDelegationPrivilege, SeRemoteShutdownPrivilege, SeAuditPrivilege, SeImpersonatePrivilege, SeIncreaseWorkingSetPrivilege, SeIncreaseBasePriorityPrivilege, SeLoadDriverPrivilege, SeLockMemoryPrivilege, SeBatchLogonRight, SeServiceLogonRight, SeSecurityPrivilege, SeRelabelPrivilege, SeSystemEnvironmentPrivilege, SeManageVolumePrivilege, SeProfileSingleProcessPrivilege, SeSystemProfilePrivilege, SeUnsolicitedInputPrivilege, SeUndockPrivilege, SeAssignPrimaryTokenPrivilege, SeRestorePrivilege, SeShutdownPrivilege, SeSyncAgentPrivilege, SeTakeOwnershipPrivilege

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ComputerName

Specifies the name of the computer on which to run this cmdlet.
If the input for this parameter is
omitted, then the cmdlet runs on the local computer.

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

### [string] Right

## NOTES

## RELATED LINKS

[Enumerate accounts](http://msdn.microsoft.com/en-us/library/ms721792.aspx)

[Privilege constants](http://msdn.microsoft.com/en-us/library/bb530716.aspx)

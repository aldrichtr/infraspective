---
Module Name: infraspective
Module Guid: 8e42807c-c2a1-4c15-9ba6-3b114736a38b
Download Help Link: https://github.com/aldrichtr/infraspective/
Help Version: 0.4.1
Locale: en-US
---

# infraspective Module

## Description

`infraspective` is a PowerShell module for testing (auditing, validating)
infrastructure using the [Pester Testing Module](https://pester.dev).

`infraspective` reads tests (written in
 [BDD style](https://www.agilealliance.org/glossary/bdd/) , like Pester) and
produces output that reports on compliance of your infrastructure to those
tests.

### Additional language features

At this time `infraspective` adds four new structures to organize and classify tests:

- [Control](Invoke-InfraspecControl.md)
- [Grouping](Invoke-InfraspecGroup.md)
- [Checklist](Invoke-InfraspecChecklist.md)
- [Include](Invoke-InfraspecInclude.md)

## Audit Cmdlets

### [Invoke-Infraspective](Invoke-Infraspective.md)

Perform an audit on the specified hosts

### [Invoke-InfraspecControl](Invoke-InfraspecControl.md)

A security control consisting of one or more tests and metadata about the test.

### [Invoke-InfraspecGroup](Invoke-InfraspecGroup.md)

A collection of security controls.

### [Invoke-InfraspecChecklist](Invoke-InfraspecChecklist.md)

A collection of security controls to check against one or more systems.

### [Invoke-InfraspecInclude](Invoke-InfraspecInclude.md)

Include the contents of the given files.

## Testing Resources (Specifications)

### [AppPool](AppPool.md)

Used To Determine if Application Pool is Running and Validate Various Properties

### [AuditPolicy](AuditPolicy.md)

Test the setting of a particular audit policy .

### [CimObject](CimObject.md)

Test the value of a CimObject Property. The Class can be provided with the
Namespace.

### [DnsHost](DnsHost.md)

Test DNS resolution to a host.

### [File](File.md)

Test the Existence or Contents of a File..

### [Firewall](Firewall.md)

Used To Determine if Firewall is Running Desired Settings

### [Folder](Folder.md)

Test if a folder exists.


### [Hotfix](Hotfix.md)

Test if a Hotfix is installed.

### [Http](Http.md)

Test that a Web Service is reachable and optionally returns specific content.

### [Interface](Interface.md)

Test a local network interface and optionally and specific property.

### [LocalGroup](LocalGroup.md)

Test if a local group exists.

### [LocalUser](LocalUser.md)

Test if a local user exists and is enabled.

### [Package](Package.md)

Test that a specified package is installed.

### [Registry](Registry.md)

Test the Existence of a Key or the Value of a given Property.

### [SearchAd](SearchAd.md)

Search ActiveDirectory using ADSI searcher

### [SecurityOption](SecurityOption.md)

Test the setting of a particular security option.

### [ServerFeature](ServerFeature.md)

Test if a Windows feature is installed.

Note that this function uses 'Get-WindowsFeature' to retrieve the list of
features installed.  This cmdlet does not work on a desktop operating system to
retrieve the list of locally installed features and as such is not supported on
the desktop.

### [Service](Service.md)

Test the Status of a given Service.

### [Share](Share.md)

Test if a share exists.

### [SoftwareProduct](SoftwareProduct.md)

Test the Existence of a Software Package or the Value of a given Property.

### [TcpPort](TcpPort.md)

Test that a Tcp Port is listening and optionally validate any
TestNetConnectionResult property.

### [UserRightsAssignment](UserRightsAssignment.md)

Test to ensure that a specific account has particular rights assignments. You
can specify to query either by account, in which case your Should block will
verify against the possible rights assigned to the account being tested; or by
right, in which case your Should block will verify against the possible accounts
that might have the right assigned to them.

### [Volume](Volume.md)

Can be specified to target a specific volume for testing

### [WebSite](WebSite.md)

Used To Determine if Web Site is Running and Validate Various Properties

## Supporting functions

### [Get-AccountsWithUserRight](Get-AccountsWithUserRight.md)

Retrieves a list of all accounts that hold a specified right (privilege). The
accounts returned are those that hold the specified privilege directly through
the user account, not as part of membership to a group.

### [Get-UserRightsGrantedToAccount](Get-UserRightsGrantedToAccount.md)

Retrieves a list of all the user rights (privileges) granted to one or more
accounts. The rights retrieved are those granted directly to the user account,
and does not include those rights obtained as part of membership to a group.

### [Test-RunAsAdmin](Test-RunAsAdmin.md)

Verifies if the current process is run as admin.

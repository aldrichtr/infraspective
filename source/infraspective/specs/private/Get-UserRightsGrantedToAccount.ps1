
function Get-UserRightsGrantedToAccount {
    <#
    .SYNOPSIS
        Gets all user rights granted to an account
    .DESCRIPTION
        Retrieves a list of all the user rights (privileges) granted to one or more accounts. The rights retrieved
        are those granted directly to the user account, and does not include those rights obtained as part of
        membership to a group.
    .EXAMPLE
        Get-UserRightsGrantedToAccount "bilbo.baggins"
     Returns a list of all user rights granted to bilbo.baggins on the local computer.
    .EXAMPLE
        Get-UserRightsGrantedToAccount -Account "Edward","Karen" -Computer TESTPC
        Returns a list of user rights granted to Edward, and a list of user rights granted to Karen, on the TESTPC
        system.
    .PARAMETER Account
        Logon name of the account. More than one account can be listed. If the account is not found on the computer,
        the default domain is searched. To specify a domain, you may use either "DOMAIN\username" or
        "username@domain.dns" formats.
    .PARAMETER Computer
        Specifies the name of the computer on which to run this cmdlet. If the input for this parameter is omitted,
        then the cmdlet runs on the local computer.
    .INPUTS
        String Account
        String Computer
    .OUTPUTS
        String Account
        PS_LSA.Rights Right
    .LINK
        http://msdn.microsoft.com/en-us/library/ms721790.aspx
        http://msdn.microsoft.com/en-us/library/bb530716.aspx
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
        [Alias('User','Username')][String[]]$Account,
        [Parameter(ValueFromPipelineByPropertyName=$true, HelpMessage="Computer name")]
        [Alias('System','ComputerName','Host')][String]$Computer
    )
    process {
        $lsa = New-Object PS_LSA.LsaWrapper($Computer)
        foreach ($Acct in $Account) {
            $output = @{'Account'=$Acct; 'Right'=$lsa.EnumerateAccountPrivileges($Acct); }
            Write-Output (New-Object -Typename PSObject -Prop $output)
        }
    }
}

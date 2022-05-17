
function AuditPolicy {
    <#
    .SYNOPSIS
        Test an Audit Policy.
    .DESCRIPTION
        Test the setting of a particular audit policy .
    .EXAMPLE
        AuditPolicy System "Security System Extension" { Should -Be Success }
    .EXAMPLE
        AuditPolicy "Logon/Logoff" Logon { Should -Be "Success and Failure"  }
    .EXAMPLE
        AuditPolicy "Account Management" "User Account Management" { Should -Not -Be "No Auditing" }
    .NOTES
        Assertions: Be, BeExactly, Match, MatchExactly
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        # Specifies the category of the Audit Policy.
        [Parameter(Mandatory, Position = 1)]
        [Alias("Category")]
        [ValidateSet(
            "System", "Logon/Logoff", "Object Access", "Privilege Use",
            "Detailed Tracking", "Policy Change", "Account Management", "DS Access", "Account Logon"
            )]
            [string]$Qualifier,

            # Specifies the subcategory of the Audit policy.
            [Parameter(Mandatory, Position=2)]
            [Alias("Subcategory")]
            [ValidateSet(
                "Security System Extension", "System Integrity", "IPsec Driver", "Other System Events",
                "Security State Change", "Logon", "Logoff", "Account Lockout", "IPsec Main Mode",
                "IPsec Quick Mode", "IPsec Extended Mode", "Special Logon", "Other Logon/Logoff Events",
                "Network Policy Server", "User / Device Claims", "Group Membership", "File System",
                "Registry", "Kernel Object", "SAM", "Certification Services", "Application Generated",
                "Handle Manipulation", "File Share", "Filtering Platform Packet Drop",
                "Filtering Platform Connection", "Other Object Access Events",
                "Detailed File Share", "Removable Storage", "Central Policy Staging", "Sensitive Privilege Use",
                "Non Sensitive Privilege Use", "Other Privilege Use Events", "Process Termination", "DPAPI Activity",
                "RPC Events", "Plug and Play Events", "Token Right Adjusted Events", "Process Creation",
                "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change",
                "MPSSVC Rule-Level Policy Change", "Filtering Platform Policy Change",
                "Other Policy Change Events", "User Account Management", "Computer Account Management",
                "Security Group Management", "Distribution Group Management", "Application Group Management",
            "Other Account Management Events", "Directory Service Changes", "Directory Service Replication",
            "Detailed Directory Service Replication", "Directory Service Access",
            "Kerberos Service Ticket Operations", "Other Account Logon Events",
            "Kerberos Authentication Service", "Credential Validation"
            )]
            [string]$Target,

            # A Script Block defining a Pester Assertion.
            [Parameter(Mandatory, Position=3)]
        [scriptblock]$Should
    )
    begin {
        function GetAuditPolicy {
            <#
            .SYNOPSIS
                Retrieve the given audit policy
            .DESCRIPTION
                A wrapper around auditpol
            #>
            [CmdletBinding()]
            param(
                # The category to get
                [Parameter( Mandatory = $true
                )]
                [string]$Category,

                # The subcategory to get
                [Parameter( Mandatory = $true
                )]
                [string]$Subcategory
                )
                begin {
                }
                process {
                    if (Test-RunAsAdmin){
                        $policy = auditpol /get /category:$Category |
                            Where-Object -FilterScript {$_ -match "^\s+$Subcategory"} |
                                ForEach-Object -Process {($_.trim() -split "\s{2,}")[1]}
                    } else {
                        throw "You must run as Administrator to test AuditPolicy"
                    }
                }
                end {
                    $policy
                }
        }
    }
    process {
        $expression = {GetAuditPolicy -Category '$Qualifier' -Subcategory '$Target'}
        $params = Get-PoshspecParam -TestName AuditPolicy -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}

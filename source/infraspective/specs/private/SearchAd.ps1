function SearchAd {
    <#
    .SYNOPSIS
        Search Active Directory for the object
    .DESCRIPTION
        Search ActiveDirectory using ADSI searcher
    .EXAMPLE
        SearchAd -Name 'taldrich' -ObjectType 'User'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('User', 'Group', 'OrganizationalUnit')]
        [string]$ObjectType
    )
    begin {
        $searcher = [adsisearcher]""
    }
    process {
        $searchString = switch ($ObjectType) {
            'Group' {
                "(&(objectClass=group)(objectCategory=group)(name=$Name))"
            }
            'User' {
                "(&(objectClass=person)(name=$Name))"
            }
            'OrganizationalUnit' {
                "(&(objectClass=organizationalUnit)(name=$Name))"
            }
            Default {}
        }
        $searcher.Filter = $searchString
    }
    end {
        $searcher.FindAll()
    }
}


Describe 'Testing the CimObject specification' -Tag @('unit', 'CimObject', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }

    Context 'CimObject w/o Namespace' {
        BeforeAll {
            $results = CimObject Win32_OperatingSystem SystemDirectory { Should -Be C:\WINDOWS\system32 }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "CimObject property 'SystemDirectory' for 'Win32_OperatingSystem' Should -Be C:\WINDOWS\system32"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty 'SystemDirectory' | Should -Be C:\WINDOWS\system32"
        }
    }

    Context 'CimObject with Namespace' {
        BeforeAll {
            $results = CimObject root/Microsoft/Windows/DesiredStateConfiguration/MSFT_DSCConfigurationStatus Error { Should -BeNullOrEmpty }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "CimObject property 'Error' for 'MSFT_DSCConfigurationStatus' at 'root/Microsoft/Windows/DesiredStateConfiguration' Should -BeNullOrEmpty"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-CimInstance -ClassName MSFT_DSCConfigurationStatus -Namespace root/Microsoft/Windows/DesiredStateConfiguration | Select-Object -ExpandProperty 'Error' | Should -BeNullOrEmpty"
        }
    }

    Context 'CimObject with PropertyExpression' {
        BeforeAll {
            $results = CimObject 'root/Microsoft/Windows/TaskScheduler/MSFT_ScheduledTask' 'Where({$_.TaskName -match "xbl"}).Count' {Should -Be '2'}
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "CimObject property 'Count' for 'MSFT_ScheduledTask' at 'Where({`$_.TaskName -match `"xbl`"})' Should -Be '2'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "(Get-CimInstance -ClassName MSFT_ScheduledTask -Namespace root/Microsoft/Windows/TaskScheduler).Where({`$_.TaskName -match `"xbl`"}).Count | Should -Be '2'"
        }
    }
}

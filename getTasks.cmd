@ECHO OFF
pwsh -nologo -noprofile -command "Invoke-Build ? | Foreach-Object { '{0}|{0}|{1}' -f $_.Name, $_.Synopsis} | sort Name"

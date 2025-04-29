## Hotfix list
`Get-HotFix | Sort-Object -Property InstalledOn -Descending | Format-Table HotFixID, Description, InstalledOn -AutoSize`

`Get-HotFix -Id KB5034441`

`wusa /uninstall /kb:5034441 /quiet /norestart`

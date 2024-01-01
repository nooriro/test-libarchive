# See https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_calculated_properties
$props = @{e="Mode";w=7},
         @{n="LastWriteFILETIME";e={$_.LastWriteTime.ToFileTime()};w=18},
         @{e="LastWriteTimeUtc";f="o";w=29},
         "Name"
Get-ChildItem filetime_test_?.txt | Format-Table $props

Write-Host 'AIB Customisation: OS Optimisations for AVD'
Write-Host 'AIB Customisation: Downloading Optimisation Scripts'
$drive = 'C:\Temp'
$appName = 'optimise'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
Set-Location $LocalPath
$osOptURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/master.zip'
$osOptURLexe = 'Windows_10_VDI_Optimize-master.zip'
$outputPath = $LocalPath + '\' + $osOptURLexe
(New-Object System.Net.WebClient).DownloadFile("$osOptURL","$outputPath")
Expand-Archive $outputPath -DestinationPath $LocalPath -Verbose
Write-Host 'AIB Customisation: Downloading of Optimisations Scripts finished'

Write-Host 'AIB Customisation: Starting OS Optimisation Script'
Set-Location -Path $LocalPath\Virtual-Desktop-Optimization-Tool-master
$osOptURL = 'https://raw.githubusercontent.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/master/Win10_VirtualDesktop_Optimize.ps1'
$osOptURLexe = 'optimize.ps1'
(New-Object System.Net.WebClient).DownloadFile("$osOptURL","$osOptURLexe")


# Patch: overide the Win10_VirtualDesktop_Optimize.ps1 - setting 'Set-NetAdapterAdvancedProperty'(see readme.md)
Write-Host 'Patch: Disabling Set-NetAdapterAdvancedProperty'
$updatePath= "$LocalPath\Virtual-Desktop-Optimization-Tool-master\Win10_VirtualDesktop_Optimize.ps1"
((Get-Content -path $updatePath -Raw) -replace 'Set-NetAdapterAdvancedProperty -DisplayName "Send Buffer Size" -DisplayValue 4MB','#Set-NetAdapterAdvancedProperty -DisplayName "Send Buffer Size" -DisplayValue 4MB') | Set-Content -Path $updatePath

# Patch: overide the REG UNLOAD, needs GC before, otherwise will Access Deny unload(see readme.md)

[System.Collections.ArrayList]$file = Get-Content $updatePath
$insert = @()
for ($i=0; $i -lt $file.count; $i++) {
if ($file[$i] -like "*& REG UNLOAD HKLM\DEFAULT*") {
    $insert += $i-1 
}
}

#add gc and sleep
$insert | ForEach-Object { $file.insert($_,"                 Write-Host 'Patch closing handles and runnng GC before reg unload' `n              `$newKey.Handle.close()` `n              [gc]::collect() `n                Start-Sleep -Seconds 15 ") }
Set-Content $updatePath $file 



# run script
# .\optimize -WindowsVersion 2004 -Verbose
.\Win10_VirtualDesktop_Optimize.ps1 -WindowsVersion 2004 -Verbose
Write-Host 'AIB Customization: Finished OS Optimisations Script'
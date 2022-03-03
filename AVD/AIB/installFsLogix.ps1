Write-Host 'AIB Customisation: Downloading FsLogix'

$fsLogixURL="https://aka.ms/fslogix_download"
$installerFile="fslogix_download.zip"

New-Item -Path C:\Temp -Name fslogix -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = 'C:\Temp\fslogix'

(New-Object System.Net.WebClient).DownloadFile("$fsLogixURL","$LocalPath\$installerFile")
Expand-Archive $LocalPath\$installerFile -DestinationPath $LocalPath

Write-Host 'AIB Customisation: Downloading of FsLogix installer finished'

Write-Host 'AIB Customisation: Comparing FsLogix versions'

$downloadedFsLogixVersion = Get-Item $LocalPath\x64\Release\FSLogixAppsSetup.exe | Select-Object VersionInfo
Write-Host 'AIB Customisation: Downloaded version number:' $downloadedFsLogixVersion.VersionInfo.FileVersion

$installedFsLogixVersion = Get-Item "C:\Program Files\FSLogix\Apps\frx.exe" | Select-Object VersionInfo
Write-Host 'AIB Customisation: Installed version number:' $installedFSLogixVersion.VersionInfo.FileVersion

if ([version]$downloadedFsLogixVersion.VersionInfo.FileVersion -gt [version]$installedFsLogixVersion.VersionInfo.FileVersion) {
    Write-Host 'AIB Customisation: Downloaded version is greator than that installed. Updating FsLogix.'
    Write-Host 'AIB Customisation: Uninstalling FsLogix'
    Start-Process `
    -FilePath $LocalPath\x64\Release\FSLogixAppsSetup.exe `
    -ArgumentList "/uninstall /quiet" `
    -Wait `
    -Passthru

    Write-Host 'AIB Customisation: Start Fslogix installer'
    Start-Process `
    -FilePath $LocalPath\x64\Release\FSLogixAppsSetup.exe `
    -ArgumentList "/install /quiet" `
    -Wait `
    -Passthru
} else {
    Write-Host 'AIB Customisation: Installed version matches the downloaded version. Skipping FsLogix update.'
}

$installedFsLogixVersion = Get-Item "C:\Program Files\FSLogix\Apps\frx.exe" | Select-Object VersionInfo
Write-Host 'AIB Customisation: Installed version number is now:' $installedFSLogixVersion.VersionInfo.FileVersion

Write-Host 'AIB Customisation: Finished Fslogix installer'
Write-Host 'AIB Customisation: Downloading FsLogix'
New-Item -Path C:\\ -Name fslogix -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = 'C:\\fslogix'
$flogixURL = 'https://raw.githubusercontent.com/HenryGelderbloem/Azure-IaC/main/AVD/AIB/fsLogixSetup.ps1'
$FslogixInstaller = 'fsLogixSetup.ps1'
$outputPath = $LocalPath + '\' + $FslogixInstaller
Invoke-WebRequest -Uri $flogixURL -OutFile $outputPath
Set-Location $LocalPath

$fsLogixURL="https://aka.ms/fslogix_download"
$installerFile="fslogix_download.zip"

Invoke-WebRequest $fsLogixURL -OutFile $LocalPath\$installerFile
Expand-Archive $LocalPath\$installerFile -DestinationPath $LocalPath
Write-Host 'AIB Customisation: Download Fslogix installer finished'

Write-Host 'AIB Customisation: Start Fslogix installer'
#Set-ExecutionPolicy -Scope:Process -ExecutionPolicy:Unrestricted
.\\FSLogixSetup.ps1 
Write-Host 'AIB Customisation: Finished Fslogix installer' 
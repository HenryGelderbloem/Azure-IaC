Write-Host 'AIB Customisation: Downloading FsLogix'
New-Item -Path C:\\ -Name fslogix -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = 'C:\\fslogix'
$flogixURL = 'https://raw.githubusercontent.com/DeanCefola/Azure-WVD/master/PowerShell/FSLogixSetup.ps1'
$FslogixInstaller = 'FSLogixSetup.ps1'
$outputPath = $LocalPath + '\' + $FslogixInstaller
Invoke-WebRequest -Uri $flogixURL -OutFile $outputPath
Set-Location $LocalPath

$fsLogixURL="https://aka.ms/fslogix_download"
$installerFile="fslogix_download.zip"

Invoke-WebRequest $fsLogixURL -OutFile $LocalPath\$installerFile
Expand-Archive $LocalPath\$installerFile -DestinationPath $LocalPath
Write-Host 'AIB Customisation: Download Fslogix installer finished'

Write-Host 'AIB Customisation: Start Fslogix installer'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
.\\FSLogixSetup.ps1 -Verbose 
Write-Host 'AIB Customisation: Finished Fslogix installer' 
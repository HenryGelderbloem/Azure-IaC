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
<#Author       : Henry Gelderbloem
# Creation Date: 2022-03-01
# Usage        : Setup FSLogix

#********************************************************************************
# Date                         Version      Changes
#------------------------------------------------------------------------
# 2022-03-01                     1.0        Intial Version
#
#
#*********************************************************************************
#
#>

######################
#    WVD Variables   #
######################
$LocalWVDpath            = "c:\temp\wvd\"
$FSLogixURI              = 'https://aka.ms/fslogix_download'
$FSInstaller             = 'FSLogixAppsSetup.zip'


####################################
#    Test/Create Temp Directory    #
####################################
if((Test-Path c:\temp) -eq $false) {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Create C:\temp Directory"
    Write-Host `
        -ForegroundColor Cyan `
        -BackgroundColor Black `
        "Creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "C:\temp Already Exists"
    Write-Host `
        -ForegroundColor Yellow `
        -BackgroundColor Black `
        "temp directory already exists"
}
if((Test-Path $LocalWVDpath) -eq $false) {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Create C:\temp\WVD Directory"
    Write-Host `
        -ForegroundColor Cyan `
        -BackgroundColor Black `
        "creating c:\temp\wvd directory"
    New-Item -Path $LocalWVDpath -ItemType Directory
}
else {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "C:\temp\WVD Already Exists"
    Write-Host `
        -ForegroundColor Yellow `
        -BackgroundColor Black `
        "c:\temp\wvd directory already exists"
}
#New-Item -Path c:\ -Name New-WVDSessionHost.log -ItemType File
Add-Content `
-LiteralPath C:\New-WVDSessionHost.log `
"
ProfilePath       = $ProfilePath
RegistrationToken = $RegistrationToken
Optimize          = $Optimize
"


#################################
#    Download WVD Componants    #
#################################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Downloading FSLogix"
    Invoke-WebRequest -Uri $FSLogixURI -OutFile "$LocalWVDpath$FSInstaller"


##############################
#    Prep for WVD Install    #
##############################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Unzip FSLogix"
Expand-Archive `
    -LiteralPath "C:\temp\wvd\$FSInstaller" `
    -DestinationPath "$LocalWVDpath\FSLogix" `
    -Force `
    -Verbose
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Location $LocalWVDpath 
Add-Content -LiteralPath C:\New-WVDSessionHost.log "UnZip FXLogix Complete"


#########################
#    FSLogix Install    #
#########################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Installing FSLogix"
$fslogix_deploy_status = Start-Process `
    -FilePath "$LocalWVDpath\FSLogix\x64\Release\FSLogixAppsSetup.exe" `
    -ArgumentList "/install /quiet" `
    -Wait `
    -Passthru

#############
#    END    #
#############
Write-Host 'AIB Customisation: Finished Fslogix installer' 
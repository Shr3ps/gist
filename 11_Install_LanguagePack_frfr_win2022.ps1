<#
Script-Name: 11_Install_LanguagePack_frfr_win2022.ps1
Team: Claranet-Azure (Anakin)
Author: Jérôme Respaut
Client: VNB
Project: PRJ-MGY9MC
Date: 31-05-2024
Version: 1.0
Goal: Download and Install French Language Pack on Windows Server 2022 
Ref: N/A
#>

# Ensure the script is running with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please run this script as an Administrator!"
    break
}

# Set the path to the folder where the .cab file is located
$languagePackPath = $env:TEMP
$languagePackFile = "Microsoft-Windows-Server-Language-Pack_x64_fr-fr.cab"

# Define the URL of the file you want to download
$url = "https://stnugetvnbshrdfrcprd.blob.core.windows.net/feed/cab/Microsoft-Windows-Server-Language-Pack_x64_fr-fr.cab?sp=r&st=2024-05-31T13:58:52Z&se=2024-09-01T21:58:52Z&spr=https&sv=2022-11-02&sr=b&sig=gz3PRpsIRgmvl2LW7D%2Ff4S0lKiBQyWVEWWGoTz3ITFs%3D"
# Define the destination path in the temporary folder
$destinationPath = Join-Path -Path $languagePackPath -ChildPath $languagePackFile
# Use Invoke-WebRequest to download the file
Invoke-WebRequest -Uri $url -OutFile $destinationPath
# Display a message indicating that the file has been downloaded
Write-Output "File downloaded to: $destinationPath"

# Full path to cab file
$cabFilePath = Join-Path -Path $languagePackPath -ChildPath $languagePackFile

# Install the French Language Pack
Add-WindowsPackage -Online -PackagePath $cabFilePath

# Set French as the UI language
$FrenchLanguageTag = "fr-FR"
Set-WinUILanguageOverride -Language $FrenchLanguageTag
Set-WinUserLanguageList $FrenchLanguageTag -Force
Set-WinUILanguageOverride $FrenchLanguageTag

# Set system locale
Set-WinSystemLocale $FrenchLanguageTag

# Output the current display language
Get-WinUILanguageOverride
Get-WinUserLanguageList
Get-WinSystemLocale

Write-Host "French language pack installed and activated."
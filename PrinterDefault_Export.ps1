#
# Script handles logoff behavior in saving default printer to profile
# Created by mikkelmoeller
#

$PrinterNotExport = "DEFINE PRINTER NAME HERE"
$ExportLocation = "$env:APPDATA\PrinterDefault_Save.reg"
$LogLocation = "$env:APPDATA\PrinterDefault_Save.log"

function Log 
{
    param([string]$Message)
    (Get-Date -Format "[yyyy-MM-dd HH:mm:ss] ") + $Message | Out-File -FilePath $LogLocation -Append -Force
}

Log "########## EXPORT START ##########"

$ActivePrinter = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\' -name Device
if ($ActivePrinter.contains("$PrinterNotExport")){
    Log "Default Printer ($ActivePrinter) will NOT exported"
         
    $RegExist = Test-Path "$ExportLocation"
    if ($RegExist -eq $true){
    $RegFileContent = Get-Content -Path "$ExportLocation"
        if ($RegFileContent[3].contains("$PrinterNotExport")){
            Remove-Item $ExportLocation -Recurse -Force
            Log "Existing Reg export is invalid and will be deleted as it contain ($ActivePrinter) as default printer"
            }
        else {
            Log "Existing Reg export is valid"
            }
           }
    }
else {
    Remove-Item $ExportLocation -Recurse -Force
    REG EXPORT "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows" $ExportLocation
    Log "Default Printer ($ActivePrinter) have been exported"
}

Log "########## EXPORT END ##########"
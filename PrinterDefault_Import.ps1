#
# Script handles Logon behavior in import of default printer to profile
# For script to function export a default printer to import into users profile and place in central location (ex. NETLOGON)
# Created by mikkelmoeller
#

$PrinterNotImport = "DEFINE PRINTER NAME HERE"
$SleepSeconds = 300
$ImportLocation = "$env:APPDATA\PrinterDefault_Save.reg"
$DefaultImportLocation = "\\DOMAIN.LOCAL\netlogon\Script\PrinterDefault_Save.reg"
$LogLocation = "$env:APPDATA\PrinterDefault_Save.log"

function Log 
{
    param([string]$Message)
    (Get-Date -Format "[yyyy-MM-dd HH:mm:ss] ") + $Message | Out-File -FilePath $LogLocation -Append -Force
}

Log "########## IMPORT START ##########"

$int = 0
Do {
    $ActivePrinter = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\' -name Device

    if ($ActivePrinter.contains("$PrinterNotImport")){
        Log "Default Printer is ($ActivePrinter) and will be overwritten"
        
        $RegExist = Test-Path $ImportLocation
        if ($RegExist -eq $false){
            Log "No export of Default Printer exists - imported default"
            REG IMPORT $DefaultImportLocation
            $PrinterAfterImport = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\' -name Device
            Log "Default Printer ($PrinterAfterImport) have been imported"
        }
        else{
            REG IMPORT $ImportLocation
            $PrinterAfterImport = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\' -name Device
            Log "Default Printer ($PrinterAfterImport) have been imported"
        }
    }
    else {
        Log "Default Printer ($ActivePrinter) is correct"
    }
    Start-Sleep -Seconds $SleepSeconds
}until($int -eq 1)

Log "########## IMPORT END ##########"
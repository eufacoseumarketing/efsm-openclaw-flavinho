Get-PrinterPort | Where-Object {$_.Name -like "*192.168.15*"} | Select Name,Protocol,PrinterHostAddress

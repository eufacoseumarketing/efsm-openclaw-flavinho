# Remover impressora atual
Remove-Printer -Name "HP DeskJet 2700" -ErrorAction SilentlyContinue
Write-Host "Impressora removida para reinstalacao limpa"

# Adicionar via IPP com deteccao automatica de driver
Add-Printer -Name "HP DeskJet 2700" -DeviceURL "http://192.168.15.25:631/ipp/print" -ErrorAction Stop
Write-Host "Adicionada via DeviceURL"

# Ver resultado
Get-Printer -Name "HP DeskJet 2700" | Select Name,DriverName,PortName,PrinterStatus

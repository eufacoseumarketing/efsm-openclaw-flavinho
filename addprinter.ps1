Add-Printer -Name "HP DeskJet 2700" -PortName "http://192.168.15.25:631/ipp/print" -DriverName "Microsoft IPP Class Driver"
Get-Printer -Name "HP DeskJet 2700" | Select Name,DriverName,PortName,PrinterStatus

# Forçar Windows Update a buscar driver da impressora
Add-Printer -Name "HP DeskJet 2700" -PortName "http://192.168.15.25:631/ipp/print" -DriverName "Microsoft IPP Class Driver" -ErrorAction SilentlyContinue
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()
$searcher.ServerSelection = 2
$updates = $searcher.Search("Type='Driver' AND IsInstalled=0")
Write-Host "Drivers disponiveis no WU:" $updates.Updates.Count
$updates.Updates | ForEach-Object { Write-Host " -" $_.Title }

# Forcar Windows Update a buscar e instalar drivers de impressora
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()
$searcher.ServerSelection = 2 # msupdate

# Buscar TODAS as atualizacoes (nao so drivers)
$searchResult = $searcher.Search("IsInstalled=0")
Write-Host "Total updates disponiveis:" $searchResult.Updates.Count

# Filtrar por drivers
$drivers = $searchResult.Updates | Where-Object { $_.Title -like "*driver*" -or $_.Categories.Name -like "*Driver*" }
Write-Host "Drivers encontrados:" $drivers.Count
$drivers | ForEach-Object { Write-Host " -" $_.Title }

# Tentar buscar especificamente por impressora
$printerDrivers = $searchResult.Updates | Where-Object { $_.Title -like "*HP*" -or $_.Title -like "*print*" -or $_.Title -like "*DeskJet*" -or $_.Title -like "*2700*" }
Write-Host "`nDrivers HP/impressora:" $printerDrivers.Count
$printerDrivers | ForEach-Object { Write-Host " -" $_.Title }

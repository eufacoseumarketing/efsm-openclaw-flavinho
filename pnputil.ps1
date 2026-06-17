# Tentar pelo catalogo do Windows Update usando pnputil
# Listar drivers de impressora HP disponiveis
Get-PrinterDriver | Where-Object {$_.Name -like "*HP*" -or $_.Manufacturer -like "*HP*"} | Select Name,Manufacturer

# Tentar forçar o download do driver pelo Windows Update
$driverName = "HP DeskJet 2700 series"
try {
  Add-PrinterDriver -Name $driverName -ErrorAction Stop
  Write-Host "Driver baixado com sucesso!"
} catch {
  Write-Host "Erro ao baixar driver: $_"
  Write-Host "Drivers disponiveis para instalacao:"
  Get-WindowsDriver -Online | Where-Object {$_.OriginalFileName -like "*hp*" -or $_.ClassName -like "*print*"}
}

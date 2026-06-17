$s=New-Object -ComObject olePrn.OleSNMP
try {
  $s.Open("192.168.15.25","public",2,3000)
  Write-Host "Descricao:" $s.Get(".1.3.6.1.2.1.1.1.0")
  Write-Host "OID:" $s.Get(".1.3.6.1.2.1.1.2.0")
  Write-Host "Nome:" $s.Get(".1.3.6.1.2.1.43.5.1.1.18.1")
  Write-Host "Serie:" $s.Get(".1.3.6.1.2.1.43.5.1.1.17.1")
  $s.Close()
} catch {
  Write-Host "ERRO:" $_.Exception.Message
}

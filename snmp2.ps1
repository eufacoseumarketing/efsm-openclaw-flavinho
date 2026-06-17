$s=New-Object -ComObject olePrn.OleSNMP
try {
  $s.Open("192.168.15.25","public",2,3000)
  Write-Host "hrDeviceDescr:" $s.Get(".1.3.6.1.2.1.25.3.2.1.3.1")
  Write-Host "prtMarkerModel:" $s.Get(".1.3.6.1.2.1.43.5.1.1.16.1")
  Write-Host "sysDescr:" $s.Get(".1.3.6.1.2.1.1.1.0")
  $s.Close()
} catch {
  Write-Host "ERRO:" $_.Exception.Message
}

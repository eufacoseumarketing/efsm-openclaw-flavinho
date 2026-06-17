$urls = @(
  "https://ftp.hp.com/pub/softlib/software13/printers/DJ2700/HPEasyStart-16.2.4-DJ2700_51_4_4865_Webpack.exe",
  "https://ftp.hp.com/pub/softlib/software13/printers/DJ2700/HPEasyStart_16_2_4.exe",
  "https://ftp.hp.com/pub/softlib/software13/COL61242/mp-163200-1/DJ2700_48_4_4865.exe",
  "https://ftp.hp.com/pub/softlib/software13/printers/DJ2700/DJ2700_Full_Webpack.exe"
)
$out = "C:\Users\Public\PCR\HP_Driver.exe"

foreach ($url in $urls) {
  Write-Host "Tentando: $url"
  try {
    $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
      Write-Host "  LINK ENCONTRADO! Baixando..."
      Start-BitsTransfer -Source $url -Destination $out
      if (Test-Path $out) {
        Write-Host "  Download OK -" (Get-Item $out).Length "bytes"
        break
      }
    }
  } catch {
    Write-Host "  Falhou: $_"
  }
}

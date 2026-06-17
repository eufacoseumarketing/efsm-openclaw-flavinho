$url = "https://ftp.hp.com/pub/softlib/software13/HP_Easy_Start/HP_Easy_Start.exe"
$out = "C:\Users\Public\PCR\HP_Easy_Start.exe"
Write-Host "Baixando HP Easy Start..."
Start-BitsTransfer -Source $url -Destination $out -Description "HP Easy Start"
if (Test-Path $out) { Write-Host "Download OK -" (Get-Item $out).Length "bytes" }
else { Write-Host "ERRO no download" }

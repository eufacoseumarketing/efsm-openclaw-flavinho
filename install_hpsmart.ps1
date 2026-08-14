Write-Host "Baixando HP Smart..."
Invoke-WebRequest -Uri "https://ftp.hp.com/pub/softlib/software13/HP_Quick_Start/HP_Smart_Installer.exe" -OutFile "$env:TEMP\HPSmartInstaller.exe"
Write-Host "Instalando HP Smart (silencioso)..."
Start-Process -FilePath "$env:TEMP\HPSmartInstaller.exe" -ArgumentList "/quiet /norestart" -Wait
Write-Host "HP Smart instalado com sucesso!"
Remove-Item "$env:TEMP\HPSmartInstaller.exe" -Force -ErrorAction SilentlyContinue

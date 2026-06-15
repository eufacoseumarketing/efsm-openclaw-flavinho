# 🧠 Procedimentos Conhecidos

> Base de conhecimento acumulada. Toda tarefa resolvida com sucesso vira uma receita aqui.
> ANTES de começar qualquer atendimento: consulte este arquivo para ver se já existe procedimento pronto.
> DEPOIS de resolver com sucesso: registre aqui com URL, comandos e passos exatos.

---

## Índice por categoria
- [IRPF 2026 — Download e Instalação](#irpf-2026--download-e-instalação)
- [📜 Scripts Prontos — PowerShell](#-scripts-prontos--powershell-ctrlc--ctrlv)
  - [🔍 Diagnóstico Rápido do PC](#-diagnóstico-rápido-do-pc)
  - [💾 Consumo de Disco — Achar Ofensores](#-consumo-de-disco--achar-ofensores)
  - [🌐 Rede](#-rede)
  - [🖨️ Impressoras](#️-impressoras)
  - [🔄 Windows Update](#-windows-update)
  - [📦 Programas Instalados](#-programas-instalados)
  - [🛡️ Antivírus](#️-antivírus)
  - [🔐 Certificado Digital](#-certificado-digital)
  - [⚡ Performance / Memória](#-performance--memória)
  - [🧹 Limpeza Rápida](#-limpeza-rápida)

---

## IRPF 2026 — Download e Instalação

**Data:** 12/06/2026
**SO:** Windows 11 Pro 25H2 (x64)

### URL de Download (Site Oficial - Receita Federal)

Página de download:
`https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf/2026`

URLs diretas (v1.4 - mai/2026):
- **Windows 64-bit:** `https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win64v1.4.exe`
- **Windows 32-bit:** `https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win32v1.4.exe`
- **Linux x86_64:** `https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Linux-x86_64v1.4.sh.bin`
- **macOS:** `https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-v1.4.dmg`
- **macOS ARM:** `https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-v1.4_arm.dmg`
- **ZIP (manual):** `https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-1.4.zip`

### Download via PowerShell
```powershell
Invoke-WebRequest -Uri 'https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win64v1.4.exe' -OutFile 'C:\Users\Public\Downloads\IRPF2026.exe'
```

⚠️ Download é grande (~200 MB). Prefira BITS para não travar:
```powershell
Start-BitsTransfer -Source 'https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win64v1.4.exe' -Destination 'C:\Users\Public\Downloads\IRPF2026.exe'
```

### Instalação
⚠️ **Instalação silenciosa com /S NÃO funciona** — o instalador abre janela gráfica e requer interação do usuário.

**Método recomendado:** Executar o .exe baixado manualmente (duplo clique) e seguir o assistente.

### Pegadinhas
- O site gov.br carrega conteúdo via JavaScript — web_fetch não extrai os links de download
- É preciso fazer grep no HTML bruto da página para encontrar as URLs diretas
- O servidor downloadirpf.receita.fazenda.gov.br bloqueia listagem de diretório (403)
- /S (NSIS silent) aparentemente não funciona para o IRPF 2026
- Instalação como SYSTEM trava sem GUI — precisa ser executada no contexto do usuário

---

## 📜 Scripts Prontos — PowerShell (CTRL+C / CTRL+V)

> Scripts testados e aprovados. Copie, cole no /api/run com powershell:true e execute.
> ⚠️ Scripts > 5s: envolva em Start-Job para não travar agente.

### 🔍 Diagnóstico Rápido do PC

**Info completa do sistema:**
```powershell
Get-ComputerInfo | Select-Object WindowsVersion, OsArchitecture, CsProcessors, CsTotalPhysicalMemory, CsUserName | Format-List
```

**Top 10 processos por CPU:**
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, Id, CPU, WorkingSet | Format-Table -AutoSize
```

**Top 10 processos por RAM:**
```powershell
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, Id, @{N='RAM_MB';E={[math]::Round($_.WorkingSet/1MB,1)}} | Format-Table -AutoSize
```

**Saúde dos discos:**
```powershell
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size, HealthStatus, OperationalStatus | Format-Table -AutoSize
```

**Espaço livre em todas as unidades:**
```powershell
Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{N='Total_GB';E={[math]::Round($_.Used/1GB+$_.Free/1GB,1)}}, @{N='Livre_GB';E={[math]::Round($_.Free/1GB,1)}}, @{N='Uso_%';E={[math]::Round(($_.Used/($_.Used+$_.Free))*100,1)}} | Format-Table -AutoSize
```

---

### 💾 Consumo de Disco — Achar Ofensores

**Top 20 pastas em C:\ (pesado, usar Start-Job):**
```powershell
Start-Job -Name "DiskScan" -ScriptBlock {
    Get-ChildItem 'C:\' -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $size = (Get-ChildItem $_.FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        [PSCustomObject]@{Pasta=$_.Name; Tamanho_GB=[math]::Round($size/1GB,2)}
    } | Sort-Object Tamanho_GB -Descending | Select-Object -First 20
}
```

**Tamanho da pasta TEMP:**
```powershell
$tempSize = (Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; Write-Host "TEMP: $([math]::Round($tempSize/1GB,2)) GB"
```

**Limpar TEMP (seguro, só arquivos temporários):**
```powershell
Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
```

**10 maiores arquivos em Downloads:**
```powershell
Get-ChildItem 'C:\Users\*\Downloads' -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First 10 Name, @{N='MB';E={[math]::Round($_.Length/1MB,1)}}, FullName | Format-Table -AutoSize
```

---

### 🌐 Rede

**Configuração de rede completa:**
```powershell
Get-NetIPConfiguration -Detailed | Format-List
```

**WiFi — rede conectada e sinal:**
```powershell
netsh wlan show interfaces
```

**WiFi — redes disponíveis:**
```powershell
netsh wlan show networks
```

**Teste de conectividade (ping Google + gateway):**
```powershell
Write-Host '=== Google (8.8.8.8) ==='; Test-Connection 8.8.8.8 -Count 2; Write-Host '=== Gateway ==='; $gw = (Get-NetRoute -DestinationPrefix '0.0.0.0/0').NextHop; Test-Connection $gw -Count 2
```

**Reset completo TCP/IP + DNS + Winsock:**
```powershell
netsh int ip reset; netsh int ipv4 reset; netsh winsock reset; ipconfig /flushdns
```

**Velocidade do adaptador:**
```powershell
Get-NetAdapter | Select-Object Name, LinkSpeed, Status | Format-Table -AutoSize
```

---

### 🖨️ Impressoras

**Listar impressoras instaladas:**
```powershell
Get-Printer | Select-Object Name, DriverName, PortName, Shared, Published | Format-Table -AutoSize
```

**Impressoras com status anormal:**
```powershell
Get-Printer | Where-Object {$_.PrinterStatus -ne 'Normal'} | Format-List Name, PrinterStatus, JobStatus
```

**Reiniciar spooler de impressão:**
```powershell
Restart-Service Spooler -Force
```

**Verificar fila de impressão:**
```powershell
Get-PrintJob -PrinterName * 2>$null | Select-Object PrinterName, JobName, SubmittedTime | Format-Table -AutoSize
```

**Limpar fila de impressão (todas impressoras):**
```powershell
Get-PrintJob -PrinterName * 2>$null | Remove-PrintJob
```

**Procurar impressoras na rede (scan porta 9100):**
```powershell
$subnet = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.PrefixOrigin -ne 'WellKnown'}).IPAddress -replace '\.\d+$',''; 1..254 | ForEach-Object { Test-NetConnection "$subnet.$_" -Port 9100 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue | Where-Object {$_.TcpTestSucceeded} | Select-Object ComputerName } | Format-Table
```
⚠️ Demora ~3-5 min. Usar Start-Job.

---

### 🔄 Windows Update

**Verificar por atualizações:**
```powershell
UsoClient StartScan
```

**Histórico de updates recentes:**
```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 20 HotFixID, Description, InstalledOn | Format-Table -AutoSize
```

**Reiniciar serviço Windows Update:**
```powershell
Get-Service wuauserv, bits, cryptsvc | Restart-Service -Force
```

**Corrigir Windows Update (DISM + SFC) — usar Start-Job:**
```powershell
Start-Job -Name "WURepair" -ScriptBlock {
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc /scannow
}
```

---

### 📦 Programas Instalados

**Listar programas:**
```powershell
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName} | Select-Object DisplayName, DisplayVersion, Publisher | Sort-Object DisplayName | Format-Table -AutoSize
```

---

### 🛡️ Antivírus

**Status do Windows Defender:**
```powershell
Get-MpComputerStatus | Select-Object AntivirusEnabled, AntispywareEnabled, RealTimeProtectionEnabled | Format-List
```

---

### 🔐 Certificado Digital

**Listar certificados do usuário:**
```powershell
certutil -store -user My
```

**Verificar token/leitora conectado:**
```powershell
Get-PnpDevice -Class SmartCardReader | Select-Object FriendlyName, Status | Format-Table -AutoSize
```

---

### ⚡ Performance / Memória

**Uso de RAM resumo:**
```powershell
$os = Get-CimInstance Win32_OperatingSystem; $total = [math]::Round($os.TotalVisibleMemorySize/1MB,1); $free = [math]::Round($os.FreePhysicalMemory/1MB,1); $used = $total - $free; Write-Host "RAM: $used GB usado de $total GB ($([math]::Round($used/$total*100,1))%)"
```

**Uptime do PC:**
```powershell
(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Select-Object Days, Hours, Minutes
```

**Desligar descanso de tela (início de suporte):**
```powershell
powercfg -change -monitor-timeout-ac 0; powercfg -change -standby-timeout-ac 0; powercfg -change -hibernate-timeout-ac 0
```

**Restaurar descanso de tela (fim de suporte):**
```powershell
powercfg -change -monitor-timeout-ac 10; powercfg -change -standby-timeout-ac 30
```

---

### 🧹 Limpeza Rápida

**Limpeza completa (Temp + Prefetch + Lixeira):**
```powershell
Remove-Item "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:WINDIR\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host 'Limpeza concluida!'
```

**Só reportar quanto daria pra limpar (sem apagar):**
```powershell
$temp = (Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
$winTemp = (Get-ChildItem "$env:WINDIR\Temp" -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
Write-Host "Temp Usuario: $([math]::Round($temp/1GB,2)) GB"
Write-Host "Temp Windows: $([math]::Round($winTemp/1GB,2)) GB"
Write-Host "Total limpavel: $([math]::Round(($temp+$winTemp)/1GB,2)) GB"
```


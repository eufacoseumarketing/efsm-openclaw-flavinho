# 🔧 Guia de Manutenção de Windows — Flavinho

> Referência rápida para diagnóstico e manutenção de Windows 10/11.
> Atualizado: 31/05/2026

---

## 🧱 A Pilha de Reparo do Windows (Ordem Correta!)

**Regra de ouro:** Reparar de baixo pra cima. Se a camada de baixo tá quebrada, consertar a de cima é inútil.

| Camada | Ferramenta | O que repara |
|--------|-----------|--------------|
| 1️⃣ Disco/Sistema de Arquivos | `CHKDSK` | Setores defeituosos, metadados do sistema de arquivos |
| 2️⃣ Imagem do Windows/Component Store | `DISM` | Blueprint do SO, repositório de componentes limpos |
| 3️⃣ Arquivos ativos do sistema | `SFC` | Arquivos protegidos em uso (DLLs, drivers, etc.) |

### ⚡ Sequência Completa de Reparo

```cmd
# 1. DISCO: Verificar e corrigir sistema de arquivos
chkdsk C: /f /r          # /f corrige erros lógicos, /r localiza bad sectors
                          # Se C: estiver em uso → agenda pro próximo boot

# 2. IMAGEM: Reparar o repositório de componentes
DISM /Online /Cleanup-Image /ScanHealth     # Escaneia por corrupção
DISM /Online /Cleanup-Image /RestoreHealth  # Repara usando Windows Update

# 3. ARQUIVOS: Verificar e reparar arquivos do sistema
sfc /scannow              # Corrige arquivos protegidos
```

**Quando cada um importa:**
- `CHKDSK /f` → PC com tela azul, arquivos corrompendo, "disco precisa ser verificado"
- `DISM` → `sfc` não consegue reparar, Windows Update falha, erros 0x800…
- `sfc /scannow` → DLLs faltando, apps nativos quebrados, Explorer instável

---

## 🧹 Limpeza de Sistema

### Limpeza de Disco Nativa
```cmd
cleanmgr /sagerun:1          # Executa limpeza automática (todas categorias)
cleanmgr /LOWDISK             # Abre com todas opções marcadas
```
```
cleanmgr /sageset:1           # Configurar categorias (roda 1x)
```

### Pastas Temp (Manual/Script)
```powershell
# Limpar Temp do usuário
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Limpar Temp do sistema
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Limpar Prefetch (opcional, seguro)
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
```
```cmd
:: CMD equivalente
del /q/f/s %TEMP%\*
del /q/f/s C:\Windows\Temp\*
```

### Storage Sense (Sensor de Armazenamento)
```
Configurações → Sistema → Armazenamento → Ativar Storage Sense
```
- Remove arquivos temporários automaticamente
- Limpa lixeira após X dias
- Remove Downloads antigos (cuidado!)

---

## 🚀 Performance — Diagnóstico e Correção

### Verificar o que tá consumindo recursos
```powershell
# Top 10 processos por CPU
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name,CPU,Id

# Top 10 processos por RAM
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name,@{N='RAM(MB)';E={[math]::Round($_.WorkingSet/1MB,1)}},Id

# Serviços rodando
Get-Service | Where-Object {$_.Status -eq "Running"} | Measure-Object | Select-Object Count
```

### Inicialização do Windows
```powershell
# Ver impacto de inicialização
Get-CimInstance Win32_StartupCommand | Select Name,Command,User

# Tempo do último boot
(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
```
- **Gerenciador de Tarefas → Inicializar** → Desabilitar o que tem "Alto impacto"
- Regra: antivírus e drivers = mantém; atualizadores/assistentes = desabilita

### Saúde do Disco
```powershell
# Verificar tipo e saúde do disco
Get-PhysicalDisk | Select MediaType,Size,HealthStatus,OperationalStatus

# SMART
Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus | Select InstanceName,PredictFailure,Reason

# Espaço livre
Get-PSDrive C | Select Used,Free
```
**Sinais de alerta no disco:**
- 100% de uso constante (HDD) → pode estar morrendo
- CrystalDiskInfo mostrando "Cuidado" ou "Ruim"
- HealthStatus ≠ "Healthy" → substituir urgente

---

## 🔄 Windows Update — Reparos

### Resetar componentes do Windows Update
```cmd
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver

ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old

net start wuauserv
net start cryptSvc
net start bits
net start msiserver
```

### Diagnóstico de Update
```powershell
Get-WindowsUpdateLog                          # Gera log detalhado
usoclient StartScan                           # Força scan
usoclient StartDownload                       # Força download
usoclient StartInstall                        # Força instalação
```

---

## 🌐 Rede — Diagnóstico

```cmd
ipconfig /all                  # IP, gateway, DNS, MAC
ipconfig /release && ipconfig /renew    # Renovar IP DHCP
ipconfig /flushdns             # Limpar cache DNS
ping 8.8.8.8                   # Teste internet
ping 192.168.15.1              # Teste gateway (ajustar IP)
tracert 8.8.8.8                # Rota até internet
nslookup google.com            # Teste resolução DNS
```

```powershell
# Reset completo de rede
netsh winsock reset
netsh int ip reset
netsh winhttp reset proxy

# Adaptadores de rede
Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select Name,LinkSpeed

# Wi-Fi
netsh wlan show interfaces     # Sinal, canal, velocidade
netsh wlan show networks       # Redes disponíveis
```

---

## 🖨️ Impressora

```powershell
# Status das impressoras
Get-Printer | Select Name,PrinterStatus,DriverName

# Impressoras com problema
Get-Printer | Where-Object {$_.PrinterStatus -ne "Normal"}

# Filas de impressão
Get-PrintJob -PrinterName "*"

# Resetar spooler (resolve 80% dos casos)
Restart-Service Spooler

# Limpar fila travada (PowerShell admin)
Get-PrintJob -PrinterName "*" | Remove-PrintJob
Stop-Service Spooler
Remove-Item "C:\Windows\System32\spool\PRINTERS\*" -Force
Start-Service Spooler
```

---

## 🛡️ Sistema — Ferramentas de Diagnóstico

### Solucionadores de Problemas (Troubleshooters)
```
Configurações → Sistema → Solucionar Problemas → Outros solucionadores
```
- Áudio, Internet, Impressora, Bluetooth, Windows Update, Teclado, etc.

### Monitor de Confiabilidade
```cmd
perfmon /rel
```
- Histórico visual de falhas (✖ vermelho), avisos (⚠ amarelo), eventos (ℹ azul)
- Excelente pra correlacionar "quando começou o problema"

### Visualizador de Eventos
```cmd
eventvwr
```
- **Logs do Windows → Sistema** = erros de driver, serviços, hardware
- **Logs do Windows → Aplicativo** = crashes de programas
- Filtrar por Nível = Erro, Crítico nas últimas 24h

### Verificação de Drivers
```powershell
# Drivers problemáticos
Get-WindowsDriver -Online | Where-Object {$_.DriverStatus -ne "Installed"}
```
```cmd
driverquery /v              # Lista todos drivers
verifier                    # Driver Verifier (avançado!)
```

---

## 🔐 Sistema — Ferramentas de Recuperação

### Modo de Segurança (Safe Mode)
```
Shift + Reiniciar → Solucionar Problemas → Opções Avançadas → Configurações de Inicialização → Modo Seguro
```
```cmd
msconfig → Inicialização do Sistema → Inicialização Segura (Mínima)
```
- Usar quando: driver quebrado, vírus, BSOD em loop
- Modo Seguro com Rede: se precisar de internet pra baixar drivers

### Ambiente de Recuperação (WinRE)
Acessar: Shift + Reiniciar OU 3 boot falhos consecutivos
- **Reparo de Inicialização** — automático, tenta corrigir boot
- **Restauração do Sistema** — volta a um ponto de restauração
- **Desinstalar Atualizações** — remove KB problemático
- **Prompt de Comando** — acesso a comandos sem bootar

### Comandos de Recuperação de Boot
```cmd
bootrec /fixmbr              # Repara Master Boot Record
bootrec /fixboot             # Repara setor de boot
bootrec /scanos              # Procura instalações Windows
bootrec /rebuildbcd          # Reconstrói configuração de boot
```

---

## 📦 Manutenção da Loja de Componentes

```cmd
# Análise e limpeza profunda
DISM /Online /Cleanup-Image /StartComponentCleanup        # Limpa versões antigas
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase  # Limpa TUDO (não desinstalar updates depois)
DISM /Online /Cleanup-Image /AnalyzeComponentStore        # Analisa o tamanho

# Verificar saúde rapidamente
DISM /Online /Cleanup-Image /CheckHealth                  # Só reporta flag de corrupção
```

---

## ⚡ Inicialização Limpa (Clean Boot)

**Objetivo:** Isolar se o problema é serviço/programa de terceiros.

```cmd
msconfig
```
1. Aba **Serviços** → Ocultar serviços Microsoft → **Desabilitar tudo**
2. Aba **Inicialização do Programa** → Abrir Gerenciador de Tarefas → Desabilitar tudo
3. Reiniciar
4. Se resolveu → ir reabilitando grupos até achar o culpado
5. Depois → **msconfig → Inicialização Normal** pra voltar

---

## 🎯 Playbooks por Sintoma

### "PC tá lento"
1. Task Manager → ver CPU/RAM/DISCO em 100%
2. `Get-Process | Sort CPU -Desc | Select -First 10`
3. Startup → desabilitar alto impacto
4. `cleanmgr /sagerun:1` + `del /q/f/s %TEMP%\*`
5. `Get-PhysicalDisk | Select HealthStatus` → se HDD 100% = trocar pra SSD
6. `DISM` + `sfc /scannow` se arquivos do sistema suspeitos

### "Tela azul" (BSOD)
1. Anotar código de erro (ex: `CRITICAL_PROCESS_DIED`)
2. Modo Seguro → ver se estabiliza
3. `perfmon /rel` → ver criticidade
4. Event Viewer → Sistema → filtrar erros críticos
5. Driver Verifier (avançado) → isolar driver culpado
6. `chkdsk C: /f /r` → disco suspeito?

### "Não conecta na internet"
1. `ipconfig /all` → tem IP? (se 169.254.x.x = sem DHCP)
2. `ping 8.8.8.8` → internet ok?
3. `ping 192.168.x.1` → gateway ok?
4. `netsh winsock reset` + `netsh int ip reset`
5. Cabo/wi-fi desligado? (olhar screenshot)
6. DNS? `nslookup google.com` vs `ping 8.8.8.8`

### "Windows Update não instala"
1. Ver código de erro (ex: 0x80070002)
2. `DISM /Online /Cleanup-Image /RestoreHealth`
3. `sfc /scannow`
4. Resetar componentes: parar serviços, renomear SoftwareDistribution
5. `usoclient StartScan` → forçar

### "Programa não abre / fecha sozinho"
1. Event Viewer → Aplicativo → ver .NET Runtime / Application Error
2. Executar como administrador
3. Modo de compatibilidade (Propriedades → Compatibilidade)
4. Reinstalar (se AppX: `Get-AppxPackage` + `Reset`)
5. `sfc /scannow` se for app nativo

---

## ⚠️ Comandos PROIBIDOS (sem autorização)
- `format`, `diskpart clean`, `del /f/s/q C:\*`
- `Remove-Item -Recurse -Force` em pastas do sistema
- `reg delete` em HKLM sem absoluta certeza
- Alterar senha de usuário
- Desligar sem avisar
- Desinstalar programas sem perguntar

---

## 📝 Check de Manutenção Mensal (Rotina)

1. ☐ Windows Update → verificar pendências
2. ☐ `cleanmgr /sagerun:1` → limpeza de disco
3. ☐ Gerenciador de Tarefas → Inicializar → revisar
4. ☐ `Get-PhysicalDisk | Select HealthStatus` → saúde do disco
5. ☐ `sfc /scannow` (rápido, 5-10 min)
6. ☐ Aplicativos → desinstalar o que não usa
7. ☐ Storage Sense → revisar configuração
8. ☐ `winget upgrade --all` → atualizar apps (Win11)
9. ☐ Backup → verificar se tá funcionando

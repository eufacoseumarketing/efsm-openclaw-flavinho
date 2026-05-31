# ⚡ Manutenção Windows — Nível Jedi

> "Eu sou um com a Força. A Força está comigo." — Chirrut Îmwe
> Nível: Mestre Jedi. Complementa `kb/windows-maintenance.md` e `kb/windows-advanced.md`.
> Atualizado: 31/05/2026

---

## 🥾 O Boot do Windows — Estágio por Estágio

Saber identificar EM QUAL ESTÁGIO o boot trava é o que separa o padawan do mestre.

```
┌─────────────────────────────────────────────────────────────┐
│ 1. UEFI/BIOS → POST → handoff ao bootloader                │
│    Sintoma de falha: PC nem liga, BIOS não carrega          │
│    Check: Hardware (RAM, CPU, PSU), reset CMOS              │
├─────────────────────────────────────────────────────────────┤
│ 2. Windows Boot Manager (bootmgfw.efi / bootmgr)           │
│    Sintoma: "Boot Device Not Found", "BOOTMGR is missing"   │
│    Check: BCD, partição EFI intacta, Secure Boot            │
├─────────────────────────────────────────────────────────────┤
│ 3. Windows OS Loader (winload.efi / winload.exe)            │
│    Sintoma: Logo do Windows congela, anel não gira          │
│    Check: ntoskrnl.exe, HAL, drivers de boot críticos       │
│    Habilite: bcdedit /set {default} bootlog Yes → ntbtlog.txt│
├─────────────────────────────────────────────────────────────┤
│ 4. NT Kernel (ntoskrnl.exe) — Fase 0 e 1                   │
│    Sintoma: Tela preta após logo, BSOD precoce              │
│    Check: Crash dump, Driver Verifier, Safe Mode            │
├─────────────────────────────────────────────────────────────┤
│ 5. Session Manager (smss.exe)                               │
│    Sintoma: "Preparing Windows" infinito                    │
│    Check: Registry hives (SYSTEM, SOFTWARE), pagefile       │
├─────────────────────────────────────────────────────────────┤
│ 6. Wininit → winlogon → lsass → services.exe                │
│    Sintoma: Tela de logon não aparece, "Welcome" infinito   │
│    Check: Serviços críticos, drivers não-críticos           │
├─────────────────────────────────────────────────────────────┤
│ 7. Userinit → Explorer → Desktop                            │
│    Sintoma: Loga mas desktop não carrega                    │
│    Check: Shell = explorer.exe no Registry, perfil corrompido│
└─────────────────────────────────────────────────────────────┘
```

### Diagnóstico de boot — ferramentas Jedi

```cmd
# Boot log (descobre qual driver trava)
bcdedit /set {default} bootlog Yes
:: Reiniciar → analisar C:\Windows\ntbtlog.txt
:: Último driver carregado antes de travar = SUSPEITO

# OS Loader verbose (mostra cada arquivo carregado)
bcdedit /set {default} sos Yes

# Kernel debug mode
bcdedit /set {default} debug Yes
bcdedit /set {default} debugtype COM
bcdedit /set {default} debugport 1
bcdedit /set {default} baudrate 115200

# Desabilitar assinatura de driver (modo teste)
bcdedit /set {default} testsigning Yes
bcdedit /set {default} nointegritychecks Yes
```

### Recuperar boot EFI manualmente
```cmd
# No WinRE Command Prompt:
diskpart
list disk
select disk 0
list partition
:: Achar partição FAT32 (~100MB) = EFI System Partition
select partition 1
assign letter=S
exit

:: Recriar bootloader
format S: /FS:FAT32 /Q
bcdboot C:\Windows /s S: /f UEFI

:: Ou, se Legacy BIOS:
bcdboot C:\Windows /s C: /f BIOS
```

---

## 🔬 ETW — Event Tracing for Windows

**A ferramenta de diagnóstico mais poderosa do Windows que ninguém usa.**

ETW é o framework que TUDO no Windows usa pra logging. Event Viewer, Performance Monitor, WPA — todos consomem ETW.

### Arquitetura
```
Providers (kernel, drivers, apps)  →  Controllers (ativam/desativam)  →  Consumers (leem eventos)
```

### Comandos Jedi
```cmd
# Listar todos os providers disponíveis
logman query providers

# Providers mais úteis:
# Microsoft-Windows-Kernel-Process      → Processos criados/destruídos
# Microsoft-Windows-Kernel-File         → Criação/exclusão de arquivos (KERNEL LEVEL!)
# Microsoft-Windows-Kernel-Registry     → Acessos ao registry (KERNEL LEVEL!)
# Microsoft-Windows-Kernel-Network      → Pacotes de rede
# Microsoft-Windows-Kernel-Disk         → I/O de disco
# Microsoft-Windows-TCPIP               → TCP/IP stack
# Microsoft-Windows-DNS-Client          → Resolução DNS
# Microsoft-Windows-Win32k              → GDI/User (UI)

# Gravar sessão de trace
logman create trace SessaoJedi -p "Microsoft-Windows-Kernel-Process" -o C:\traces\proc.etl
logman start SessaoJedi
logman stop SessaoJedi

# Gravar múltiplos providers simultaneamente
logman create trace KernelFull -p "Microsoft-Windows-Kernel-Process" "Microsoft-Windows-Kernel-File" "Microsoft-Windows-Kernel-Registry" -o C:\traces\kernel.etl
```

### ETW via PowerShell (mais moderno)
```powershell
# Criar sessão
New-EtwTraceSession -Name "JediTrace" -LogFileMode 0x8000 -LocalFilePath "C:\traces\trace.etl"

# Adicionar providers
Add-EtwTraceProvider -SessionName "JediTrace" -Guid "{22FB2CD6-0E7B-422B-A0C7-2FAD1FD0E716}" # Kernel-Process

# Parar e remover
Remove-EtwTraceSession -Name "JediTrace"
```

### PerfView — O sabre de luz do ETW
```cmd
# Baixar
# https://github.com/microsoft/perfview

# Comando jedi (grava TUDO por 60 segundos):
perfview collect -CircularMB 1000 -CollectMultiple:MinusCpu MSecCount=60000

# Analisar:
perfview view C:\traces\PerfViewData.etl
```

---

## 🧠 Windows Memory Management — Profundo

### Pools de Memória e seus problemas

```
Non-Paged Pool   → Sempre na RAM, nunca paginado. Drivers usam isso.
                    Se esgota → BSOD ou instabilidade.
Paged Pool       → Pode ser paginado pro disco.
System PTEs      → Page Table Entries do sistema.
                    Se esgotar → "Out of memory" em 32-bit.

Verificar:
Poolmon.exe (do WDK) → maior consumidor de pool
```

```powershell
# Pool usage (precisa de símbolos)
# Via Process Explorer → System Information → Memory tab
```

### Memory Leak — caçando o culpado
```cmd
# Poolmon: ordenar por Bytes, ver tag que não para de crescer
poolmon -b

# Tags comuns:
# Ntfx → NTFS (normal)
# File → Objetos de arquivo
# MmSt → Section objects (memory mapped files)
# Se driver de terceiro = tag customizada → SUSPEITO

# Encontrar driver pela tag:
findstr /s /m /c:"TagName" C:\Windows\System32\drivers\*.sys
```

### Working Set, Standby List e friends
```powershell
# Ver memória "disponível de verdade"
Get-Counter '\Memory\Available MBytes'

# Cache do sistema (Standby List)
Get-Counter '\Memory\Cache Bytes'
Get-Counter '\Memory\Standby Cache Core Bytes'

# RAMMap (Sysinternals) → melhor ferramenta visual
# Empty → Empty Standby List → libera RAM sem matar processos
```

---

## 🗂️ NTFS — Internals & Recovery

### Master File Table (MFT)
```
$MFT     → Índice de TUDO no disco. Cada arquivo = 1 registro.
$LogFile → Journal. Replay de transações.
$Bitmap  → Mapa de clusters livres/ocupados.

Comando jedi:
fsutil fsinfo ntfsinfo C:     → Info detalhada da NTFS
fsutil dirty query C:         → O disco está "dirty"?
chkdsk /f                     → Limpa flag dirty + repara
```

### Recuperar arquivo deletado (sem ferramentas de terceiro — nível hardcore)
```cmd
:: O arquivo ainda existe se:
:: 1. Não sobrescreveram os clusters
:: 2. O registro MFT ainda existe (não reutilizado)

:: Somente LEITURA:
fsutil volume dismount C:
:: Agora o volume tá offline, pode tentar recovery com Hex editor
```

⚠️ Na prática: usar `Recuva`, `PhotoRec` ou `TestDisk`. Mas saber o conceito por baixo é Jedi.

### USN Journal — o diário de bordo da NTFS
```cmd
# Ver todos os arquivos modificados desde data X
fsutil usn readdata C: 0x0000000000000000

# Com PowerShell:
$journal = fsutil usn readjournal C: csv
```

---

## 🧬 WinSxS (Component Store) — O Coração do Windows

```
C:\Windows\WinSxS\     → TODAS as versões de TODOS os componentes
C:\Windows\System32\   → São HARD LINKS pra dentro do WinSxS
                         (não ocupam espaço extra, mágica da NTFS)

Comandos jedi:
DISM /Online /Cleanup-Image /AnalyzeComponentStore  → Tamanho real e compartilhado
DISM /Online /Cleanup-Image /StartComponentCleanup   → Limpa versões obsoletas
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase  → LIMPA TUDO (irreversível!)
```

⚠️ `/ResetBase`: você NUNCA MAIS desinstala updates depois disso. Só use se:
1. O sistema está estável há meses
2. Espaço em disco crítico
3. Cliente foi avisado

---

## 🧩 COM/DCOM — Troubleshooting Jedi

COM/DCOM é como o Windows faz tudo se comunicar (OLE, ActiveX, shell extensions, etc.)

### Diagnóstico
```cmd
dcomcnfg                         # Interface gráfica
```

```powershell
# Erros COM no Event Log
Get-WinEvent -LogName System -MaxEvents 100 | Where-Object {$_.Id -eq 10010}

# Registrar/re-registrar DLL (problemas de "Class not registered")
regsvr32 /u /s nome.dll          # Desregistrar
regsvr32 /s nome.dll             # Registrar
```

### Problema clássico: "Server execution failed" ou "Class not registered"
```powershell
# 1. Achar o CLSID no Event Viewer
# 2. Localizar no Registry:
#    HKCR\CLSID\{GUID}
# 3. Ver a DLL em InprocServer32
# 4. Re-registrar a DLL
regsvr32 /s C:\caminho\da.dll

# 5. Se AppX/UWP, reregistrar o pacote:
Get-AppxPackage -Name "*NomePacote*" | ForEach-Object {
    Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
}
```

---

## 🧵 Serviços Windows — Anatomia Jedi

### Entendendo svchost.exe
Cada grupo de serviços roda em um svchost.exe separado (isolamento de falha).

```powershell
# Ver quais serviços estão em qual svchost
Get-Process -Name svchost | ForEach-Object {
    $id = $_.Id
    $svcs = Get-WmiObject Win32_Service | Where-Object {$_.ProcessId -eq $id}
    [PSCustomObject]@{PID=$id;Services=($svcs.Name -join ', ')}
} | Sort-Object PID
```

### Diagnóstico de serviço que não inicia
```cmd
sc query NomeServico          # Estado: STOPPED? START_PENDING?
sc qc NomeServico             # Config: tipo, start type, binário

# Erro 1053: Timeout na inicialização (ServicePipeTimeout)
# Erro 1058: Serviço desabilitado
# Erro 1068: Dependência não iniciou
# Erro 1079: Conta de logon inválida

# Dependências
sc enumdepend NomeServico
```

### Service SID e segurança
```cmd
# Serviços podem ter seu próprio SID pra ACL
sc qsidtype NomeServico       # RESTRICTED, UNRESTRICTED, NONE
sc showsid NomeServico        # Mostra o SID
```

---

## 🧪 Modo de Recuperação — Técnicas Extremas

### Bootar do USB/DVD e fazer Cirurgia

**1. Substituir arquivo de sistema corrompido offline:**
```cmd
:: Bootar do WinRE → Command Prompt
:: Achar a letra do Windows (geralmente não é C:)
dir D:\Windows
:: Substituir arquivo corrompido
copy D:\Windows\WinSxS\amd64_microsoft-windows-...\arquivo.dll D:\Windows\System32\arquivo.dll
```

**2. Editar Registry offline:**
```cmd
:: Carregar hive offline
reg load HKLM\OfflineSystem D:\Windows\System32\config\SYSTEM
reg load HKLM\OfflineSoftware D:\Windows\System32\config\SOFTWARE

:: Editar (ex: desabilitar driver problemático)
reg add "HKLM\OfflineSystem\ControlSet001\Services\DriverProblematico" /v Start /t REG_DWORD /d 4 /f
:: Start = 0 (boot), 1 (system), 2 (auto), 3 (manual), 4 (disabled)

:: Descarregar
reg unload HKLM\OfflineSystem
reg unload HKLM\OfflineSoftware
```

**3. Forçar remoção de update quebrado offline:**
```cmd
:: Via WinRE
dism /image:D:\ /remove-package /packagename:Package_for_KBXXXXXXX

:: Listar pacotes instalados
dism /image:D:\ /get-packages
```

---

## 🧙‍♂️ O Caminho do Jedi — Sequência Suprema de Diagnóstico

Quando o PC tá QUEBRADO e você não faz ideia do porquê:

```
1. O QUÊ? — Definir sintoma exato (BSOD? Lento? Não liga? Não conecta?)
2. QUANDO? — O que mudou? Update? Instalou algo? Queda de energia?
3. ONDE? — Safe Mode funciona? Se sim → driver/software de 3o
            Se não → sistema corrompido ou hardware
4. PADRÃO? — Acontece sempre? Só com app X? Só em rede Y?
5. MENOR COMUM DENOMINADOR — Se 2+ PCs com mesmo sintoma → ambiente (rede, GPO, patch)

FERRAMENTAS (da menos pra mais invasiva):
Safe Mode → Clean Boot → sfc → DISM → chkdsk → System Restore →
→ WinRE → Bootrec → Restore Registry → In-place Upgrade → Reset PC
```

### Stack de comando definitivo (se nada mais funcionou)
```cmd
:: Executar em ordem, parando se resolver:

1. DISM /Online /Cleanup-Image /CheckHealth
2. DISM /Online /Cleanup-Image /ScanHealth
3. DISM /Online /Cleanup-Image /RestoreHealth
4. sfc /scannow
5. chkdsk C: /f /r
6. DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
7. In-place upgrade (setup.exe da ISO, mantendo arquivos)
8. System Restore → Reset this PC (Keep nothing)
```

---

## ⚡ PowerShell Jedi — One-Liners Poderosos

```powershell
# Todos os drivers não-Microsoft com versão e data
Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.DriverProviderName -ne 'Microsoft'} | Select DeviceName,DriverProviderName,DriverVersion,DriverDate | Sort DriverProviderName

# Processos que mais escreveram em disco nos últimos 60 segundos
Get-Process | Sort-Object IODataBytesPersec -Descending | Select -First 5 Name,@{N='Write(MB/s)';E={[math]::Round($_.IODataBytesPersec/1MB,2)}}

# Serviços configurados como Auto que NÃO estão rodando (problema!)
Get-Service | Where-Object {$_.StartType -eq 'Automatic' -and $_.Status -ne 'Running'} | Select Name,Status

# Eventos críticos e erros das últimas 24h
Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=(Get-Date).AddHours(-24)} | Select -First 20 TimeCreated,Id,ProviderName,Message | Format-List

# Todos os erros de disco
Get-WinEvent -LogName System | Where-Object {$_.Id -in 7,11,15,51,52,55,153,157} | Select -First 10

# Ping sweep na rede local (descobrir dispositivos)
1..254 | ForEach-Object {Test-Connection "192.168.1.$_" -Count 1 -TimeToLive 64 -AsJob} | Get-Job | Wait-Job | Receive-Job | Select Address,StatusCode

# Top apps por uso de rede
Get-NetTCPConnection | Group-Object OwningProcess | Select Count,Name | Sort Count -Desc | Select -First 10
```

---

## 🎭 Truques Jedi Finais

### Descobrir POR QUE um processo foi iniciado
```cmd
# Process Explorer → propriedades do processo → Image tab → Parent (quem iniciou)
# Autoruns → ver se o processo tá em alguma aba
# Process Monitor → filtrar Process Create
```

### Arquivo bloqueado — quem tá segurando?
```cmd
# Process Explorer → Ctrl+F → nome do arquivo → mostra todos handles
# Linha de comando (Sysinternals):
handle.exe -a nome_do_arquivo
```

### Qual driver causou a BSOD? (sem WinDbg)
```powershell
# Último crash e driver suspeito
$dump = Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.ProviderName -eq "Microsoft-Windows-WER-SystemErrorReporting"} | Select -First 1
$dump.Message
```

### Resetar adaptador de rede SEM desconectar sessão remota
```powershell
# Só funciona com Wi-Fi redundante OU via execução agendada:
Register-ScheduledTask -TaskName "NetReset" -Action (New-ScheduledTaskAction -Execute "powershell" -Argument "Restart-NetAdapter -Name 'Ethernet'") -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1))
```
⚠️ MUITO CUIDADO ao resetar rede em sessão remota. Prefira `ipconfig /release && ipconfig /renew` primeiro.

---

> *"Powerful you have become. The dark side I sense in you."* — Yoda
>
> Use este conhecimento com sabedoria, jovem Jedi. Com grandes poderes vêm grandes `bsod`s.

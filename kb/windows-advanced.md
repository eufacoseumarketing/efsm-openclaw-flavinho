# 🔬 Manutenção Avançada de Windows — Flavinho

> Nível: Avançado. Complementa `kb/windows-maintenance.md`.
> Atualizado: 31/05/2026

---

## 🧠 Sysinternals Suite — Arsenal Completo

### Process Explorer (procexp.exe / procexp64.exe)
**"O Gerenciador de Tarefas com esteroides"**

```powershell
# Baixar direto
Invoke-WebRequest -Uri "https://live.sysinternals.com/Procexp64.exe" -OutFile "$env:TEMP\procexp64.exe"
```

**O que faz:**
- Árvore de processos com relação pai→filho (descobre processo órfão)
- CPU, GPU, RAM, I/O por processo em tempo real
- DLLs carregadas por processo (Ctrl+D) — acha DLL suspeita injetada
- Handles abertos (Ctrl+H) — quem tá segurando aquele arquivo?
- Threads com stack (Ctrl+T) — qual thread tá consumindo CPU?
- VirusTotal integrado — verifica hashes de processos na nuvem

**Uso típico:**
- PC lento e Task Manager não mostra nada → Process Explorer mostra I/O de disco escondido
- "Arquivo em uso não pode ser excluído" → Find Handle (Ctrl+F) → descobre processo
- Suspeita de malware → verificar DLLs não-Microsoft carregadas, assinatura inválida

### Process Monitor (procmon.exe / procmon64.exe)
**"Regmon + Filemon num só, turbinado"**

**O que captura:** Registro, sistema de arquivos, rede, processo/thread, profiling

**Filtros essenciais:**
```
Operation is "CreateFile" and Result is "ACCESS DENIED"  → erros de permissão
Operation is "RegSetValue" and Path contains "Run"       → persistência
Process Name is "svchost.exe" and Operation is "TCP Connect" → rede do svchost
Result is "NAME NOT FOUND"                               → arquivos/DLLs faltando
```

**Uso típico:**
- App quebrado → filtrar por Process Name → ver quais arquivos/regkeys acessa e falham
- Boot log (Enable Boot Logging) → captura o que acontece na inicialização
- "Por que esse programa tá lento?" → File Summary mostra top arquivos por tempo de I/O

### Autoruns (autoruns64.exe)
**"TUDO que inicia com o Windows, num lugar só"**

Aba principals:
- **Logon** — HKLM\Run, HKCU\Run, Startup folder
- **Explorer** — Shell extensions, context menu handlers
- **Services** — Serviços do sistema
- **Drivers** — Drivers de kernel
- **Scheduled Tasks** — Tarefas agendadas
- **Known DLLs** — DLLs de sistema
- **Winsock Providers** — LSPs (Layered Service Providers)
- **Office** — Add-ins do Office

**Comando mágico (esconder entradas Microsoft):**
```
Options → Hide Microsoft Entries ✓
Options → Hide Windows Entries ✓
```
Aí o que sobrar ≠ Microsoft = suspeito ou desnecessário.

### Outras ferramentas-chave do Sysinternals:

| Ferramenta | Função | Quando usar |
|-----------|--------|-------------|
| **TCPView** | Conexões TCP/UDP ativas em tempo real | Suspeita de conexão maliciosa, porta aberta |
| **Handle** | Linha de comando pra ver handles | Scripts, automação: `handle.exe -a arquivo.dll` |
| **PsExec** | Executar processos remotamente | Manutenção remota sem RDP |
| **PsList/PsKill** | Listar/matar processos via CLI | Automação |
| **RAMMap** | Uso detalhado da memória física | "RAM cheia sem motivo aparente" |
| **Disk2vhd** | Converter disco físico em VHD | Backup, migração |
| **Sigcheck** | Verificar assinatura digital, versão | Auditoria de segurança, malware hunting |
| **Streams** | Listar/remover NTFS Alternate Data Streams | Arquivos baixados bloqueados |

---

## 💀 Análise de Crash Dump (BSOD)

### Configurar coleta de dump
```
Configurações → Sistema → Sobre → Configurações Avançadas do Sistema →
Avançado → Inicialização e Recuperação → Configurações
```
- **Despejo de memória pequeno (256KB)** — Minidump, mínimo, bom pra começar
- **Despejo de memória do kernel** — Inclui memória do kernel mode
- **Despejo de memória completo** — Tudo (tamanho = RAM)

### Analisar com WinDbg (do Windows SDK)
```cmd
# Abrir dump
windbg -z C:\Windows\Minidump\051526-12345-01.dmp

# Comandos essenciais no WinDbg:
!analyze -v              # Análise automática detalhada
lm nt                    # Listar módulo do kernel
!process                 # Info do processo atual
!devnode 0 1             # Árvore de dispositivos
!irql                    # IRQL no momento do crash
lm kv                    # Listar todos módulos com versão
.sympath srv*c:\symbols*https://msdl.microsoft.com/download/symbols  # Configurar símbolos
.reload /f               # Recarregar símbolos
k                        # Stack trace
!analyze -show D1        # Análise detalhada do bugcheck
```

**Códigos de BSOD comuns e causas típicas:**
```
CRITICAL_PROCESS_DIED      → Processo crítico (csrss, wininit) morreu
SYSTEM_SERVICE_EXCEPTION   → Driver modo kernel fez besteira
DRIVER_IRQL_NOT_LESS_OR_EQUAL → Driver acessou memória em IRQL errado
MEMORY_MANAGEMENT          → Erro de RAM física ou driver corrupto
KERNEL_SECURITY_CHECK_FAILURE → Violação de segurança no kernel
IRQL_NOT_LESS_OR_EQUAL     → Driver bugado (quase sempre)
DPC_WATCHDOG_VIOLATION     → Driver demorou demais no DPC (SSD NVMe?)
PAGE_FAULT_IN_NONPAGED_AREA → Driver tentou acessar memória inexistente
```

### Diagnosticar sem WinDbg
```powershell
# Listar últimos crashes
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.Id -eq 1001 -or $_.Id -eq 41}

# Detalhes do último dump
Get-WinEvent -LogName System | Where-Object {$_.ProviderName -eq "Microsoft-Windows-WER-SystemErrorReporting"} | Select -First 5 | Format-List
```

---

## 🧩 WMI — Reparo Profundo

WMI (Windows Management Instrumentation) quebrado = PowerShell manco, scripts falham, inventário não funciona.

### Diagnóstico
```powershell
# Teste básico
Get-WmiObject -Class Win32_OperatingSystem

# Verificar consistência do repositório
winmgmt /verifyrepository

# Verificar se serviço tá rodando
Get-Service winmgmt
```

### Reparo
```cmd
# 1. Parar e desativar
net stop winmgmt /y
sc config winmgmt start= disabled

# 2. Resetar repositório (PERIGO: perde customizações!)
winmgmt /resetrepository

# 3. Se falhar, rebuild do zero
cd C:\Windows\System32\wbem
rename Repository Repository.old
sc config winmgmt start= auto
net start winmgmt
```

```powershell
# Recompilar MOFs
mofcomp C:\Windows\System32\wbem\*.mof

# Registrar DLLs do WMI
Get-ChildItem C:\Windows\System32\wbem\*.dll | ForEach-Object {regsvr32 /s $_.FullName}
```

### Verificar saúde depois
```powershell
winmgmt /verifyrepository          # Deve retornar "WMI repository is consistent"
Get-CimInstance -Class Win32_BIOS  # Teste funcional
```

---

## 🥾 BCDEdit — Configuração Avançada de Boot

```cmd
# Ver configuração atual (legível)
bcdedit /enum

# Lista todas entradas de boot
bcdedit /enum all /v

# Identificador do boot atual
bcdedit /enum {current}
```

### Reparos comuns de boot
```cmd
# Recriar entrada de boot
bcdboot C:\Windows /s S: /f UEFI     # S: = partição EFI (geralmente FAT32)
bcdboot C:\Windows /s C: /f BIOS     # Legacy BIOS

# Reparar entrada padrão
bcdedit /set {default} device partition=C:
bcdedit /set {default} osdevice partition=C:

# Habilitar/desabilitar opções
bcdedit /set {current} safeboot minimal    # Força Safe Mode
bcdedit /deletevalue {current} safeboot    # Remove Safe Mode
bcdedit /set {current} bootmenupolicy legacy # Menu de boot estilo F8
```

### Flags avançadas de boot
```cmd
bcdedit /set {current} nx AlwaysOn         # DEP sempre ligado
bcdedit /set {current} pae ForceEnable     # PAE forçado (32-bit)
bcdedit /set {current} increaseuserva 3072 # Aumentar espaço de user-mode (3GB)
bcdedit /set {current} numproc 4           # Limitar número de CPUs
bcdedit /set {current} maxmem 4096         # Limitar RAM (teste)
bcdedit /set {current} hypervisorlaunchtype off  # Desabilitar Hyper-V
bcdedit /set {current} tpmbootentropy ForceDisable  # Desabilitar TPM
```

---

## ⚡ Windows Performance Toolkit (WPT)

Faz parte do **Windows ADK** (Assessment and Deployment Kit).

### Windows Performance Recorder (wpr.exe)
```cmd
# Gravar performance geral (primeiro nível)
wpr -start GeneralProfile -filemode

# Gravar CPU específico
wpr -start CPU -filemode

# Parar e salvar
wpr -stop C:\traces\meutrace.etl

# Gravar com cenário customizado
wpr -start CPU -start DiskIO -start FileIO -filemode
```

### Windows Performance Analyzer (wpa.exe)
Abrir o `.etl` no WPA pra análise gráfica de:
- CPU Usage (Sampled) — qual função tá comendo CPU?
- Disk Usage — latência de disco por processo
- Memory — hard faults, standby list
- DPC/ISR — interrupções (descobre driver problemático)

---

## 📜 Registry — Troubleshooting Avançado

### Estrutura crítica (saber o que tem em cada hive):
```
HKLM\SYSTEM\CurrentControlSet\Control     → Configuração de boot, crash control
HKLM\SYSTEM\CurrentControlSet\Services    → Todos serviços e drivers
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run → Auto-start (máquina)
HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run → Auto-start (usuário)
HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon → Shell, logon
HKLM\SYSTEM\CurrentControlSet\Control\Session Manager → Boot Execute, PendingFileRename
```

### Comandos úteis
```cmd
# Backup manual de uma chave
reg export HKLM\SYSTEM\CurrentControlSet\Services C:\backup\services.reg

# Comparar antes/depois (Sysinternals: RegDiff)
# https://github.com/MicrosoftDocs/sysinternals
```

### Sinais de problema no Registry
- `.reg` corrompido (não carrega) → usar `reg load` + `reg unload`
- Hive grande demais (>500MB) → compactar (só offline, via WinRE)
- Erro "Windows could not load registry hive" → restaurar de `C:\Windows\System32\config\RegBack`

### Restaurar Registry de backup automático
```cmd
# No WinRE, após bootar do recovery:
cd C:\Windows\System32\config
ren DEFAULT DEFAULT.old
ren SAM SAM.old
ren SECURITY SECURITY.old
ren SOFTWARE SOFTWARE.old
ren SYSTEM SYSTEM.old
copy RegBack\DEFAULT .
copy RegBack\SAM .
copy RegBack\SECURITY .
copy RegBack\SOFTWARE .
copy RegBack\SYSTEM .
```
⚠️ Windows 10 1809+ desabilitou backup automático do Registry! Só tem se criou manualmente ou tem System Restore.

---

## 🚗 Driver Verifier — Caçando Driver Bugado

**Ferramenta PESADA.** Só usar quando desconfia de driver causando BSOD.

```cmd
verifier                          # Abre interface gráfica
verifier /standard /all           # Config padrão, todos drivers NÃO-Microsoft
verifier /flags 0x209BB /all      # Flags específicas
verifier /reset                   # DESLIGAR TUDO (sempre fazer depois!)
```

**Sequência segura:**
1. Criar Ponto de Restauração
2. `verifier /standard /all`
3. Reiniciar
4. Usar o PC. Se BSOD → o dump vai apontar o driver culpado
5. `verifier /reset` pra desligar

**Flags individuais (avançado):**
```
0x00000001 — Special Pool
0x00000002 — Force IRQL Checking
0x00000008 — Pool Tracking
0x00000020 — Deadlock Detection
0x00000080 — DMA Checking
0x00000100 — Security Checks
0x00000800 — IRP Logging
0x00020000 — DDI Compliance
```

---

## 🛡️ Windows Firewall — Regras Avançadas

```powershell
# Listar regras de bloqueio ativas
Get-NetFirewallRule -Action Block -Enabled True

# Bloquear programa específico
New-NetFirewallRule -DisplayName "Bloquear AppX" -Direction Outbound -Program "C:\caminho\app.exe" -Action Block

# Bloquear IP específico
New-NetFirewallRule -DisplayName "Bloquear IP" -Direction Outbound -RemoteAddress 192.168.1.100 -Action Block

# Liberar porta
New-NetFirewallRule -DisplayName "Liberar 8080" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow

# Log de firewall
Set-NetFirewallProfile -Name Domain,Public,Private -LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log -LogMaxSizeKilobytes 4096
```

---

## 📅 Task Scheduler — Diagnóstico

```powershell
# Listar tarefas ativas
Get-ScheduledTask | Where-Object {$_.State -eq "Ready" -or $_.State -eq "Running"}

# Tarefas com falha nas últimas 24h
Get-ScheduledTask | Get-ScheduledTaskInfo | Where-Object {$_.LastTaskResult -ne 0}

# Histórico de execução (precisa habilitar primeiro)
Get-WinEvent -LogName "Microsoft-Windows-TaskScheduler/Operational" -MaxEvents 20 | Where-Object {$_.Id -eq 201 -or $_.Id -eq 101}

# Desabilitar tarefa problemática
Disable-ScheduledTask -TaskName "NomeDaTarefa"
```

---

## 🔄 Group Policy — Forçar e Diagnosticar

```cmd
gpupdate /force              # Força atualização de políticas
gpupdate /target:computer    # Só políticas de máquina
gpupdate /target:user        # Só políticas de usuário
gpresult /h C:\gpreport.html # Relatório completo em HTML
gpresult /r                  # Resumo rápido no console
```

### Resetar Group Policy ao padrão (Windows 10/11 Pro+)
```cmd
:: Apagar histórico de policies locais
RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
RD /S /Q "%WinDir%\System32\GroupPolicy"
gpupdate /force
```

---

## 🔍 CBS Log — Diagnosticar Corrupção de Componentes

```cmd
# Gerar arquivo legível
findstr /c:"[SR]" C:\Windows\Logs\CBS\CBS.log > C:\sfc_details.txt

# Procurar por arquivos corrompidos específicos
findstr /c:"Cannot repair" C:\Windows\Logs\CBS\CBS.log

# DISM log
type C:\Windows\Logs\DISM\dism.log
```

**Interpretação:**
- `[SR] Repairing file` → SFC consertou
- `[SR] Cannot repair member file` → precisa de DISM
- `CSI Payload Corrupt` → corrupção no component store

---

## 🖥️ Windows Sandbox — Ambiente Isolado pra Teste

```powershell
# Habilitar (Windows 10/11 Pro ou Enterprise)
Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -All

# Depois de habilitar, abrir:
# Iniciar → Windows Sandbox
```

Útil pra: testar software suspeito, abrir anexos duvidosos, testar comandos antes de rodar no sistema real.

---

## 🧪 Comandos Avançados Diversos

### Verificar integridade de todos os pacotes AppX
```powershell
Get-AppxPackage | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

### Verificar e reparar permissões do sistema
```cmd
icacls C:\Windows\System32\* /reset /T /Q /C   # (MUITO LENTO, cuidado)
```

### Recriar cache de ícones (thumbnail cache)
```cmd
taskkill /f /im explorer.exe
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
del /f /s /q /a %LocalAppData%\IconCache.db
start explorer.exe
```

### Resetar Microsoft Store
```cmd
wsreset.exe
```

### Verificar integridade da instalação (System File Check verbose)
```cmd
sfc /scannow /offbootdir=C:\ /offwindir=C:\Windows    # Offline (via WinRE)
```

### Diagnosticar "boot lento"
```powershell
# Eventos de boot > 30 segundos
Get-WinEvent -LogName "Microsoft-Windows-Diagnostics-Performance/Operational" | Where-Object {$_.Id -eq 100} | Select -First 10
```

---

## 🎯 Playbooks Avançados por Sintoma

### "BSOD aleatório, nenhum padrão"
1. Minidump → analisar com WinDbg (`!analyze -v`)
2. Se aponta driver → Driver Verifier nesse driver
3. Se não aponta nada → Testar RAM (memtest86+), Driver Verifier /all
4. Verificar PSU, aquecimento (ferramentas OEM)

### "Explorer lento / travando"
1. Process Monitor → filtrar explorer.exe → operações lentas
2. Autoruns → Explorer tab → desabilitar shell extensions suspeitas
3. ShellExView (nirsoft) → lista todas extensions com fabricante
4. `sfc /scannow` se for explorer.exe corrompido

### "Serviço não inicia (Error 1053 / timeout)"
1. Event Viewer → Sistema → filtrar "Service Control Manager"
2. `sc query NomeServico` → estado atual
3. `sc qc NomeServico` → configuração
4. Dependências: `sc enumdepend NomeServico`
5. Verificar conta de logon (Serviços → Log On tab) — erros de senha?

### "Windows Update corrompido sem solução"
1. Resetar componentes (ver kb/windows-maintenance.md)
2. Se falhar: DISM com fonte alternativa
```cmd
# Montar ISO do Windows e usar como source
DISM /Online /Cleanup-Image /RestoreHealth /Source:ESD:E:\sources\install.esd:1 /LimitAccess
```
3. In-place upgrade (mantém dados): rodar setup.exe da ISO do Windows
4. Último recurso: Reset this PC (Keep files)

### "Perfil de usuário corrompido"
Sintomas: login lento, "User Profile Service failed", desktop vazio
```powershell
# Verificar estado do perfil
Get-WmiObject -Class Win32_UserProfile | Select LocalPath,Status,Loaded

# Reparar (criar novo perfil e migrar dados)
# 1. Criar conta local nova
# 2. Logar nela
# 3. Copiar arquivos do perfil antigo (Documentos, Desktop, Favoritos)
# 4. NUNCA copiar NTUSER.DAT (é o hive corrompido)
```

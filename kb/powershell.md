# ⚡ PowerShell — Guia Completo de Referência

> Do básico ao Jedi. Tudo que você precisa pra diagnosticar, automatizar e dominar Windows via PowerShell.
> Atualizado: 31/05/2026

---

## 🟢 NÍVEL 1 — Fundamentos (Padawan)

### O que é PowerShell
- Shell de linha de comando + linguagem de script
- Tudo é **objeto**, não texto (≠ CMD/Bash)
- `Verb-Noun` (ex: `Get-Process`, `Stop-Service`)
- Funciona no Windows, Linux e macOS

### Cmdlets essenciais
```powershell
Get-Command          # Descobrir comandos disponíveis
Get-Help Get-Process # Ajuda detalhada (com exemplos: -Examples)
Get-Member           # Ver propriedades/métodos de um objeto
Get-Process | Get-Member
```

### Pipeline — o coração do PowerShell
```powershell
# Cada | passa OBJETOS, não texto
Get-Process | Where-Object {$_.CPU -gt 100} | Sort-Object CPU -Descending | Select-Object -First 5
#          └─ filtrar                └─ ordenar            └─ limitar
```

### Variáveis e tipos
```powershell
$nome = "Flavinho"
$numero = 42
$data = Get-Date
$lista = @(1, 2, 3)
$hash = @{Nome="Mel"; Idade=30}

# Variáveis automáticas
$_          # Objeto atual no pipeline
$?          # Sucesso do último comando
$LASTEXITCODE  # Código de saída (exe externo)
$Error      # Array com todos erros da sessão
$PSVersionTable  # Versão do PowerShell
```

### Trabalhando com objetos
```powershell
# Propriedades calculadas
Get-Process | Select Name, @{N='RAM(MB)';E={[math]::Round($_.WS/1MB,1)}}

# Filtrar com Where-Object
Get-Service | Where-Object {$_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic'}

# Agrupar e contar
Get-Process | Group-Object Company | Sort Count -Desc | Select -First 10
```

---

## 🟡 NÍVEL 2 — Intermediário (Cavaleiro)

### Funções
```powershell
function Get-PCInfo {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        
        [ValidateSet("Basic","Full")]
        [string]$DetailLevel = "Basic"
    )
    
    $os = Get-CimInstance Win32_OperatingSystem -ComputerName $ComputerName
    [PSCustomObject]@{
        ComputerName = $ComputerName
        OS = $os.Caption
        RAM = [math]::Round($os.TotalVisibleMemorySize/1MB, 1)
        LastBoot = $os.LastBootUpTime
    }
}
```

### Error Handling
```powershell
# Try/Catch/Finally
try {
    Get-Content "C:\arquivo_inexistente.txt" -ErrorAction Stop
} catch {
    Write-Warning "Deu ruim: $($_.Exception.Message)"
} finally {
    Write-Host "Sempre executa isso"
}

# $ErrorActionPreference: Continue, SilentlyContinue, Stop, Inquire
# -ErrorAction por cmdlet: -ErrorAction SilentlyContinue
```

### Script blocks e Where-Object avançado
```powershell
# Where-Object com múltiplas condições (PowerShell 3+)
Get-Process | Where-Object {$_.CPU -gt 10 -and $_.WS -gt 100MB}

# ForEach-Object com Begin/Process/End
1..5 | ForEach-Object -Begin {Write-Host "Iniciando..."} -Process {$_ * 2} -End {Write-Host "Fim!"}
```

### Módulos
```powershell
Get-Module -ListAvailable     # Todos módulos instalados
Import-Module ActiveDirectory # Carregar módulo
Get-Command -Module ActiveDirectory  # Comandos do módulo
Find-Module -Name *Excel*     # Procurar no PSGallery
Install-Module -Name ImportExcel
```

### Providers e PSDrives
```powershell
Get-PSDrive                     # Ver todos drives
Get-ChildItem HKLM:\SOFTWARE    # Registry como sistema de arquivos!
Get-ChildItem Cert:\CurrentUser # Certificados como sistema de arquivos!
```

### Formatos de saída
```powershell
Format-Table -AutoSize     # Tabela (terminal)
Format-List                # Lista detalhada
Out-GridView               # Grade interativa (Windows)
Export-Csv -NoTypeInformation  # CSV
ConvertTo-Json             # JSON
Out-File -FilePath log.txt # Arquivo texto
```

---

## 🔥 NÍVEL 3 — Avançado (Mestre)

### Funções avançadas (CmdletBinding)
```powershell
function Invoke-PCResolveDiagnostic {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$ComputerName,
        
        [Parameter()]
        [PSCredential]$Credential,
        
        [Parameter()]
        [int]$ThrottleLimit = 10,
        
        [switch]$IncludeSoftware
    )
    
    begin {
        Write-Verbose "Iniciando diagnóstico em $($ComputerName.Count) PCs"
        $results = @()
    }
    
    process {
        foreach ($pc in $ComputerName) {
            Write-Progress "Verificando $pc..."
            $session = New-CimSession -ComputerName $pc -Credential $Credential
            $info = Get-CimInstance Win32_OperatingSystem -CimSession $session
            Remove-CimSession $session
            
            $results += [PSCustomObject]@{
                PC = $pc
                OS = $info.Caption
                Uptime = (Get-Date) - $info.LastBootUpTime
            }
        }
    }
    
    end {
        Write-Verbose "Diagnóstico concluído"
        $results
    }
}
```

### PowerShell Remoting (WinRM/PSRemoting)
```powershell
# Habilitar remoting (admin, uma vez)
Enable-PSRemoting -Force

# Sessão interativa
Enter-PSSession -ComputerName PC-REMOTO
Exit-PSSession

# Executar comando remoto
Invoke-Command -ComputerName PC1, PC2 -ScriptBlock {Get-Service Spooler | Restart-Service}

# Sessão persistente
$sessao = New-PSSession -ComputerName PC-REMOTO
Invoke-Command -Session $sessao -ScriptBlock {Get-Process}
Remove-PSSession $sessao

# Com credenciais
$cred = Get-Credential
Invoke-Command -ComputerName PC-REMOTO -Credential $cred -ScriptBlock {hostname}

# Throttle (paralelismo!)
Invoke-Command -ComputerName (Get-Content pcs.txt) -ThrottleLimit 50 -ScriptBlock {
    Get-Service | Where-Object Status -eq Stopped | Select Name
}
```

### CIM Sessions (não precisa de PowerShell Remoting!)
```powershell
# CIM funciona mesmo sem PSRemoting configurado!
$cim = New-CimSession -ComputerName PC-REMOTO
Get-CimInstance Win32_Service -CimSession $cim | Where-Object State -eq 'Running'
Remove-CimSession $cim

# WMI Query Language (WQL)
Get-CimInstance -Query "SELECT * FROM Win32_Process WHERE Name='chrome.exe'"
```

### Jobs e Paralelismo
```powershell
# Background job
$job = Start-Job -ScriptBlock {Get-Process | Sort CPU -Desc}
# ...faz outras coisas...
Receive-Job $job

# ForEach-Object -Parallel (PowerShell 7+)
1..10 | ForEach-Object -Parallel {
    Test-Connection "192.168.1.$_" -Count 1
} -ThrottleLimit 10

# ThreadJob (mais rápido, mesmo processo)
Start-ThreadJob -ScriptBlock {Get-Process}
```

### Advanced WMI/CIM Queries
```powershell
# Todos os softwares instalados
Get-CimInstance Win32_Product | Select Name,Vendor,Version
# ⚠️ Win32_Product é LENTO e faz reconfigure. Melhor:
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select DisplayName,Publisher,DisplayVersion

# Hardware completo
Get-CimInstance Win32_ComputerSystem | Select Manufacturer,Model,TotalPhysicalMemory
Get-CimInstance Win32_BIOS | Select Manufacturer,SMBIOSBIOSVersion,SerialNumber
Get-CimInstance Win32_DiskDrive | Select Model,Size,InterfaceType
Get-CimInstance Win32_VideoController | Select Name,AdapterRAM,DriverVersion

# Monitorar criação de processos
Register-CimIndicationEvent -Query "SELECT * FROM Win32_ProcessStartTrace" -Action {Write-Host "Novo processo: $($Event.SourceEventArgs.NewEvent.ProcessName)"}
```

---

## ⚡ NÍVEL 4 — Mestre Jedi

### JEA (Just Enough Administration)
```powershell
# Criar endpoint restrito (só comandos específicos)
New-PSSessionConfigurationFile -Path C:\JEA\HelpDesk.pssc -SessionType RestrictedRemoteServer -RoleDefinitions @{
    'CONTOSO\HelpDesk' = @{
        RoleCapabilities = 'HelpDeskCapability'
    }
}

# Role Capability (define quais comandos são permitidos)
New-PSRoleCapabilityFile -Path C:\JEA\HelpDeskCapability.psrc -VisibleCmdlets @(
    'Get-Service', 'Restart-Service', 'Get-Process'
) -VisibleFunctions @('Get-PCInfo')
```

### PowerShell DSC (Desired State Configuration)
```powershell
# Definir estado desejado
Configuration WebServer {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    Node "WebServer01" {
        WindowsFeature IIS {
            Name = "Web-Server"
            Ensure = "Present"
        }
        
        Service W3SVC {
            Name = "W3SVC"
            State = "Running"
        }
    }
}

# Compilar e aplicar
WebServer -OutputPath C:\DSC
Start-DscConfiguration -Path C:\DSC -Wait -Verbose
```

### Classes PowerShell (PowerShell 5+)
```powershell
class Computer {
    [string]$Name
    [string]$OS
    [datetime]$LastBoot
    
    Computer([string]$name) {
        $this.Name = $name
        $info = Get-CimInstance Win32_OperatingSystem -ComputerName $name
        $this.OS = $info.Caption
        $this.LastBoot = $info.LastBootUpTime
    }
    
    [string] GetUptime() {
        $uptime = (Get-Date) - $this.LastBoot
        return "$($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
    }
}
```

### Debugging
```powershell
# Breakpoints
Set-PSBreakpoint -Script C:\scripts\diagnostico.ps1 -Line 42
Set-PSBreakpoint -Variable resultado -Mode Write

# Debug interativo
# Quando o breakpoint dispara:
# s  = Step Into
# v  = Step Over  
# o  = Step Out
# c  = Continue
# l  = List source
# ?  = Evaluate expression
```

### Regular Expressions com PowerShell
```powershell
# Validar formato
'192.168.1.1' -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'

# Extrair com grupos nomeados
$log = 'Error 0x80070002 at 2024-01-15'
if ($log -match 'Error (?<code>0x[\dA-F]+) at (?<date>\d{4}-\d{2}-\d{2})') {
    $matches['code']   # 0x80070002
    $matches['date']   # 2024-01-15
}

# Substituir
'PC001-Win10' -replace 'PC(\d+)-(.+)', '$1 - $2'  # "001 - Win10"

# Select-String (grep do PowerShell)
Get-Content C:\Windows\Logs\CBS\CBS.log | Select-String "Cannot repair"
```

### PowerShell e .NET (acesso direto)
```powershell
# Chamar métodos .NET diretamente
[System.Environment]::MachineName
[System.IO.File]::ReadAllText("C:\arquivo.txt")
[System.Net.Dns]::GetHostAddresses("google.com")

# Usar classes .NET
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Manutenção concluída!")

# Namespaces úteis:
# System.IO               → Arquivos
# System.Net              → Rede
# System.Diagnostics      → Processos, EventLog
# System.Management       → WMI (legado)
# Microsoft.Win32         → Registry
```

### Logging e transcrição
```powershell
# Gravar TUDO que rola na sessão
Start-Transcript -Path C:\Logs\sessao.log -Append
# ...
Stop-Transcript

# Log estruturado
function Write-Log {
    param([string]$Message, [string]$Level="INFO")
    $entry = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Level = $Level
        Message = $Message
    }
    $entry | ConvertTo-Json | Out-File C:\Logs\support.log -Append
}
```

---

## 🎯 Playbooks de PowerShell pra PC Resolve

### Diagnóstico Rápido (um comando diz tudo)
```powershell
# Info completa do sistema
Get-ComputerInfo | Select WindowsVersion,OsName,CsTotalPhysicalMemory,CsProcessors,CsManufacturer,CsModel,BiosSeralNumber,OsLastBootUpTime

# Performance atual
Get-Counter '\Processor(_Total)\% Processor Time','\Memory\Available MBytes','\LogicalDisk(C:)\% Free Space' | Select -Expand CounterSamples | Select Path,CookedValue

# Eventos de erro recentes (top 10)
Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=(Get-Date).AddDays(-1)} -MaxEvents 10 | Select TimeCreated,Id,ProviderName,Message | Format-List
```

### Verificação de saúde
```powershell
function Test-ComputerHealth {
    $issues = @()
    
    # Disco
    $disk = Get-PhysicalDisk | Where-Object HealthStatus -ne Healthy
    if ($disk) { $issues += "DISCO COM PROBLEMA: $($disk.FriendlyName)" }
    
    # RAM disponível
    $ram = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    if ($ram -lt 2048) { $issues += "RAM BAIXA: $([math]::Round($ram,0)) MB livre" }
    
    # Disco C: cheio
    $c = Get-PSDrive C
    if ($c.Free -lt 20GB) { $issues += "DISCO C: quase cheio: $([math]::Round($c.Free/1GB,1)) GB livre" }
    
    # Serviços automáticos parados
    $svcs = Get-Service | Where-Object {$_.StartType -eq 'Automatic' -and $_.Status -ne 'Running'}
    if ($svcs) { $issues += "SERVIÇOS PARADOS: $($svcs.Name -join ', ')" }
    
    # Uptime suspeito
    $uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    if ($uptime.Days -gt 30) { $issues += "UPTIME ALTO: $($uptime.Days) dias sem reiniciar" }
    
    if ($issues.Count -eq 0) { "✅ Sistema saudável" }
    else { $issues | ForEach-Object { "⚠️ $_" } }
}
```

---

## 📝 Dicas Jedi

- `$_` é seu amigo — representa o objeto atual no pipeline
- Use `Get-Help -Examples` sempre que travar
- `Get-Member` revela TUDO sobre qualquer objeto
- `| Format-List *` mostra TODAS as propriedades (inclusive escondidas)
- `$Error[0]` mostra o último erro completo
- `Get-History` lista o que você já rodou (use `#` pra invocar por ID)
- `Ctrl+Space` no ISE/VSCode = autocomplete
- `F8` no ISE/VSCode = executar seleção

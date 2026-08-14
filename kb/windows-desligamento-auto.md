# Desligamento/Reinicialização Automática no Windows

## Problema
O computador desliga ou reinicia sozinho, principalmente durante a madrugada.

## Causas comuns
1. Windows Update agendando reinicialização automática (mais comum)
2. Manutenção Automática do Windows reiniciando o PC
3. Horário ativo mal configurado (permite reboot fora da janela)
4. Superaquecimento (desligamento por proteção térmica)
5. Fonte ou hardware com problema

## Diagnóstico

### 1. Ver logs de desligamento
```powershell
# Eventos de desligamento (1074) e desligamento inesperado (41, 6008)
Get-WinEvent -FilterHashtable @{LogName='System'; Id=1074} -MaxEvents 20 | Format-Table TimeCreated,Id,Message -Wrap
```

### 2. Ver plano de energia ativo
```cmd
powercfg /getactivescheme
```

### 3. Ver configurações de suspensão
```cmd
powercfg /q SCHEME_CURRENT SUB_SLEEP
```

### 4. Ver temperatura
```powershell
Get-CimInstance -Namespace root/WMI -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue | Select-Object @{n='TempC';e={[math]::Round($_.CurrentTemperature / 10 - 273.15, 1)}}
```

### 5. Verificar se há reboot pendente
```powershell
$rebootReq = New-Object -ComObject 'Microsoft.Update.SystemInfo'
$rebootReq.RebootRequired
```

## Solução

### Desativar descanso de tela e suspensão (início do atendimento)
```cmd
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
```

### Desativar hibernação
```cmd
powercfg /h off
```

### Impedir reinicialização automática do Windows Update
```cmd
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 2 /f
```

**AUOptions:**
- 2 = Notificar antes de baixar e instalar
- 3 = Baixar e notificar antes de instalar
- 4 = Baixar e instalar automaticamente (padrão)
- 5 = Permitir admin local escolher

### Desativar reinicialização forçada (UX Settings)
```cmd
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\UX\Settings /v RestartDisabledByPolicy /t REG_DWORD /d 1 /f
```

### Expandir horário ativo (quase 24h)
```cmd
reg add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v ActiveHoursStart /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v ActiveHoursEnd /t REG_DWORD /d 23 /f
reg add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v IsActiveHoursEnabled /t REG_DWORD /d 1 /f
```

### Desativar Manutenção Automática do Windows
```cmd
reg add HKLM\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Schedule\Maintenance /v MaintenanceDisabled /t REG_DWORD /d 1 /f
```

### Desabilitar tarefas agendadas de reboot
```cmd
schtasks /change /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /disable
schtasks /change /tn "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /disable
schtasks /change /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /disable
```

## Confirmar que resolveu
```cmd
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\UX\Settings /v RestartDisabledByPolicy
reg query HKLM\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Schedule\Maintenance /v MaintenanceDisabled
```

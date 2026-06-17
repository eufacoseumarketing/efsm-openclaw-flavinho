# 🔧 Manutenção Proativa — Playbook do Flavinho

> Quando o motor de manutenção te chamar, siga este procedimento exatamente.
> Atualizado: 17/06/2026 — v2 (revisão pós primeiros runs reais)

## ⛔ REGRA ZERO: Manutenção é HEADLESS (sem GUI)

A manutenção roda em background — pode ser de madrugada, com a tela desligada
ou ninguém na frente do PC. Por isso:

- ✅ **SÓ use `run.sh`** — comandos PowerShell/texto puro
- ❌ **NUNCA use screenshot** (`screenshot.sh`) — não tem o que ver na tela
- ❌ **NUNCA use clique** (`click.sh`) — não tem interface gráfica
- ❌ **NUNCA use teclas** (`key.sh`) — não tem janela pra receber input
- ❌ **NUNCA abra navegador** (`open-url.sh`) — ninguém vai ver

**Toda informação vem do output dos comandos. Todo diagnóstico é texto.**

## Modos de operação

O motor te passa um parâmetro `mode`:

| Modo | O que fazer | Risco |
|------|------------|-------|
| `diagnostic_only` | Pipeline completo de diagnóstico. SÓ checar e relatar. NÃO altera NADA. | Zero |
| `safe_fixes` | Pipeline completo de diagnóstico + correções seguras (limpeza, drivers, SFC/DISM) | Baixo |

**⚠️ IMPORTANTE:** `safe_fixes` NÃO é "atalho" — ele executa o MESMO diagnóstico completo
do modo `diagnostic_only` (etapas 1-8). A diferença é que DEPOIS do diagnóstico,
ele aplica correções nos itens que precisam.

## Pipeline — Diagnóstico (executar em AMBOS os modos)

As etapas 1-8 são OBRIGATÓRIAS nos dois modos. A diferença está nas ações pós-diagnóstico.

### Etapa 0: Verificar último diagnóstico (antes de começar)
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "Write-Host '=== ÚLTIMO DIAGNÓSTICO ==='; Write-Host 'Checar se há recomendações pendentes de sessão anterior nas mensagens de suporte.'"
```
Se houve diagnóstico nas últimas 24h com recomendações não resolvidas, AGIR sobre elas no safe_fixes.

### Etapa 1: Desativar descanso de tela
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "powercfg /change monitor-timeout-ac 0; powercfg /change standby-timeout-ac 0"
```
⚠️ PowerShell não aceita `&&`. Use `;` para encadear comandos.

### Etapa 2: Informações do sistema
```powershell
systeminfo | findstr /C:"OS Name" /C:"System Boot Time" /C:"Total Physical Memory"
```
Anotar: versão do Windows, uptime (dias desde último boot), RAM total.

### Etapa 3: Espaço em disco
```powershell
Get-PSDrive C | Select-Object Used,Free,@{N='FreeGB';E={[math]::Round($_.Free/1GB,1)}},@{N='PctFree';E={[math]::Round($_.Free/($_.Used+$_.Free)*100,1)}}
```

### Etapa 4: Atualizações pendentes (Windows Update + Drivers)
```powershell
# Método COM (mais confiável que wuauclt)
$session = (New-Object -ComObject Microsoft.Update.Session)
$searcher = $session.CreateUpdateSearcher()
$updates = $searcher.Search("IsInstalled=0 and Type='Software'")
Write-Host "Total pendentes: $($updates.Updates.Count)"
$updates.Updates | Select-Object -First 10 Title, IsMandatory, Categories | ForEach-Object { Write-Host "- $($_.Title) [Obrigatório: $($_.IsMandatory)]" }
```

**🚨 Diferença crucial entre modos:**
- `diagnostic_only`: só listar. NÃO instalar nada.
- `safe_fixes`: **instalar drivers** (Dell, Intel, Realtek, etc) — são seguros, raramente exigem reboot. **NÃO instalar** KBs cumulativas nem security updates (podem forçar reboot).

### Etapa 5: Integridade do sistema (SFC)
```powershell
# SFC em background com controle por arquivo
$task = Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -NoNewWindow -PassThru -RedirectStandardOutput "$env:TEMP\sfc_output.txt" -RedirectStandardError "$env:TEMP\sfc_error.txt"
# Aguardar conclusão (poll a cada 10s por até 5 min)
Start-Sleep 10
$maxWait = 300; $waited = 0
while (!$task.HasExited -and $waited -lt $maxWait) { Start-Sleep 10; $waited += 10 }
Write-Host "SFC finalizado em ${waited}s. ExitCode: $($task.ExitCode)"
Get-Content "$env:TEMP\sfc_output.txt" -Tail 5
```

**Ação (safe_fixes):** Se SFC encontrou violações, executar DISM:
```powershell
# DISM — até 15 min
Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -NoNewWindow -Wait -RedirectStandardOutput "$env:TEMP\dism_output.txt"
Get-Content "$env:TEMP\dism_output.txt" -Tail 5
```
**No diagnostic_only, pular DISM.**

### Etapa 6: Antivírus / Windows Defender
```powershell
# Status completo
Get-MpComputerStatus | Select-Object AntivirusEnabled,AntispywareEnabled,RealTimeProtectionEnabled,LastQuickScanAge,LastFullScanAge,OnAccessProtectionEnabled

# Ameaças (se houve)
Get-MpThreat | Select-Object -First 5 Name,Severity,DetectionTime,Action
```

### Etapa 7: Startup e programas
```powershell
Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,User,Location | ForEach-Object { Write-Host "- $($_.Name) -> $($_.Command) [$($_.Location)]" }
```

### Etapa 8: Eventos críticos (últimas 24h) e tamanho de temp
```powershell
# Eventos críticos
Get-EventLog System -After (Get-Date).AddDays(-1) -EntryType Error | Group-Object Source | Sort-Object Count -Descending | Select-Object -First 5 Count,Name | ForEach-Object { Write-Host "- $($_.Count)x $($_.Name)" }

# Tamanho dos temporários (só informar)
$userTemp = (Get-ChildItem "$env:TEMP" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
$sysTemp = (Get-ChildItem "C:\Windows\Temp" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
Write-Host "User Temp: $([math]::Round($userTemp/1MB,1)) MB"
Write-Host "System Temp: $([math]::Round($sysTemp/1MB,1)) MB"
```

---

## Ações — Somente safe_fixes (executar APÓS o diagnóstico)

### Ação A: Limpeza (SEMPRE executar, independente do espaço livre)
```powershell
# User temp
$b1 = (Get-ChildItem "$env:TEMP" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
$b1After = (Get-ChildItem "$env:TEMP" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
Write-Host "User Temp: $([math]::Round(($b1 - $b1After)/1MB,1)) MB liberados"

# System temp
$b2 = (Get-ChildItem "C:\Windows\Temp" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
$b2After = (Get-ChildItem "C:\Windows\Temp" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
Write-Host "System Temp: $([math]::Round(($b2 - $b2After)/1MB,1)) MB liberados"

# Lixeira
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "Lixeira: esvaziada"

# Cache Windows Update
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
$b3 = (Get-ChildItem "C:\Windows\SoftwareDistribution\Download" -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue
Write-Host "Cache WU: $([math]::Round($b3/1MB,1)) MB liberados"
```

### Ação B: Instalar drivers pendentes
```powershell
# Filtrar SÓ drivers (não KBs de segurança)
$drivers = $updates.Updates | Where-Object { $_.Title -match "Dell|Intel|Realtek|AMD|NVIDIA|Driver" -and $_.IsMandatory -eq $false }
Write-Host "Drivers pendentes: $($drivers.Count)"
if ($drivers.Count -gt 0) {
    $installer = (New-Object -ComObject Microsoft.Update.Installer)
    $installer.Updates = $drivers
    $result = $installer.Install()
    Write-Host "Resultado: $($result.ResultCode) — $($result.RebootRequired)"
}
```

### Ação C: Scan rápido do Defender (se nunca feito ou >7 dias)
```powershell
if ($status.LastFullScanAge -gt 7 -or $status.LastQuickScanAge -gt 7) {
    Start-Process -FilePath "MpCmdRun.exe" -ArgumentList "-Scan -ScanType 1" -NoNewWindow -Wait
    Write-Host "Quick scan concluído."
}
```

### Ação D: DISM (se SFC encontrou violações)
Só executar DISM se o SFC (Etapa 5) reportou `ExitCode != 0` ou "found corrupt files".
```powershell
Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -NoNewWindow -Wait -RedirectStandardOutput "$env:TEMP\dism_output.txt"
Get-Content "$env:TEMP\dism_output.txt" -Tail 5
```

---

## Relatório final

Gere um JSON ESTRUTURADO para o motor gravar em `maintenance_runs`:

```json
{
  "mode": "diagnostic_only|safe_fixes",
  "diagnostic": {
    "sistema": {
      "os": "Windows 11 Pro 10.0.26200",
      "ram_gb": 16,
      "uptime_dias": 5
    },
    "disk": {
      "drive": "C:",
      "free_gb": 169.9,
      "pct_free": 71.4,
      "status": "ok"
    },
    "sfc": {
      "status": "ok",
      "details": "Nenhuma violação de integridade"
    },
    "dism": {
      "status": "skipped|ok|repaired",
      "details": "Não executado (SFC limpo)"
    },
    "updates_pending": 1,
    "updates_details": [
      "Dell, Inc. - Driver - 0.1.43.1"
    ],
    "defender": {
      "enabled": true,
      "last_full_scan_hours": 999,
      "threats_found": 0,
      "status": "warning"
    },
    "startup_count": 7,
    "critical_events_24h": {
      "total": 14,
      "top_source": "Service Control Manager (Mesh Agent)"
    },
    "temp_mb": 280
  },
  "actions_executed": [
    "User Temp: 139 MB liberados",
    "System Temp: 139 MB liberados",
    "Lixeira: esvaziada (já vazia)",
    "Cache WU: 2 MB liberados",
    "Drivers: Dell 0.1.43.1 instalado com sucesso",
    "Defender Quick Scan: concluído sem ameaças",
    "Total liberado: ~280 MB"
  ],
  "recommendations": [
    "Defender: full scan nunca executado — agendar scan completo",
    "Mesh Agent: 17 quedas em 24h — verificar estabilidade do agente",
    "Reinicialização recomendada após instalação de driver Dell",
    "Sistema saudável, sem problemas críticos"
  ],
  "credits_used": 1,
  "duration_seconds": 420
}
```

---

## Regras de ouro (atualizadas)

1. **Diagnóstico COMPLETO sempre.** Safe_fixes não pula etapas — faz as 8 + ações.
2. **NUNCA reinicie a máquina.** Se algo pedir reboot, anote na recomendação.
3. **Drivers = SIM (safe_fixes).** São seguros, raramente exigem reboot forçado.
4. **KBs cumulativas/Security updates = NÃO.** Podem forçar reboot. Só relatar.
5. **NUNCA desabilite antivírus ou firewall.** Só relate status.
6. **NUNCA desinstale programas.** Só relate itens suspeitos no startup.
7. **Comandos longos (>10s): use Start-Process assíncrono** (ver `kb/execucao-assincrona-powershell.md`).
8. **SFC roda em AMBOS os modos.** DISM só no safe_fixes e só se SFC encontrar violações.
9. **Limpeza SEMPRE no safe_fixes.** Independente do espaço livre. Liberar disco NUNCA é ruim.
10. **Se o agente estiver busy:** espere 30s, tente de novo. Não spame.
11. **🔑 NOVIDADE: Safe_fixes herda recomendações do último diagnóstico.** Se houve diagnóstico < 24h com recomendações, execute-as (ex: "instalar driver Dell" vira ação).
12. **🔑 NOVIDADE: Scan do Defender se >7 dias sem scan.** Incluir quick scan no safe_fixes se LastQuickScanAge > 7.

## Exemplos de status

| Métrica | ok | warning | critical |
|---------|-----|---------|----------|
| Espaço livre | >20% | 10-20% | <10% |
| SFC | sem violações | — | corrompido |
| Defender | ativo + scan <7d | scan >7d | desativado |
| Updates pendentes | 0-3 | 4-10 | >10 |
| Eventos críticos 24h | 0-2 | 3-10 | >10 |
| Uptime | <7 dias | 7-30 dias | >30 dias |

## Tabela de ações por modo

| O que | diagnostic_only | safe_fixes |
|-------|:---:|:---:|
| Desativar sleep (Etapa 1) | ✅ | ✅ |
| Info sistema (Etapa 2) | ✅ | ✅ |
| Espaço em disco (Etapa 3) | ✅ | ✅ |
| Updates pendentes (Etapa 4) | ✅ Só listar | ✅ Listar + instalar drivers |
| SFC scan (Etapa 5) | ✅ | ✅ |
| DISM restore (Etapa 5) | ❌ | ✅ Se SFC corrupto |
| Defender status (Etapa 6) | ✅ | ✅ |
| Defender quick scan | ❌ | ✅ Se >7d sem scan |
| Startup (Etapa 7) | ✅ | ✅ |
| Eventos críticos (Etapa 8) | ✅ | ✅ |
| Limpar temp/lixeira/cache | ❌ | ✅ Sempre |
| Instalar drivers pendentes | ❌ | ✅ |
| Instalar KBs/security | ❌ | ❌ Nunca |

## Scripts auxiliares

### Diagnóstico rápido (1 min, sem alterações)
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "Write-Host '=== DISCO ==='; Get-PSDrive C | Select Used,Free,@{N='FreeGB';E={[math]::Round($_.Free/1GB,1)}},@{N='PctFree';E={[math]::Round($_.Free/($_.Used+$_.Free)*100,1)}}; Write-Host '=== DEFENDER ==='; Get-MpComputerStatus | Select AntivirusEnabled,RealTimeProtectionEnabled; Write-Host '=== UPDATES ==='; $s=(New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher(); $u=$s.Search('IsInstalled=0 and Type=\"Software\"'); Write-Host \"Pendentes: $($u.Updates.Count)\"; $u.Updates | Select -First 5 Title"
```

### Limpeza completa (safe_fixes)
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "Write-Host 'Limpando...'; Remove-Item \"$env:TEMP\*\" -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item \"C:\Windows\Temp\*\" -Recurse -Force -ErrorAction SilentlyContinue; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Write-Host 'OK'"
```

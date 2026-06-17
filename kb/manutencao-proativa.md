# 🔧 Manutenção Proativa — Playbook do Flavinho

> Quando o motor de manutenção te chamar, siga este procedimento exatamente.
> Atualizado: 17/06/2026

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
| `diagnostic` | Só checar e relatar. NÃO altera nada. | Zero |
| `safe_fixes` | Diagnosticar + limpezas seguras (temp, lixeira, cache, DISM/SFC) | Baixo |

## Passo a passo

### 1. Desativar descanso de tela
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "powercfg /change monitor-timeout-ac 0 && powercfg /change standby-timeout-ac 0"
```
Sempre faça primeiro — máquina dormindo = manutenção interrompida.

### 2. Coletar informações básicas do sistema
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "systeminfo | findstr /C:'OS Name' /C:'System Boot Time' /C:'Total Physical Memory' /C:'Available Physical Memory'"
```

### 3. Diagnóstico (sempre executar)

#### 3.1. Espaço em disco
```powershell
Get-PSDrive C | Select-Object Used,Free,@{N='UsedGB';E={[math]::Round($_.Used/1GB,1)}},@{N='FreeGB';E={[math]::Round($_.Free/1GB,1)}},@{N='PctFree';E={[math]::Round($_.Free/($_.Used+$_.Free)*100,1)}}
```

**Ação (safe_fixes):** Se FreeGB < 10, rodar limpeza:
```powershell
# Limpar temp do usuário
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
# Limpar temp do sistema
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
# Limpar lixeira
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
# Limpar cache do Windows Update
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue
```

#### 3.2. Saúde do disco (SFC + DISM)
```powershell
# SFC scan (rápido, ~2-5 min)
sfc /scannow

# DISM (mais lento, ~5-15 min, só em safe_fixes)
DISM /Online /Cleanup-Image /RestoreHealth
```

**Importante:** DISM só no modo `safe_fixes`. No `diagnostic`, pular.

#### 3.3. Windows Update pendentes
```powershell
# Listar updates pendentes (diagnóstico)
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()
$updates = $searcher.Search("IsInstalled=0 and Type='Software'")
Write-Host "Updates pendentes: $($updates.Updates.Count)"
$updates.Updates | Select-Object -First 10 Title
```

**⚠️ NUNCA instalar updates** — só relatar. Instalação de update pode reiniciar a máquina.

#### 3.4. Antivírus / Windows Defender
```powershell
# Status do Defender
Get-MpComputerStatus | Select-Object AntivirusEnabled,AntispywareEnabled,RealTimeProtectionEnabled,LastQuickScanAge,LastFullScanAge

# Última ameaça (se houve)
Get-MpThreat | Select-Object -First 3 Name,Severity,DetectionTime
```

#### 3.5. Programas no startup (que podem estar lentificando)
```powershell
Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,User | Format-List
```

**Ação (safe_fixes):** Só relatar. Não desabilitar sem autorização.

#### 3.6. Eventos críticos do sistema (últimas 24h)
```powershell
Get-EventLog System -After (Get-Date).AddDays(-1) -EntryType Error | Select-Object -First 10 TimeGenerated,Source,Message | Format-List
```

### 4. Relatório final

Gere um JSON ESTRUTURADO para o motor gravar em `maintenance_runs`:

```json
{
  "mode": "diagnostic|safe_fixes",
  "diagnostic": {
    "disk": {
      "drive": "C:",
      "total_gb": 238,
      "free_gb": 85,
      "pct_free": 35.7,
      "status": "ok|warning|critical"
    },
    "sfc": {
      "status": "ok|corrupted",
      "details": "Windows Resource Protection did not find any integrity violations"
    },
    "dism": {
      "status": "ok|repaired|failed|skipped",
      "details": "..."
    },
    "updates_pending": 5,
    "defender": {
      "enabled": true,
      "last_scan_age_hours": 12,
      "threats_found": 0
    },
    "startup_count": 8,
    "critical_events_24h": 2
  },
  "actions_executed": [
    "Limpeza de arquivos temporários: 2.3 GB liberados",
    "Lixeira esvaziada: 450 MB",
    "SFC: nenhuma violação de integridade",
    "DISM: restauração concluída com sucesso"
  ],
  "recommendations": [
    "Espaço em disco OK (35% livre)",
    "Windows Defender ativo e atualizado",
    "5 updates do Windows pendentes — agendar instalação",
    "2 erros críticos no Event Log nas últimas 24h — verificar origem"
  ],
  "credits_used": 1,
  "duration_seconds": 180
}
```

### 5. Gravar na KB se encontrar algo novo

Se descobrir um problema recorrente ou solução nova, adicione em `kb/manutencao-proativa.md`.

## Regras de ouro

1. **Diagnóstico primeiro, ação depois.** Sempre rode o diagnóstico completo antes de qualquer limpeza.
2. **NUNCA reinicie a máquina.** Se algo pedir reboot, pule.
3. **NUNCA instale updates do Windows.** Só relate pendências.
4. **NUNCA desabilite antivírus ou firewall.** Só relate status.
5. **NUNCA desinstale programas.** Só relate itens suspeitos no startup.
6. **Comandos longos (>10s): use Start-Process assíncrono** (ver `kb/execucao-assincrona-powershell.md`).
7. **DISM e SFC podem ser demorados** — execute um de cada vez, aguarde conclusão.
8. **Se o agente estiver busy:** espere 30s, tente de novo. Não spame.

## Exemplos de status

| Métrica | ok | warning | critical |
|---------|-----|---------|----------|
| Espaço livre | >20% | 10-20% | <10% |
| SFC | sem violações | — | corrompido |
| Defender | ativo + scan <7d | scan >7d | desativado |
| Updates pendentes | 0-2 | 3-10 | >10 |
| Eventos críticos 24h | 0-2 | 3-10 | >10 |

## Scripts auxiliares

### Check rápido (30s, diagnóstico básico)
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "Write-Host '=== DISCO ==='; Get-PSDrive C | Select Used,Free,@{N='FreeGB';E={[math]::Round(\`$_.Free/1GB,1)}},@{N='PctFree';E={[math]::Round(\`$_.Free/(\`$_.Used+\`$_.Free)*100,1)}}; Write-Host '=== DEFENDER ==='; Get-MpComputerStatus | Select AntivirusEnabled,RealTimeProtectionEnabled; Write-Host '=== UPDATES ==='; \`$s=(New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher(); Write-Host \"Pendentes: \$((\`$s.Search('IsInstalled=0 and Type=\`\"Software\`\"')).Updates.Count)\""
```

### Limpeza rápida (safe_fixes)
```bash
bash skills/pc-resolve/scripts/run.sh --name "<NOME>" --cmd "Write-Host 'Limpando temp...'; Remove-Item \"\`$env:TEMP\\*\" -Recurse -Force -ErrorAction SilentlyContinue; Write-Host 'Limpando lixeira...'; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Write-Host 'OK'"
```

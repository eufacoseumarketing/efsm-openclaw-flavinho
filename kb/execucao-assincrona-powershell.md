# Execução Assíncrona — Anti-Travamento do Agente

**Data:** 13/06/2026
**Motivo:** Agentes MeshCentral travavam com comandos demorados via /api/run

## Problema

O agente MeshCentral na ponta NÃO suporta comandos de longa duração via API REST. Se o PowerShell pai fica esperando um processo filho terminar, a conexão HTTP fica pendurada e o agente trava — todos os comandos seguintes respondem "busy".

## Causa raiz

O `/api/run` faz uma chamada HTTP síncrona. O MeshCentral espera o processo terminar pra devolver o output. Se o processo demora, o slot fica ocupado.

## Solução

**O PowerShell pai NUNCA deve esperar o filho. Deve DISPARAR e MORRER.**

## Hierarquia de métodos assíncronos

### 1. Start-Process (GUI e instaladores) — PADRÃO
```powershell
Start-Process 'C:\caminho\programa.exe' -WindowStyle Normal
```
- Ideal pra: executar .exe, instaladores, abrir programas
- SEM `-Wait`: o PowerShell lança o filho e termina
- Libera o slot imediatamente

### 2. Start-BitsTransfer (Downloads) — ARQUIVOS
```powershell
Start-BitsTransfer -Source 'URL' -Destination 'C:\Users\Public\Downloads\arquivo.exe' -Asynchronous
```
- Ideal pra: downloads de qualquer tamanho
- `-Asynchronous`: dispara o BITS e retorna na hora
- Monitorar depois: `Get-BitsTransfer`

### 3. Start-Job (Scripts pesados) — BACKGROUND
```powershell
Start-Job -Name "PCR_Task" -ScriptBlock {
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc /scannow
}
```
- Ideal pra: DISM, sfc, Get-WindowsUpdate, scripts > 10s
- Roda em background como job nativo do PowerShell
- ⚠️ **NÃO use pra acompanhar (poll) entre comandos:** cada comando do plugin roda num
  PowerShell NOVO — `Get-Job`/`Receive-Job` numa chamada seguinte não enxerga o job (o
  estado morreu com o processo anterior). Para qualquer tarefa que você precise acompanhar,
  use o **padrão via arquivo** abaixo (o arquivo sobrevive entre os comandos).

### 4. cmd /c start (Legado) — DUPLO DESACOPLAMENTO
```cmd
cmd /c start "" "C:\programa.exe"
```
- Ideal pra: programas antigos, batch files
- O cmd lança o processo e morre — duplo desacoplamento

### 5. Scheduled Task (Complexo multi-etapa) — ZERO ACOPLAMENTO
```powershell
$action = New-ScheduledTaskAction -Execute 'powershell' -Argument '-File C:\script.ps1'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(5)
Register-ScheduledTask -TaskName 'PCR_Job' -Action $action -Trigger $trigger -Force
Start-ScheduledTask -TaskName 'PCR_Job'
```
- Ideal pra: operações com múltiplas etapas, scripts longos
- Executado pelo Task Scheduler do Windows, completamente desacoplado
- Limpar depois: `Unregister-ScheduledTask -TaskName 'PCR_Job' -Confirm:$false`

## O que NUNCA fazer

| ❌ PROIBIDO | ✅ USE EM VEZ |
|---|---|
| `& '.\programa.exe'` direto | `Start-Process '.\programa.exe'` |
| `Invoke-WebRequest URL` sem -OutFile | `Start-BitsTransfer` ou `iwr URL -OutFile` |
| SendKeys via run.sh | API /api/key, /api/type |
| `Start-Process ... -Wait` | `Start-Job -ScriptBlock { Start-Process ... -Wait }` |
| Dois comandos paralelos | Serializar: um por vez |
| `msiexec /i ...` direto | `Start-Process msiexec -ArgumentList '/i ...'` |

## Controle via arquivo (PADRÃO p/ qualquer tarefa que você precise acompanhar)

Como cada comando roda num PowerShell novo, o estado em memória se perde entre as chamadas.
A saída vai pra um **arquivo** + um **marcador de fim**; você faz poll **lendo o arquivo**.

### 1. Dispara destacado → saída pro arquivo + marcador (libera o slot na hora)
```powershell
$d="$env:PUBLIC\PCR"; New-Item -ItemType Directory -Force $d | Out-Null
$t="PCR_task"; Remove-Item "$d\$t.*" -ErrorAction SilentlyContinue
Start-Process powershell -WindowStyle Hidden -ArgumentList @('-NoProfile','-Command',
  "& { <COMANDO LONGO AQUI> } *>&1 | Out-File -Encoding utf8 '$d\$t.out'; 'DONE' | Out-File '$d\$t.done'")
```

### 2. Poll — leia o arquivo de tempos em tempos (rápido, não segura o slot)
```powershell
$d="$env:PUBLIC\PCR"; $t="PCR_task"
if (Test-Path "$d\$t.done") { "STATUS=FINISHED"; Get-Content "$d\$t.out" }
else { "STATUS=RUNNING"; Get-Content "$d\$t.out" -Tail 8 -ErrorAction SilentlyContinue }
```
Entre os polls: `sleep` (use `sleep.sh`). Teto: ~10 polls / ~2 min. Estourou e ainda
RUNNING → avise o usuário e pergunte se continua esperando ou para.

### 3. Limpeza (SEMPRE, ao terminar)
```powershell
Remove-Item "$env:PUBLIC\PCR\PCR_task.*" -Force -ErrorAction SilentlyContinue
```

## Receita: descobrir impressora na rede (assíncrono + arquivo)

⛔ NUNCA monte o script inline — aspas interpoladas quebram SEMPRE.
✅ Use here-string (@'...'@) pra escrever o .ps1 primeiro, depois dispare (2 etapas).

Receita completa e validada: kb/printers.md, Nível 5 — Descoberta de Impressora na Rede.

## Verificação pós-comando

Depois de disparar comando assíncrono, SEMPRE verificar:
1. Screenshot pra ver se a janela do instalador/programa abriu
2. Clipboard ou run pra checar logs se aplicável
3. Status: poll do **arquivo** (`STATUS=FINISHED`/`RUNNING`) — ver "Controle via arquivo"
4. Se usou BITS: `Get-BitsTransfer` pra ver progresso

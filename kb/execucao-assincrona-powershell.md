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
- Checar depois: `Get-Job -Name "PCR_Task" | Receive-Job`

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

## Verificação pós-comando

Depois de disparar comando assíncrono, SEMPRE verificar:
1. Screenshot pra ver se a janela do instalador/programa abriu
2. Clipboard ou run pra checar logs se aplicável
3. Se usou Start-Job: `Get-Job` pra ver status
4. Se usou BITS: `Get-BitsTransfer` pra ver progresso

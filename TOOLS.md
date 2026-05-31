# TOOLS.md — PC Resolve Mesh API

## 🖥️ PC Resolve API
- **URL Base:** `https://agent.pcresolve.com.br/api`
- **Versão:** v1.0.0 — WebSocket nativo + MeshCentralClient lib
- **Auth:** pública (HTTPS apenas, sem token por enquanto)
- **Script:** `source scripts/flavinho.sh` → `pc_list`, `pc_info`, `pc_run`, `pc_ps`, `pc_click`, `pc_type`, `pc_key`, `pc_screenshot`

## 📡 Endpoints

### Listar PCs online
```
GET /api/agents
→ [{id, name, online, os, ip, agentId}]
```
⚠️ O ID muda a cada reinstalação do agente — sempre consultar este endpoint.

### Info detalhada de um PC
```
GET /api/agents/:id
→ hardware, OS, antivírus, rede, BIOS
```

### Executar comando CMD
```
POST /api/run
Body: {deviceId, command, runAsUser?}
→ {ok, deviceId, command, output, lines, done, timedOut}
```
`runAsUser: 1` para comandos que precisam interagir com a área de trabalho.
Agora retorna `output` com o stdout do comando! 🎉

### Executar PowerShell
```
POST /api/powershell
Body: {deviceId, command}
→ {ok, deviceId, command, output, lines, done, timedOut}
```
Agora retorna `output` com o stdout do comando! 🎉

### Screenshot da tela
```
POST /api/screenshot
Body: {deviceId}
→ {ok, deviceId, screenshot} (base64 PNG)
```

### Clicar na tela
```
POST /api/click
Body: {deviceId, x, y, button: "left"|"right"}
→ {ok, deviceId, x, y, button}
```

### Digitar texto
```
POST /api/type
Body: {deviceId, text}
→ {ok, deviceId, text}
```

### Pressionar tecla
```
POST /api/key
Body: {deviceId, key: "enter"|"tab"|"esc"|"space"|"backspace"|"delete"|"up"|"down"|"left"|"right"|f1-f12|"ctrl"|"alt"|"shift"|"win"}
→ {ok, deviceId, key}
```

### Power (desligar/reiniciar/suspender)
```
POST /api/power
Body: {deviceId, action: "shutdown"|"restart"|"sleep"}
→ {ok, deviceId, action}
```

## 🩺 Playbooks Rápidos

### PC Lento
1. Screenshot → vê o que tá aberto
2. `Get-Process | Sort-Object CPU -Descending | Select-Object -First 10`
3. `Get-Service | Where-Object {$_.Status -eq "Running"} | Measure-Object`
4. Limpar temp: `cleanmgr /sagerun:1` ou `del /q/f/s %TEMP%\*`
5. Verificar disco: `Get-PhysicalDisk | Select MediaType,Size,HealthStatus`

### Impressora não funciona
1. `Get-Printer | Where-Object {$_.PrinterStatus -ne "Normal"}`
2. `Restart-Service Spooler`
3. `Get-PrintJob -PrinterName "*"` 
4. Verificar fila: screenshot do Painel de Controle > Dispositivos e Impressoras

### WiFi caiu / sem internet
1. `ipconfig /all` — vê IP, gateway, DNS
2. `ping 8.8.8.8` — testa internet
3. `ping 192.168.15.1` — testa gateway
4. `netsh wlan show interfaces` — vê sinal WiFi
5. `Get-NetAdapter | Where-Object {$_.Status -eq "Up"}`

### Certificado digital não funciona
1. `certutil -store -user My` — lista certificados instalados
2. Verifica se o token tá conectado (screenshot do Device Manager)
3. Reinstalar driver do token se necessário

### Windows Update travado
1. `Get-WindowsUpdateLog` (log)
2. `usoclient StartScan`
3. `Get-Service wuauserv | Restart-Service`
4. `DISM /Online /Cleanup-Image /RestoreHealth`
5. `sfc /scannow`

## ⚠️ Comandos PROIBIDOS (sem autorização explícita)
- `format`, `del /f/s/q C:\*`, `rmdir`
- `Remove-Item -Recurse -Force`
- `diskpart clean`
- `reg delete HKLM\...`
- Desinstalar programas sem perguntar
- Alterar senha de usuário
- Desligar sem avisar

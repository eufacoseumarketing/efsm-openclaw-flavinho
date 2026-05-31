# TOOLS.md — PC Resolve Plugin API

## 🖥️ PC Resolve Plugin (v1.2.2 — 31/05/2026)
- **URL Base:** `https://agent.pcresolve.com.br/pcresolve/api`
- **Auth:** `x-api-key: pc-resolve-secret-key-change-me`
- **Script:** `source scripts/flavinho.sh` → `pc_list`, `pc_info`, `pc_run`, `pc_ps`, `pc_click`, `pc_type`, `pc_key`, `pc_screenshot`, `pc_open`, `pc_power`

## 📡 Endpoints (no mesh-api — this is INSIDE MeshCentral)

### Listar PCs online
```
GET /agents
Header: x-api-key: pc-resolve-secret-key-change-me
→ [{name, bare, online, os, ip, agentVersion}]
```
⚠️ Use `name` ("DESKTOP-PDSLIJO") ou `bare` (nodeid sem `node//`).

### Info detalhada de um PC
```
GET /agents/:id
→ hardware, OS, antivírus, rede, BIOS
```

### Executar comando CMD
```
POST /run
Header: x-api-key + Content-Type: application/json
Body: {deviceId: "DESKTOP-PDSLIJO", command: "hostname"}
→ {ok, deviceId, output, exitCode, timedOut}
```
`deviceId` aceita nome ("DESKTOP-PDSLIJO") ou nodeid.
Para PowerShell: adicionar `"powershell": true`.

### Screenshot da tela
```
POST /screenshot
Body: {deviceId}
→ {ok, deviceId, data: "base64 JPEG", method: "powershell"}
```
Método atual: PowerShell (fallback). Relay KVM nativo em progresso.

### Clicar na tela
```
POST /click
Body: {deviceId, x, y, button: "left"|"right"}
→ {ok, deviceId, x, y, button}
```

### Digitar texto
```
POST /type
Body: {deviceId, text}
→ {ok, deviceId, text}
```

### Pressionar tecla
```
POST /key
Body: {deviceId, key: "enter"|"tab"|"esc"|"space"|"backspace"|"delete"|"up"|"down"|"left"|"right"|f1-f12|"ctrl"|"alt"|"shift"|"win"}
→ {ok, deviceId, key}
```

### Abrir URL
```
POST /open-url
Body: {deviceId, url: "https://..."}
→ {ok, deviceId, url}
```

### Power
```
POST /power
Body: {deviceId, action: "shutdown"|"restart"|"sleep"}
→ {ok, deviceId, action}
```

## 🩺 Playbooks Rápidos

### PC Lento
1. `pc_screenshot DESKTOP-PDSLIJO` → vê o que tá aberto
2. `pc_run DESKTOP-PDSLIJO "tasklist | findstr /i chrome"`  
3. PowerShell: `pc_ps DESKTOP-PDSLIJO "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10"`
4. Limpar temp: `pc_run DESKTOP-PDSLIJO "del /q/f/s %TEMP%\*"`
5. Disco: `pc_ps DESKTOP-PDSLIJO "Get-PhysicalDisk | Select MediaType,Size,HealthStatus"`

### Impressora não funciona
1. `pc_ps DESKTOP-PDSLIJO "Get-Printer | Where-Object {\$_.PrinterStatus -ne 'Normal'}"`
2. `pc_ps DESKTOP-PDSLIJO "Restart-Service Spooler"`
3. `pc_ps DESKTOP-PDSLIJO "Get-PrintJob -PrinterName '*'"`
4. Screenshot pra ver fila de impressão

### WiFi caiu / sem internet
1. `pc_run DESKTOP-PDSLIJO "ipconfig /all"`
2. `pc_run DESKTOP-PDSLIJO "ping -n 2 8.8.8.8"`
3. `pc_run DESKTOP-PDSLIJO "ping -n 2 192.168.15.1"`
4. `pc_run DESKTOP-PDSLIJO "netsh wlan show interfaces"`

### Certificado digital não funciona
1. `pc_ps DESKTOP-PDSLIJO "certutil -store -user My"` — lista certificados
2. Screenshot do Device Manager pra ver token
3. Reinstalar driver se necessário

### Windows Update travado
1. `pc_ps DESKTOP-PDSLIJO "Get-Service wuauserv | Restart-Service"`
2. `pc_ps DESKTOP-PDSLIJO "usoclient StartScan"`
3. `pc_run DESKTOP-PDSLIJO "DISM /Online /Cleanup-Image /RestoreHealth"`
4. `pc_run DESKTOP-PDSLIJO "sfc /scannow"`

## ⚠️ Comandos PROIBIDOS
- `format`, `del /f/s/q C:\*`, `rmdir`, `Remove-Item -Recurse -Force`
- `diskpart clean`, `reg delete HKLM\...`
- Desinstalar programas sem perguntar
- Alterar senha de usuário
- Desligar sem avisar

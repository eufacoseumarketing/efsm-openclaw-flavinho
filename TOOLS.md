# TOOLS.md — Ferramentas do PC Resolve

> A interface oficial das ferramentas é a **skill `pc-resolve`** (`skills/pc-resolve/SKILL.md`).
> Este arquivo cobre o que NÃO está na skill: como instalar o agente nos clientes,
> playbooks prontos e comandos proibidos. Para o uso de cada ferramenta, ver a SKILL.md.

## 🖥️ Interface (resumo)
- **API base:** `https://agent.pcresolve.com.br/api` — versão atual em `GET /api/health`.
- **Como chamar:** scripts em `skills/pc-resolve/scripts/` (cada um aceita `--name "Nome do PC"`
  e resolve o nodeId sozinho). Detalhes e exemplos no `SKILL.md`.
- **Trabalhe SÓ na máquina do chamado.** NUNCA liste ou toque em outras máquinas — pertencem a
  outros clientes (privacidade/LGPD). O nome do PC vem do contexto do atendimento.
- **Screenshot é TEXTO (`text_only`):** o plugin descreve a tela via visão server-side e devolve
  a descrição no campo `tela`. Você NUNCA recebe imagem — raciocine sobre o texto e **NÃO use a
  ferramenta `image`**. (Regra completa de visão e de clique vs teclado no `AGENTS.md`.)

## 📥 Instalação de Agente nos Clientes (LIÇÃO APRENDIDA 02/06/2026)

**⛔ NUNCA tentar instalar agente manualmente por binário cru + .msh.**
**✅ SEMPRE usar o painel web MeshCentral → Add Agent.**

### Procedimento correto (Windows e Linux):
1. Acessar <https://agent.pcresolve.com.br> — login `admin` / `Efsm1234*`
2. Clicar em **"Add Agent"** (Adicionar Agente)
3. Escolher o SO (Windows ou Linux)
4. Copiar o comando de instalação gerado (contém token do dispositivo)
5. Enviar pro cliente colar no terminal

### Por que o jeito manual falha:
- O binário cru (`meshagents?id=6`) não tem config de servidor
- O `.msh` manual fica com ~200 bytes vs 35KB do oficial
- O `.msh` oficial contém token de autenticação criptografado
- Sem token, o agente não registra no servidor

### Comando típico Linux:
```bash
(wget "https://agent.pcresolve.com.br/meshagents?script=1" -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo -E ./meshinstall.sh https://agent.pcresolve.com.br 'TOKEN_DO_DISPOSITIVO'
```

### Comando típico Windows:
```powershell
$url = "https://agent.pcresolve.com.br/meshagents?id=TOKEN&installflags=0&meshinstall=4"
Invoke-WebRequest -Uri $url -OutFile meshagent.exe
Start-Process -FilePath meshagent.exe -Wait
```

## 🩺 Playbooks Rápidos

> Receitas de comandos. Rode no PC do chamado via a skill (`run.sh`). Tire screenshot quando
> precisar conferir o resultado visual.

### PC lento
1. Screenshot pra ver o que está aberto.
2. CMD: `tasklist | findstr /i chrome`
3. PowerShell: `Get-Process | Sort-Object CPU -Descending | Select-Object -First 10`
4. Limpar temp: `del /q/f/s %TEMP%\*`
5. Saúde do disco: `Get-PhysicalDisk | Select MediaType,Size,HealthStatus`

### Impressora não funciona
1. `Get-Printer | Where-Object {$_.PrinterStatus -ne 'Normal'}`
2. `Restart-Service Spooler`
3. `Get-PrintJob -PrinterName '*'`
4. Screenshot pra ver a fila de impressão.

### WiFi caiu / sem internet
1. `ipconfig /all`
2. `ping -n 2 8.8.8.8`
3. `ping -n 2 192.168.15.1`  (ajuste o gateway conforme a rede)
4. `netsh wlan show interfaces`

### Certificado digital não funciona
1. `certutil -store -user My` — lista certificados
2. Screenshot do Gerenciador de Dispositivos pra ver o token
3. Reinstalar driver se necessário

### Windows Update travado
1. `Get-Service wuauserv | Restart-Service`
2. `usoclient StartScan`
3. `DISM /Online /Cleanup-Image /RestoreHealth`
4. `sfc /scannow`

## ⚠️ Comandos PROIBIDOS (sem confirmação explícita)
- `format`, `del /f/s/q C:\*`, `rmdir`, `Remove-Item -Recurse -Force`
- `diskpart clean`, `reg delete HKLM\...`
- Desinstalar programas
- Alterar senha de usuário
- Desligar/reiniciar sem avisar

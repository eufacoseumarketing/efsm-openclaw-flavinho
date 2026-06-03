# MEMORY.md — Flavinho

## PC Resolve — Infraestrutura (ATUALIZADO 31/05/2026)

### Servidor
- **VPS Magalu Cloud**: `201.23.83.21` (BV1-2-20, Ubuntu 24.04)
- **Domínio**: `agent.pcresolve.com.br`
- **MeshCentral**: Docker `pc-resolve-mesh` (v1.2.0, Hybrid mode)
- **Plugin PC Resolve**: v1.2.2 rodando DENTRO do MeshCentral
- **Redis**: Docker `pc-resolve-redis` (7-alpine)
- **Nginx**: proxy reverso com Let's Encrypt SSL

### API (acessível via HTTPS — NOVA!)
- URL: `https://agent.pcresolve.com.br/pcresolve/api`
- Auth: `x-api-key: pc-resolve-secret-key-change-me`
- Endpoints: run, screenshot, click, type, key, open-url, power
- ⚠️ NÃO usar `/api/*` (mesh-api antigo) — usar `/pcresolve/api/*` (plugin)

### Agentes online
- **DESKTOP-PDSLIJO** — Dell Inspiron 15-3567 (Service Tag: 56WXWQ2)
  - Windows 10 Home 22H2, i3-7020U, 8GB RAM, 1TB HDD
  - Qualcomm QCA9565 WiFi (b/g/n), Intel HD 620, Realtek RTL8136 Ethernet
  - IP: 152.249.63.216
  - ID atual: `node//7wCWLFR$BBvXybmeuAFZBaVoPWSKxFF6HP9BkSuZc4NGvIFv7GXZHGlqwiOjrUw8`
  - ID antiga: `node//4YNzDVEUcCm@DVW9xXHR0Ln6LwLKTGjfRMNM1cnpYI02VVKv9cCcjDBFJcGvzHhy` (offline)
- **MelNotebook** — Dell Inspiron 7580, Windows 11 Pro 24H2, i7-8565U, 16GB, NVMe 512GB
  - ⚠️ ID muda toda vez que reinstala

### Como usar
1. `pc_list` → vê quem tá online
2. `pc_run DESKTOP-PDSLIJO "hostname"` → executa CMD
3. `pc_ps DESKTOP-PDSLIJO "Get-Process"` → executa PowerShell
4. `pc_screenshot DESKTOP-PDSLIJO` → screenshot
5. `pc_open DESKTOP-PDSLIJO "https://..."` → abre URL

### Scripts
- `source scripts/flavinho.sh` → carrega todas as funções
- Documentação completa em `TOOLS.md`

### Repositório GitHub
- URL: `https://github.com/eufacoseumarketing/efsm-openclaw-flavinho`
- Remote SSH: `git@github.com:eufacoseumarketing/efsm-openclaw-flavinho.git`
- Chave SSH: `~/.ssh/flavinho_github` (ED25519, deploy key com write access)

### Cron Job — Sync Noturno
- **Job ID:** `51a407cb-27e7-4a45-9be6-a06ba248ab13`
- **Schedule:** Todo dia às 02:30 (America/Sao_Paulo)
- **Tipo:** Isolado (agentTurn)
- **Delivery:** `announce` → Discord DM do Zanatto
- **Ação:** `git add -A` → commit + push (só se houver mudanças)
- **3 execuções até agora, 0 falhas**

### Regra: Knowledge Base (KB)
- ⭐ TODO conhecimento técnico aprendido deve ser salvo no repo
- Formato: arquivos `.md` na pasta `kb/`
- Sempre commitar e push depois de adicionar/atualizar conhecimento

### Regras de Atendimento (APRENDIDAS 31/05/2026)
- ⚡ **BIOS, firmware, formatação, factory reset → SEMPRE avisar antes e pedir confirmação explícita**
- 💾 **Backup**: Copiar → Compactar → **INSTRUIR cliente a salvar FORA da máquina** (nuvem, pendrive, HD externo)
- 🚫 **NUNCA salvar backup na VPS/ambiente PC Resolve** (não temos infra pra guardar dados de cliente)
- 📜 **Sempre maximizar e scrollar antes de agir** — ver TODOS os itens antes de clicar em Instalar
- 🔍 **Sempre verificar se o PC tá online antes de mandar comando**
- 🖥️ `run` API roda como SYSTEM → não lança GUI no usuário; usar Start Menu + type + Enter
- ⏱️ 10 minutos sem resolver = escalar

### Metodologia de Atualização de Drivers (Dell)
- **Ferramentas automáticas primeiro**: Dell SupportAssist, Intel DSA, Windows Update
- **NUNCA caçar driver por driver no site da Dell** — o site bloqueia download automatizado (403 no VPS)
- **Ordem**: SupportAssist → Intel DSA → Windows Update → site do fabricante (último recurso)
- **BIOS update** = alto risco → backup antes, avisar cliente, não desligar durante flash
- URL SupportAssist: `https://downloads.dell.com/serviceability/catalog/SupportAssistInstaller.exe`
- Instalação silenciosa: `SupportAssistInstaller.exe /VERYSILENT`
- SupportAssist caminho: `C:\Program Files\Dell\SupportAssistAgent\bin\SupportAssist.exe`
- Serviços SupportAssist: SupportAssistAgent.exe, SupportAssistUI.exe, SupportAssistHardwareDiag

### Regra de Suporte (APRENDIDA 01/06/2026)
- 🔌 **Sempre desabilitar descanso de tela e suspensão** ao iniciar suporte:
  ```cmd
  powercfg /change monitor-timeout-ac 0
  powercfg /change standby-timeout-ac 0
  powercfg /change hibernate-timeout-ac 0
  ```
  PC dormindo no meio do suporte = desastre.
- 📡 **WiFi offline sem toggle físico**: verificar BIOS, Fn+Fx, dispositivos ocultos (Código 45)
- 🔧 **Lenovo Flex 2 (20308)**: Fn+F7 é WiFi toggle, BIOS InsydeH2O não tem opção WLAN
- 💻 **Download grande via BITS**: `bitsadmin /create /addfile /resume` — não trava API
- 🐧 **Linux dualboot quebrado**: `fsck -y /dev/sda7` no initramfs, ou reinstalar limpo na partição
- ⚠️ `run` API executa como SYSTEM → não lança GUI no usuário; só CLI e serviços

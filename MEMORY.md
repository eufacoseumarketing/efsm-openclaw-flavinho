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
- ⚠️ O path `/pcresolve/api/*` ficou 404 em 15/06/2026 — usar `/api/*` diretamente como fallback
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

### Lições Aprendidas — 15/06/2026 (Atendimento EFSM 01)

#### Cliques por coordenada
- 🎯 **As coordenadas de clique são ESTIMADAS por mim** (o Gemini só descreve a tela em texto, não devolve coordenadas numéricas de elementos)
- 📏 **Sempre pedir pro Gemini descrever a posição exata** dos elementos interativos antes de clicar
- ⌨️ **Preferir navegação por Tab/Enter** quando possível — mais confiável que clique por coordenada
- 🔄 **Se errar o clique, tirar screenshot IMEDIATAMENTE** pra ver onde foi parar — não continuar clicando às cegas

#### Agente sobrecarregado (agent-busy-max-retries)
- 🚫 **NUNCA fazer web request pra IPs externos direto do agente** do cliente (ex: `Invoke-WebRequest` pra interface web de impressora). Se o dispositivo não responder, trava o agente inteiro
- 🐌 **Espaçar comandos**: máximo ~5 comandos por minuto. Disparar 15+ em 20 min enche a fila do MeshCentral
- 📡 **Varredura de rede**: usar `-TimeoutSec` curto (2-3s) e limitar IPs — 19 IPs × 3 portas × 500ms = ~30s de scan, aceitável. Mas web request pra porta 631 pode travar
- 🎯 **Descobrir IPs reais antes do scan**: usar `Get-NetNeighbor -AddressFamily IPv4` (tabela ARP) pra listar só IPs que realmente existem na rede, depois scanear apenas esses. Muito mais eficiente que varrer 254 IPs às cegas. Exemplo: 19 IPs reais encontrados na EFSM 01, scanner neles, achou impressora em 30s.
- 🔧 **Se o agente travar**: esperar 2-3 minutos que a fila limpa sozinha. Se não resolver, orientar cliente a reiniciar o agente
- ⚠️ **Screenshot também falha** quando o agente está sobrecarregado — não é bug do plugin

#### Interface do usuário (GUI)
- 🖥️ `run` API executa como SYSTEM → NÃO lança GUI visível pro usuário. Só CLI e serviços.
- ✅ Pra abrir janelas visíveis: usar `open-url` com URIs (`ms-settings:printers`) ou simular teclas (Win, type, Enter) via `key` + `type`
- ❌ `open-url` com `shell:::` CLSID não funciona

#### Workflow ideal
1. Screenshot → analisar descrição → identificar elementos
2. Se precisar clicar: pedir coordenadas na descrição, OU usar Tab
3. Máximo 1 screenshot a cada 10 segundos
4. Se agente começar a recusar comandos: PAUSAR 2 minutos, depois tentar comando simples (`whoami`) pra testar
5. Não disparar comandos em paralelo — fila do agente é sequencial

### Regra: Knowledge Base (KB)
- ⭐ TODO conhecimento técnico aprendido deve ser salvo no repo
- Formato: arquivos `.md` na pasta `kb/`
- Sempre commitar e push depois de adicionar/atualizar conhecimento

### Regras de Atendimento (APRENDIDAS 31/05/2026)
- ⌨️ **CLI primeiro, tela depois**: esgotar linha de comando antes de tirar screenshot. Screenshot é recurso caro e lento — só usar quando comando não resolver (ex: confirmar visualmente, interagir com GUI, ver estado de janela)
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

### Regras de Ouro — Atualizadas 16/06/2026 (pós-IRPF + pós-falha impressora)

#### 🎯 Cliques: NUNCA confiar em coordenada do Gemini
- Gemini oscila ~50px entre screenshots no mesmo elemento
- Clique por coordenada = ~70% de chance de erro em botões
- SÓ clicar em alvo > 150px (ícones desktop, barra tarefas, botão gigante)
- Errou 1 clique → muda IMEDIATAMENTE pra teclado, NÃO insista

#### ⌨️ Teclado: método PADRÃO pra app windows
- SEMPRE: SetForegroundWindow → Tab×N → Enter
- KVM keyboard funciona em janelas de app (bypassa UIPI)
- Sem foco = Tab+Enter vai pra Widgets/desktop
- Script de foco: `kb/irpf-instalacao.md` passo 5

#### 📋 KB: copiar e colar, NÃO "fazer parecido"
- Se KB tem script pronto → EXECUTE ELE, não adapte
- Here-string @'...'@ da KB funciona, inline seu vai quebrar
- Scan de rede: SEMPRE assíncrono com controle por arquivo, NUNCA síncrono
- Ignorar KB = atendimento falha (vide impressora 16/06)

#### 🛑 Anti-ansiedade: máximo 3 comandos sem screenshot
- 3+ comandos sem confirmar estado visual → PARE, screenshot AGORA
- Agente "busy" → esperar 2 min, testar com `whoami`
- Não disparar comandos em paralelo quando o anterior não respondeu

#### 🪟 Janelas invisíveis: Widgets, UAC, foco
- Widgets Win11: só fecha se outra janela for TOPMOST (SetWindowPos -1)
- UAC secure desktop: IMPOSSÍVEL automatizar → usar Scheduled Task RunLevel Highest
- Janela atrás de Widgets: SetForegroundWindow + SetWindowPos(HWND_TOPMOST)
- 🎯 Se já funciona, PARE: driver completo é nice-to-have, não bloqueador (16/06)

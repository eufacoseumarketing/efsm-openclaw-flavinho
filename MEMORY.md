# MEMORY.md — Flavinho

## PC Resolve — Infraestrutura

### Servidor
- **VPS Magalu Cloud**: `201.23.83.21` (BV1-2-20, Ubuntu 24.04)
- **Domínio**: `agent.pcresolve.com.br`
- **MeshCentral**: Docker `pc-resolve-mesh` (v1.2.0, Hybrid mode)
- **mesh-api**: Docker `pc-resolve-api` (v1.0.0, Node.js 22, porta 3001 — WebSocket nativo + MeshCentralClient lib)
- **Redis**: Docker `pc-resolve-redis` (7-alpine)
- **Nginx**: proxy reverso com Let's Encrypt SSL

### API (acessível via HTTPS)
- URL: `https://agent.pcresolve.com.br/api`
- Endpoints: agents, run, powershell, screenshot, click, type, key, power
- Detalhes completos em `TOOLS.md`

### Agentes instalados (31/05/2026 — o ID muda a cada reinstalação!)
- **MelNotebook** — Dell Inspiron 7580, Windows 11 Pro 24H2, i7-8565U, 16GB, NVMe 512GB
  - IP: 152.249.63.216
  - ⚠️ ID muda toda vez que reinstala — sempre usar `GET /api/agents` pra pegar o ID atual
  - Último ID conhecido: `node//WUXutcKWc3vQIN0esRvP6D6EFC0@Fm2OyEGNh20naqN134@nhTLLWQL99Ry@P2$Z`

### mesh-api versão
- v1.0.0 — MeshCentralClient nativo (WebSocket puro, sem PowerShell hack)

### Scripts
- `source scripts/flavinho.sh` → carrega todas as funções

### Repositório GitHub
- URL: `https://github.com/eufacoseumarketing/efsm-openclaw-flavinho`
- Remote SSH: `git@github.com:eufacoseumarketing/efsm-openclaw-flavinho.git`
- Chave SSH: `~/.ssh/flavinho_github` (ED25519, deploy key com write access)
- Git config local: `core.sshCommand` configurado com a chave

### Cron Job — Sync Noturno
- **Job ID:** `51a407cb-27e7-4a45-9be6-a06ba248ab13`
- **Schedule:** Todo dia às 02:30 (America/Sao_Paulo)
- **Tipo:** Isolado (agentTurn), sem delivery (silencioso)
- **Ação:** `git add -A` → `git commit` + `git push` (só se houver mudanças)
- **Arquivo:** `~/.openclaw/cron/jobs.json`

### Regra: Knowledge Base (KB)
- ⭐ **TODO conhecimento técnico aprendido deve ser salvo no repo** — seja vindo do Zanatto/Ananias, seja de sessões de suporte com clientes
- Formato: arquivos `.md` na pasta `kb/`
- Sempre commitar e push depois de adicionar/atualizar conhecimento
- Exemplos: soluções de problemas, comandos úteis, comportamentos de Windows, dicas de troubleshooting

### Regras aprendidas
- Sempre verificar se o PC tá online antes de mandar comando (`pc_list` primeiro)
- ⚠️ **ID do agente muda a cada reinstalação** — sempre usar `GET /api/agents` pra pegar o ID atual
- `runAsUser: 1` necessário pra comandos que interagem com a área de trabalho
- Comandos PowerShell precisam de escaping de aspas
- **v1.0.0**: Comandos `run`/`powershell` agora retornam `output`, `lines`, `done`, `timedOut`
- Campo da lista de agents: `agent` → `agentId`
- **Paint no Windows 11 24H2**: é AppX (UWP), não tem `mspaint.exe` no PATH — usar `start ms-paint:`

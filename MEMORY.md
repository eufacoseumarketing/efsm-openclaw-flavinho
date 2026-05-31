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
- **DESKTOP-PDSLIJO** — Windows 10 Home, Dell
  - IP: 152.249.63.216
  - ⚠️ ID: `4YNzDVEUcCm@DVW9xXHR0Ln6LwLKTGjfRMNM1cnpYI02VVKv9cCcjDBFJcGvzHhy`
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

### Regra: Knowledge Base (KB)
- ⭐ TODO conhecimento técnico aprendido deve ser salvo no repo
- Formato: arquivos `.md` na pasta `kb/`
- Sempre commitar e push depois de adicionar/atualizar conhecimento

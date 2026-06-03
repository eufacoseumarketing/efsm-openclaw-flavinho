# PC Resolve API — Guia do Flavinho

## 🔌 Conexão

Todas as APIs estão em:
```
https://agent.pcresolve.com.br/pcresolve/api
```

Autenticação: header `x-api-key: pc-resolve-secret-key-change-me`

**⚠️ REGRA DE OURO: Sempre verifique se o agente tá online ANTES de mandar comandos gráficos!**
```
pc_list → confirma online=True → pc_screenshot
```

## 📋 Comandos Disponíveis

### 1. Listar agentes
```bash
pc_list
```
Resposta: lista de agentes com `name`, `online`, `os`

### 2. Ver agente específico
```bash
pc_info zanatto-Lenovo-Ideapad-Flex14
```

### 3. Executar comando shell
```bash
pc_run zanatto-Lenovo-Ideapad-Flex14 "whoami"
pc_run zanatto-Lenovo-Ideapad-Flex14 "ls /home/zanatto"
```
- ✅ Funciona em Linux (Bash) e Windows (CMD)
- Tempo limite padrão: 30 segundos

### 4. Executar PowerShell (Windows)
```bash
pc_ps DESKTOP-PDSLIJO "Get-Process | Select -First 5"
```
- Só funciona no Windows (PowerShell)

### 5. Screenshot (Tela cheia)
```bash
pc_screenshot zanatto-Lenovo-Ideapad-Flex14
```
- Linux: gnome-screenshot (~800ms, 200-300KB PNG em base64)
- Windows: PowerShell screenshot (~30-40 segundos!)
- Retorna `data` (base64 da imagem PNG), `method` (gnome-screenshot/relay/powershell), `timeMs`

### 6. Click do Mouse
```bash
# Clique esquerdo
pc_click zanatto-Lenovo-Ideapad-Flex14 400 300

# Clique direito
pc_click zanatto-Lenovo-Ideapad-Flex14 400 300 right

# Duplo clique
pc_click zanatto-Lenovo-Ideapad-Flex14 400 300 left dblclick

# Scroll (negativo = pra baixo, positivo = pra cima)
pc_click zanatto-Lenovo-Ideapad-Flex14 400 300 left scroll -120
```

### 7. Digitar Texto
```bash
pc_type zanatto-Lenovo-Ideapad-Flex14 "Olá mundo!"
```

### 8. Pressionar Tecla
```bash
pc_key zanatto-Lenovo-Ideapad-Flex14 enter
pc_key zanatto-Lenovo-Ideapad-Flex14 escape
pc_key zanatto-Lenovo-Ideapad-Flex14 tab
pc_key zanatto-Lenovo-Ideapad-Flex14 backspace
```

### 9. Abrir URL
```bash
pc_open zanatto-Lenovo-Ideapad-Flex14 "https://google.com"
```

### 10. Power
```bash
pc_power zanatto-Lenovo-Ideapad-Flex14 restart
pc_power zanatto-Lenovo-Ideapad-Flex14 shutdown
```

## 🐛 Troubleshooting Rápido

| Sintoma | Causa | Solução |
|---------|-------|---------|
| `ok:false` com timeout | Agente offline/desconectou | `pc_list` → esperar online → tentar de novo |
| `error: not-connected` | Plugin não conectou no MeshCentral | Esperar 5 segundos, tentar de novo |
| `error: screenshot-failed` no Linux | Tela bloqueada ou Wayland sem sessão | Destravar tela, esperar sessão gráfica |
| Agente offline após deploy | Container reiniciou, agente reconecta em ~20s | `pc_list` até aparecer online=True |
| Comando gráfico falha mas `run` funciona | Agente no busyCache (60s) | Esperar 60 segundos ou usar `pc_list` pra confirmar |

## 🎯 Sequência Padrão de Uso

```bash
# 1. Carregar as funções (uma vez por sessão)
source scripts/flavinho.sh

# 2. Verificar agentes
pc_list

# 3. Se online, usar!
pc_screenshot zanatto-Lenovo-Ideapad-Flex14
pc_click zanatto-Lenovo-Ideapad-Flex14 400 300
pc_type zanatto-Lenovo-Ideapad-Flex14 "teste"
pc_key zanatto-Lenovo-Ideapad-Flex14 enter

# 4. Se falhar, verificar status
pc_list  # Confirma online=True?
```

## 🏷️ Device IDs

| Nome | SO | Status |
|------|-----|--------|
| `zanatto-Lenovo-Ideapad-Flex14` | Ubuntu 22.04 | 🟢 Linux — suporte completo |
| `DESKTOP-PDSLIJO` | Win10 Home | 🔴 Offline |
| `DESKTOP-0IQC1UM` | Win10 Home | 🔴 Offline |
| `MelNotebook` | Win11 Pro | 🔴 Offline |

## 📝 Notas

- **NÃO use `sudo systemctl restart meshagent`** a menos que seja estritamente necessário — o agente leva ~20s pra reconectar
- **O plugin detecta automaticamente** se é Linux ou Windows
- **Screenshot no Linux é 30-50x mais rápido** que no Windows
- As funções shell (`pc_*`) já estão em `scripts/flavinho.sh`

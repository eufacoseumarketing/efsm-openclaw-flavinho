# Relatório de Testes — API PC Resolve na EFSM 01

**Data:** 11/06/2026
**Máquina:** EFSM 01 (Windows 11 Pro 25H2, 16GB RAM, x64)
**API:** v2.22.0

---

## Resumo

| Endpoint | Status | Detalhe |
|---|---|---|
| GET /api/health | OK | v2.22.0, agentsCount=6, aiChatEnabled=true |
| GET /api/agents | OK | 6 agentes, 2 online |
| GET /api/agents/:id | OK | Busca por nome funciona |
| POST /api/run (CMD) | OK | Executa como SYSTEM |
| POST /api/run (PowerShell) | OK | PowerShell funcional |
| POST /api/screenshot | OK* | Relay, ~46KB, trava agente |
| POST /api/click | FALHA | unauthorized |
| POST /api/type | FALHA | unauthorized |
| POST /api/key | FALHA | unauthorized |
| POST /api/open-url | FALHA | unauthorized |
| POST /api/power | FALHA | unauthorized |

**Resultado: 6 OK, 5 FALHAS**

---

## Testes Detalhados

### 1. GET /api/health
- OK
- Versão 2.22.0
- MeshCentral conectado
- aiChatEnabled: true

### 2. GET /api/agents
- OK (público, sem auth)
- Retorna 6 agentes no total
- 2 online: EFSM 01 e EFSM 02

### 3. GET /api/agents/:id
- OK com nome "EFSM 01" (busca por nome funciona)
- Retorna: id, nome, descrição, OS, IP, online status, meshId

### 4. POST /api/run (CMD)
- OK
- Executa como `nt\sistema` (SYSTEM)
- Comandos simples: ~1s de resposta
- Pipe e findstr funcionam
- ⚠️ SYSTEM = não tem acesso à sessão gráfica do usuário

### 5. POST /api/run (PowerShell)
- OK
- Get-ComputerInfo, Get-Process, ConvertTo-Json funcionam
- Útil pra diagnóstico: CPU, RAM, processos, serviços

### 6. POST /api/screenshot
- OK (método relay)
- ~752ms de captura
- ~46KB (61KB base64) — qualidade reduzida a 50%
- ⚠️ CRÍTICO: Após screenshot, agente fica em "agent-busy-max-retries" por 8-20+ segundos
- NENHUM comando funciona durante esse período
- `start notepad` e `start https://...` falharam totalmente após screenshot

### 7. POST /api/click
- FALHA: `{"error":"unauthorized"}`
- Mesmo com x-api-key que funciona em outros endpoints
- ⚠️ Sem click, não consigo interagir com a GUI do usuário

### 8. POST /api/type
- FALHA: `{"error":"unauthorized"}`
- Mesmo problema do click

### 9. POST /api/key
- FALHA: `{"error":"unauthorized"}`
- Não consigo pressionar Enter, Escape, Tab, Win, etc

### 10. POST /api/open-url
- FALHA: `{"error":"unauthorized"}`
- Não consigo abrir navegador no PC do cliente

### 11. POST /api/power
- FALHA: `{"error":"unauthorized"}`
- Não consigo reiniciar/desligar remotamente

---

## Dificuldades Encontradas

### 🔴 CRÍTICA — 5 endpoints com unauthorized
click, type, key, open-url, power retornam "unauthorized" mesmo com a mesma API key que funciona em run, screenshot e info. Isso me deixa SEM capacidade de interagir com a área de trabalho do usuário. Não posso:
- Clicar em botões
- Digitar texto
- Pressionar teclas (Enter, Escape, Tab)
- Abrir URLs
- Reiniciar/desligar

### 🔴 CRÍTICA — Screenshot via relay trava o agente
Após tirar screenshot, o agente fica em "agent-busy-max-retries" por 8-20+ segundos. Qualquer comando seguinte (run, click, type) falha. No fluxo de atendimento real (screenshot → analisar → agir), isso significa que depois de VER a tela eu NÃO CONSIGO AGIR — fico esperando o agente liberar.

### 🟡 MÉDIA — Screenshot com qualidade fixa em 50%
46KB pra uma screenshot de 3840x2160 é muito pouco. Textos pequenos, ícones detalhados, menus de contexto — tudo fica ilegível com essa compressão. Preciso de qualidade configurável (ex: parâmetro `quality: 80`).

### 🟡 MÉDIA — Execução como SYSTEM
Comandos `run` rodam como SYSTEM, não na sessão do usuário. Isso significa:
- `start notepad` = não aparece pro usuário
- `start https://...` = não abre navegador visível
- Programas com interface gráfica = invisíveis

Preciso de uma opção `runAsUser: true` para comandos que precisam aparecer na tela do cliente.

### 🟡 MÉDIA — Timeout em comandos concorrentes
Se mando 2 comandos run ao mesmo tempo, o segundo falha com "agent-busy-max-retries". O agente não suporta concorrência — preciso serializar tudo.

---

## Sugestões do que preciso pra trabalhar bem

### 1. Corrigir unauthorized nos 5 endpoints
click, type, key, open-url, power — verificar se é problema de auth no plugin mesh-api. Esses endpoints são ESSENCIAIS pra suporte remoto interativo.

### 2. Screenshot com qualidade configurável
Adicionar parâmetro `quality` (0-100) no POST /api/screenshot.
Ex: `{"deviceId":"EFSM 01","quality":80}`
Default poderia ser 70-80, não 50.

### 3. Screenshot não travar o agente
O método relay precisa liberar a conexão imediatamente após capturar. Ou usar um método alternativo (tirar screenshot via PowerShell e retornar o resultado no mesmo canal do run, sem conexão relay separada).

### 4. runAsUser para comandos gráficos
Adicionar parâmetro `runAsUser: true` no POST /api/run.
Ex: `{"deviceId":"EFSM 01","command":"start https://google.com","runAsUser":true}`
Isso permitiria abrir navegador, notepad, e outros programas visíveis ao cliente.

### 5. Suporte a concorrência ou fila
Agente deveria aceitar múltiplos comandos em fila, ou pelo menos rejeitar rápido (não timeout de 10-20s) quando ocupado.

### 6. Popup de navegador padrão
Se não der pra ter runAsUser, então o click PRECISA funcionar — é a única forma de lidar com o popup "Escolha um navegador" que aparece quando abro URL sem navegador padrão definido.

---

## Conclusão

Dos 11 endpoints da API:
- 6 funcionam (health, agents, info, run CMD, run PS, screenshot)
- 5 estão quebrados (click, type, key, open-url, power)

Com o que funciona HOJE, eu consigo:
- Ver quem tá online
- Executar comandos de diagnóstico (CMD e PowerShell)
- Tirar screenshot da tela

Eu NÃO consigo:
- Interagir com a área de trabalho do usuário (clicar, digitar, teclar)
- Abrir navegador ou programas visíveis
- Fechar janelas, lidar com popups
- Reiniciar ou desligar o PC

Isso significa que, no estado atual, sou um **observador**, não um **operador**. Posso diagnosticar, mas não posso resolver nada que exija interação com a GUI do Windows.

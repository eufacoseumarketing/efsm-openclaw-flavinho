# PC Resolve — Ferramentas de Suporte Remoto

Esta skill dá ao Flavinho acesso às ferramentas do PC Resolve via API REST no MeshCentral.

## API Base
```
https://agent.pcresolve.com.br/api
```

## Scripts disponíveis

Todos os scripts aceitam `--name "Nome do PC"` como identificador (resolve automaticamente para o nodeId).

### `scripts/agents.sh`
Lista todos os agentes com status online/offline.
```bash
bash skills/pc-resolve/scripts/agents.sh
# Retorna: nome, OS, status, IP
```

### `scripts/screenshot.sh --name "NOME"`
Tira screenshot e retorna a tela **descrita em TEXTO** (modo `text_only`): o plugin analisa a
imagem server-side e devolve a descrição no campo `tela`, com os elementos clicáveis e suas
coordenadas (x,y).
```bash
bash skills/pc-resolve/scripts/screenshot.sh --name "EFSM 01"
# Retorna: "🖥️ <descrição da tela + elementos clicáveis com x,y>"
```
⚠️ Você NÃO recebe imagem — raciocine sobre o TEXTO retornado. **NÃO use a ferramenta `image`**
(o modelo principal é text-only). NUNCA finja que viu a tela sem ter rodado o screenshot.

### `scripts/run.sh --name "NOME" --cmd "COMANDO"`
Executa um comando PowerShell no computador remoto.
```bash
bash skills/pc-resolve/scripts/run.sh --name "EFSM 01" --cmd "Get-Process | Select-Object -First 5"
# Retorna: stdout do comando
```
⛔ REGRA CRÍTICA: Downloads de instaladores SEMPRE use PowerShell (Invoke-WebRequest com -OutFile).
NUNCA abra navegador para baixar arquivos.

### `scripts/click.sh --name "NOME" --x NUM --y NUM`
Clica em uma posição da tela.
```bash
bash skills/pc-resolve/scripts/click.sh --name "EFSM 01" --x 500 --y 300
```

### `scripts/type.sh --name "NOME" --text "TEXTO"`
Digita texto no campo focado.
```bash
bash skills/pc-resolve/scripts/type.sh --name "EFSM 01" --text "senha123"
```

### `scripts/key.sh --name "NOME" --key "TECLA"`
Pressiona uma tecla especial.
```bash
bash skills/pc-resolve/scripts/key.sh --name "EFSM 01" --key "enter"
# Teclas: enter, tab, escape, backspace, space, up, down, left, right
```

### `scripts/open-url.sh --name "NOME" --url "URL"`
Abre uma URL no navegador padrão do computador remoto.
```bash
bash skills/pc-resolve/scripts/open-url.sh --name "EFSM 01" --url "https://google.com"
```
⚠️ Use SOMENTE quando o usuário pedir EXPLICITAMENTE para ver algo no navegador.
NUNCA use para: pesquisar URLs de download, testar sites, buscar informações.
Para isso: use web_search/curl do OpenClaw e baixe com PowerShell Invoke-WebRequest.
Depois de abrir URL, espere 3-5s e tire screenshot para ver o resultado.

### `scripts/sleep.sh --seconds NUM`
Pausa por N segundos (útil entre ações).
```bash
bash skills/pc-resolve/scripts/sleep.sh --seconds 5
```

### `scripts/clipboard.sh --name "NOME" --action get|set [--text "TEXTO"]`
Lê ou escreve na área de transferência do computador remoto.
```bash
# Ler clipboard (retorna texto)
bash skills/pc-resolve/scripts/clipboard.sh --name "EFSM 01" --action get

# Escrever no clipboard
bash skills/pc-resolve/scripts/clipboard.sh --name "EFSM 01" --action set --text "texto"
```
⚠️ MELHOR jeito de ler conteúdo de página: `key.sh Ctrl+A` → `key.sh Ctrl+C` → `clipboard.sh --action get`.
Muito mais rápido e barato que screenshot + análise visual. Use sempre que precisar de TEXTO.

## Regras de ouro das ferramentas

1. ⛔ **1 ferramenta por resposta**: execute UMA tool por vez. SEMPRE escreva 1 frase antes.
2. ⛔ **Não repita ações**: não execute a mesma ação 2x seguida.
3. ⛔ **Falha 2x = pare**: se o mesmo comando falhar 2 vezes, avise e pergunte se continua.
4. ✅ **Screenshot é seu olho**: depois de cada ação visível (click, type, open-url), tire screenshot.
5. ✅ **Antes de agir, veja**: primeiro screenshot, depois planeje os clicks.
6. ⛔ **NUNCA comandos destrutivos** sem confirmação explícita do usuário.
7. ✅ **finish() ao concluir**: encerre com resumo do que foi feito quando resolver o problema.
8. ⛔ **Invoke-WebRequest SEM -OutFile = proibido**: sempre salve downloads em disco.
9. ⛔ **Download > 50MB = BITS**: `Start-BitsTransfer` é obrigatório para arquivos grandes. Invoke-WebRequest trava.
10. 📂 **Verifique Downloads antes de baixar**: `Test-Path` no arquivo — pode já estar baixado.
11. ⏸️ **Desligue sleep no início**: `powercfg -change -standby-timeout-ac 0` — restaure ao finalizar.

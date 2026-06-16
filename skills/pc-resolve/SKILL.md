# PC Resolve Skill

Ferramentas para controle remoto de máquinas Windows/Linux/macOS via MeshCentral.

## Screenshot (NOVO — v5 base64)

```bash
bash skills/pc-resolve/scripts/screenshot.sh "<DEVICE_NAME>" [scale] [quality] [model]
```

**Parâmetros:**
- `DEVICE_NAME`: nome exato da máquina (ex: "EFSM 01")
- `scale`: 10-100 (default 75) — % da resolução
- `quality`: 10-100 (default 60) — qualidade JPEG
- `model`: gemini-2.5-flash (default, rápido) ou gemini-2.5-pro (mais detalhado)

**Retorno:** descrição textual + coordenadas exatas dos elementos clicáveis.
O screenshot captura via relay (rápido) ou PowerShell fallback (~18s).
A chave Gemini está em `../../.env` (GEMINI_API_KEY).

⚠️ **NUNCA estime posições no olhômetro.** Use SEMPRE as coordenadas da lista `📍 COORDENADAS EXATAS`.

## Click, Teclas, Digitação

```bash
bash skills/pc-resolve/scripts/click.sh "<DEVICE_NAME>" <x> <y> [button]
bash skills/pc-resolve/scripts/key.sh "<DEVICE_NAME>" "<tecla>"
bash skills/pc-resolve/scripts/type.sh "<DEVICE_NAME>" "<texto>"
```

## Comandos

```bash
bash skills/pc-resolve/scripts/run.sh "<DEVICE_NAME>" "<comando>"
bash skills/pc-resolve/scripts/open-url.sh "<DEVICE_NAME>" "<url>"
```

## Utilitários

```bash
bash skills/pc-resolve/scripts/sleep.sh <segundos>
bash skills/pc-resolve/scripts/agents.sh  # lista agentes online
bash skills/pc-resolve/scripts/clipboard.sh "<DEVICE_NAME>" [get|set "<texto>"]
bash skills/pc-resolve/scripts/window.sh "<DEVICE_NAME>" [maximize|minimize]
```

## Estratégia de navegação

1. ⛔ **CLI primeiro, GUI só se falhar** — use run.sh para comandos
2. ⛔ **>10s → background via arquivo** (Start-Process + poll)
3. ✅ **Teclado para janelas** (Alt+F4, Win, Tab)
4. ✅ **Coordenadas para ícones/botões** (use SEMPRE as da lista)
5. ✅ **Consulte kb/ antes de agir** — procedimentos prontos

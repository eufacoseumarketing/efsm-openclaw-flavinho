# RELATORIOS - Pipeline Completo

> NUNCA gere HTML diretamente no chat. O DeepSeek trunca output grande.
> SEMPRE use o pipeline de scripts -> arquivo -> anexo.

## Pipeline Padrao (3 etapas)

### Etapa 1 - Coletar dados da Zernio
```bash
bash scripts/zernio-api.sh GET "/analytics" "profileId=<ID>"
bash scripts/zernio-api.sh GET "/analytics/daily-metrics" "profileId=<ID>"
```
Paginar analytics ate totalPosts (max 10 paginas). Salvar dados brutos em /tmp/openclaw/.

### Etapa 2 - Processar e montar JSON
```bash
python3 scripts/_build_relatorio_efsm.py > /tmp/openclaw/dados.json
```

Estrutura do JSON:
```json
{
  "titulo": "Cliente - Relatorio de Performance",
  "periodo": "Jan-Jul 2026",
  "metricas": [
    {"label": "Impressoes", "valor": 43768, "variacao": 12.5}
  ],
  "tabelas": [
    {
      "titulo": "Performance por Plataforma",
      "colunas": ["Plataforma", "Seguidores", "Engajamento"],
      "rows": [["Instagram", 28500, "5.2%"]]
    }
  ],
  "secoes": [
    {
      "titulo": "Visao Geral",
      "paragrafos": ["Analise do periodo..."],
      "metricas": [...],
      "tabela": {...}
    }
  ]
}
```

### Etapa 3 - Gerar HTML e anexar
```bash
python3 scripts/_build_relatorio_efsm.py | python3 scripts/gerar-relatorio-premium.py > /tmp/openclaw/relatorio.html
```

Anexar: `message(action="send", media="/tmp/openclaw/relatorio.html")`

## Scripts Disponiveis

| Script | Funcao |
|--------|--------|
| `zernio-api.sh` | API da Zernio (analytics, daily metrics, posts) |
| `_build_relatorio_efsm.py` | Builder EFSM - monta JSON a partir dos dados brutos |
| `gerar-relatorio-premium.py` | Gerador premium (gradientes, glows, KPI grid, badges) |
| `gerar-relatorio.py` | Gerador basico (fallback) |
| `efsm-social-api.sh` | API EFSM Social (Supabase) |

## Regras Importantes

- Agregar por plataforma usando `platforms[]` de cada post, NAO o campo `platform` raiz
- Agregar por mes usando `publishedAt`
- Top 5 posts por plataforma: impressions (IG/LI), views (TikTok)
- Calcular: impressions, reach, likes, comments, shares, saves, clicks, views
- Para cliente novo: copiar `_build_relatorio_efsm.py` -> adaptar -> commitar

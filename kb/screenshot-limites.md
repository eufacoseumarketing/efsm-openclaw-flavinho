# Screenshot API — Limites e Recomendações

> Testado em 16/06/2026 na EFSM 01 (Windows 11, 1920x1080)

## Métodos

### Relay (rápido, ~350ms)
- Captura screenshot via agente MeshCentral (relay TCP)
- Limite: payload base64 até ~80KB
- Falha acima disso → fallback automático pra powershell

### Powershell (lento, ~18s)
- Captura via script PowerShell + conversão base64
- Aguenta qualquer escala/qualidade (testado até 1MB de base64)
- Sempre funciona como fallback

## Limites testados

| Parâmetro | Relay          | Powershell     |
|-----------|---------------|----------------|
| Scale     | até 40        | até 100        |
| Quality   | até 60 (scale≤40); até 100 (scale≤25) | até 100 |
| Base64    | até ~80KB     | até ~1MB+      |

## Recomendações por caso de uso

### Uso diário (DEFAULT)
- scale=35, quality=30
- Relay rápido, 672x384, ~40KB
- Gemini detecta 15+ elementos (área de trabalho + barra de tarefas)
- Ideal pra: visão geral, confirmar ações, diagnosticar problemas óbvios

### Precisão (quando precisar ler texto ou clicar com exatidão)
- scale=75, quality=60
- Powershell, 960x540, ~92KB
- Usar só quando relay não bastar

### Qualidade máxima
- scale=100, quality=100
- Powershell, 1280x720, ~1MB
- Só quando absolutamente necessário (texto muito pequeno)

## Observações
- Scale > 55 NÃO trava (informação anterior estava incorreta)
- Relay cai pra powershell automaticamente quando falha
- Gemini processa até 1MB de base64 sem problema (gemini-2.5-flash)
- JSON truncado ocasional com imagens grandes — resolvido com maxOutputTokens=8192

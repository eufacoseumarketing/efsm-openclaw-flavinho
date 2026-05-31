# 🍎 Suporte Apple — Guia para o Cliente

> Garantia, AppleCare, canais oficiais, diagnósticos, recalls, assistências autorizadas.
> Como orientar o cliente a resolver com a Apple quando for caso deles.
> Atualizado: 31/05/2026

---

## 🟢 Garantia e Cobertura

### Tipos de Garantia

| Cobertura | Duração | O que cobre |
|-----------|---------|-------------|
| **Garantia Limitada (padrão)** | 1 ano | Defeitos de fabricação |
| **AppleCare+** | 2-3 anos | Garantia estendida + 2 danos acidentais/ano |
| **AppleCare+ com Theft/Loss** | 2 anos | (iPhone) + roubo/perda |
| **Suporte Telefônico** | 90 dias (grátis) | Dúvidas técnicas |

### Verificar Cobertura

```
Site: checkcoverage.apple.com/br
→ Digitar número de série do dispositivo
→ Ver data de compra, cobertura, suporte telefônico

Como achar o número de série:
- Menu Apple → Sobre Este Mac
- Na caixa do produto
- Gravado na parte de baixo do MacBook
```

### Programas de Recall / Troca (Importante!)

A Apple mantém programas gratuitos pra defeitos conhecidos, MESMO FORA DA GARANTIA:

```
Verificar: https://support.apple.com/pt-br/exchange_repair

Exemplos de programas ativos:
- MacBook Pro com teclado butterfly (2016-2019)
- MacBook Pro com problema de bateria (2016-2017)
- AirPods Pro com estalo (2020)
- iPhone 11 com problema de tela
- Adaptador de tomada com risco de choque
```

⚠️ **Sempre verifique recalls!** Cliente pode conseguir reparo GRÁTIS mesmo com Mac de 4 anos.

---

## 🟡 Canais de Suporte Oficial

### 1. Suporte Online (recomendado primeiro)
```
Site: support.apple.com/pt-br
→ Escolher produto → descrever problema
→ Opções: Chat, Telefone, Agendar Apple Store

Vantagens:
- Chat 24h (rápido, pode colar logs)
- Agendamento sem fila
- Diagnóstico remoto (eles rodam ferramentas no seu Mac)
```

### 2. Apple Store (loja física)
```
Endereços no Brasil:
- São Paulo: Morumbi Shopping, Village Mall (Barra-RJ)
- Rio de Janeiro: Village Mall
- Brasília: Iguatemi Brasília

Agendar OBRIGATÓRIO: support.apple.com → Agendar Genius Bar
```

### 3. Assistência Técnica Autorizada (AASP)
```
https://locate.apple.com/br/
→ Buscar por cidade
→ Filtrar por "Assistência Técnica Autorizada"

São autorizadas pela Apple, usam peças originais.
Mais espalhadas que Apple Store (tem em várias cidades).
```

### 4. Telefone
```
Brasil: 0800-761-0880 (seg-sex, 9h-21h)
```

---

## 🔥 Diagnóstico Oficial Apple

### Apple Diagnostics (hardware)

```
Apple Silicon: Desligar → segurar power → soltar quando ver Opções
               → segurar Cmd+D

Intel: Ligar → segurar D imediatamente

Resultados:
- ADP000 → Nenhum problema encontrado
- Código de erro → pesquisar em support.apple.com

Ex: NDC001 = problema de câmera
    PPM002 = problema de bateria
    NDR001 = problema de trackpad
```

### Diagnóstico Remoto (Apple Support)

```
Suporte Apple pode iniciar sessão de diagnóstico remoto:
1. Cliente acessa getsupport.apple.com
2. Suporte envia link de diagnóstico
3. Mac reinicia em modo diagnóstico
4. Resultados aparecem pro suporte Apple em tempo real
```

---

## 🎯 Cenários — "Pra quem eu mando o cliente?"

### Hardware com defeito físico

```
"Tela trincada, teclado quebrado, trackpad não funciona, bateria estufada..."

→ Garantia/AppleCare vigente: Apple Store ou AASP
→ Sem garantia: AASP (orçamento) ou Apple Store
→ Recall ativo: Apple Store/AASP (GRÁTIS!)

📞 Oriente o cliente:
"Seu Mac parece ter um problema físico. Você precisa levar em uma
 assistência autorizada Apple. Posso te ajudar a agendar pelo
 site support.apple.com ou achar a mais próxima em locate.apple.com."
```

### Software que não resolve (já tentou de tudo)

```
→ Apple Support (chat/telefone) — é GRÁTIS
→ Eles têm ferramentas de diagnóstico que nós não temos
→ Podem escalar pra engenharia se for bug do macOS

📞 Oriente o cliente:
"Isso parece ser um problema mais profundo do macOS. O suporte oficial
 da Apple é gratuito por chat no site support.apple.com. Eles conseguem
 rodar diagnósticos que vão além do que eu consigo remotamente."
```

### Bateria / Performance

```
→ checkcoverage.apple.com → ver se ainda tem garantia
→ Se bateria < 80% e em garantia/AppleCare → troca gratuita
→ Se fora: orçamento em AASP

Dica: macOS → System Settings → Bateria → Saúde da Bateria → Capacidade Máxima
      < 80% = "Service Recommended" = hora de trocar
```

---

## 🛡️ Canais de Serviço Apple

### Reparo Express (AppleCare+)
```
→ Apple envia caixa, cliente põe Mac, envia de volta
→ Ideal pra quem não tem Apple Store por perto
→ https://support.apple.com/pt-br/express-replacement
```

### Self Service Repair
```
→ Apple vende peças e ferramentas OFICIAIS
→ https://www.selfservicerepair.com
→ Brasil: NÃO disponível ainda (2026)
→ Mas é um sinal: Apple tá abrindo o reparo
```

---

## 📝 Como Preparar o Cliente pra Apple

### Antes de ir na Apple Store/AASP

```
☐ FAZER BACKUP COMPLETO (Time Machine!)
   → A Apple pode apagar/formartar o Mac durante o reparo
   → NÃO entregue o Mac sem backup!

☐ Desativar FileVault (ou ter recovery key anotada)
   → System Settings → Privacidade → FileVault → Desligar
   → Ou ter a recovery key em mãos

☐ Desabilitar "Buscar Mac" (Find My Mac)
   → System Settings → Apple ID → iCloud → Buscar Mac → Desligar

☐ Anotar número de série (menu Apple → Sobre Este Mac)

☐ Levar nota fiscal (se tiver)

☐ Levar carregador (vão testar!)

☐ Explicar o problema CLARAMENTE:
   "Quando abro o app X, acontece Y. Já tentei Z e W."
```

---

## ⚠️ O que eu NÃO posso fazer (e por que)

| Situação | Por que escalar pra Apple |
|----------|--------------------------|
| Mac na garantia com defeito físico | Perde a garantia se abrir |
| Bateria estufada | Risco de incêndio! 🚨 |
| Tela com linhas/artefatos | Troca de display (caro, precisa ser oficial) |
| Trackpad/Teclado parou | Peça original Apple |
| Kernel panic frequente em Mac novo | Pode ser defeito de fábrica |
| Recall ativo | Reparo GRÁTIS, só autorizadas |

---

## 🎯 Script de Encaminhamento

```
"Pelo que analisei, seu Mac tem [problema]. Isso é [hardware/software profundo].

Para resolver, você vai precisar do suporte oficial da Apple.
É gratuito e eles têm ferramentas específicas.

Como fazer:
1. Acesse support.apple.com/pt-br
2. Escolha 'Mac' → descreva o problema
3. Você pode falar por chat (24h) ou agendar numa loja

Se for hardware:
- Veja sua garantia em checkcoverage.apple.com
- Assistências em locate.apple.com

IMPORTANTE: Faça backup antes de levar!"

Precisa de ajuda com mais alguma coisa?
```

---

## 📊 Resumo Rápido

| Cliente tem... | Encaminhar para... | Link |
|---------------|-------------------|------|
| Dúvida técnica | Chat Apple (grátis) | support.apple.com |
| Hardware quebrado | Apple Store / AASP | locate.apple.com |
| Ver garantia | Verificação online | checkcoverage.apple.com |
| Recall / defeito conhecido | Programas de reparo | support.apple.com/exchange_repair |
| Bateria ruim | AASP (orçamento) | locate.apple.com |
| Telefone | 0800-761-0880 | - |

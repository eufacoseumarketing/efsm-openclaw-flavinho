# 💻 Guia de Máquinas por Fabricante — Mercado Brasileiro

> Principais linhas, modelos, especificações típicas, problemas comuns.
> Como identificar e o que esperar de cada máquina.
> Atualizado: 31/05/2026

---

## 🍎 Apple — Premium & Ecossistema Fechado

### Linhas e Posicionamento

| Linha | Público | Faixa de Preço | Chip |
|-------|---------|---------------|------|
| **MacBook Air** | Estudante, escritório, uso leve | R$ 8K-15K | M2/M3/M4 |
| **MacBook Pro 14"** | Profissional criativo/dev | R$ 18K-30K | M4/M4 Pro |
| **MacBook Pro 16"** | Profissional pesado (vídeo/3D) | R$ 25K-50K | M4 Pro/M4 Max |
| **iMac** | Desktop all-in-one colorido | R$ 14K-25K | M4 |
| **Mac mini** | Desktop compacto (só gabinete) | R$ 5K-15K | M4/M4 Pro |
| **Mac Studio** | Workstation criativa | R$ 25K-60K | M4 Max/M4 Ultra |
| **Mac Pro** | Workstation corporativa | R$ 50K-100K+ | M4 Ultra |

### Especificações Típicas (2025-2026)

```
MacBook Air M4:   13.6" ou 15.3", 16-24GB RAM, 256GB-2TB SSD, 2 portas USB-C, MagSafe, fanless
MacBook Pro 14" M4: 14.2", 16-32GB RAM, 512GB-2TB, 3 USB-C + HDMI + SDXC + MagSafe
MacBook Pro 16" M4 Max: 16.2", 36-128GB RAM, 1TB-8TB SSD
```

### Intel vs Apple Silicon — Saber Identificar

```
Intel (2016-2020): MacBook Air/Pro com chip Intel Core i5/i7/i9
  → Boot com Intel, NVRAM reset (Cmd+Opt+P+R), SMC reset
  → Pode rodar Windows via Boot Camp
  → Mais quente, menos bateria

Apple Silicon (2020+): M1/M2/M3/M4/M5
  → Boot com Apple ROM, SEM reset manual de NVRAM
  → NÃO roda Boot Camp (só virtualização)
  → Frio, bateria dura MUITO
```

### Problemas Comuns

| Modelo | Problema Típico | Causa |
|--------|----------------|-------|
| MacBook Pro 2016-2019 | Teclado repete/falha | Butterfly keyboard (recall!) |
| MacBook Air 2018-2020 | Tela flexgate (manchas) | Cabo flat curto |
| MacBook 12" (2015-2019) | Morre do nada | USB-C único + bateria incha |
| MacBook Pro 2016-2020 | Touch Bar apaga | Falha de firmware |
| Todos Intel T2 (2018-2020) | Kernel panic em ponte | T2 chip instável |
| MacBook Air M1/M2 | SSD soldado → sem upgrade | Arquitetura Apple |
| MacBook Pro M4 | Tela com ghosting | Mini-LED (alguns lotes) |

---

## 🟢 Dell — Empresarial Sólido, Suporte Bom no Brasil

### Linhas e Posicionamento

| Linha | Público | Faixa de Preço | Processador Típico |
|-------|---------|---------------|-------------------|
| **Inspiron** | Doméstico, uso geral | R$ 2.5K-6K | Core i3/i5/i7, Ryzen 5/7 |
| **Vostro** | Micro/Pequena empresa | R$ 3K-7K | Core i5/i7, Ryzen 5/7 |
| **Latitude** | Corporativo, grandes empresas | R$ 6K-15K | Core i5/i7 vPro, Ryzen 7 |
| **XPS** | Premium/criativo | R$ 8K-20K | Core Ultra 7/9 |
| **Alienware** | Gamer | R$ 7K-30K | Core i7/i9 + RTX |
| **OptiPlex** | Desktop empresarial | R$ 3K-8K | Core i3/i5/i7 |
| **Precision** | Workstation (CAD, 3D) | R$ 15K-40K | Xeon/Core i9 + Quadro |

⚠️ Linhas no Brasil: Dell vende principalmente Inspiron e Latitude. Vostro sumiu parcialmente, XPS voltou.

### Como ler modelo Dell

```
Ex: Inspiron 15 3530
→ 15 = 15.6" (14 = 14", 16 = 16")
→ 3000 = entrada, 5000 = médio, 7000 = premium
→ 3530 = geração/ano (35xx = 2023/24)

Ex: Latitude 5540
→ 5000 = médio corporativo (3000 = entrada, 7000 = premium, 9000 = ultra)
→ 540 = geração

Ex: XPS 15 9530
→ 15 = tamanho
→ 9000 = série premium
```

### Problemas Comuns

| Modelo | Problema Típico |
|--------|----------------|
| Inspiron 15 3000 | Dobradiça quebra (plástico frágil) |
| Inspiron 15 5000 | Bateria estufa após 2-3 anos |
| Inspiron (todos Linux) | Ubuntu pré-instalado → cliente esperava Windows |
| Latitude (todos) | Tecla Fn lock (Esc com cadeado) — cliente acha que teclado quebrou |
| Latitude (todos) | Driver Dell Optimizer causa microfone/câmera bug |
| XPS 15/17 | Trackpad levantando/bateria incha |
| XPS 13 Plus | Touch bar (igual Apple, morre) |
| Alienware | Command Center bugado após update Windows |
| OptiPlex | Fonte de alimentação proprietária — difícil substituir |

---

## 🔵 HP — Onipresente, Variedade Enorme

### Linhas e Posicionamento

| Linha | Público | Faixa de Preço |
|-------|---------|---------------|
| **HP 240/250 Gx** | Entrada corporativa/estudante | R$ 2K-4K |
| **Pavilion** | Doméstico, multimídia | R$ 2.5K-6K |
| **Pavilion x360** | 2-em-1 conversível | R$ 3.5K-7K |
| **Envy** | Premium acessível | R$ 5K-9K |
| **Spectre x360** | Premium 2-em-1 | R$ 8K-15K |
| **ProBook** | SMB corporativo | R$ 4K-8K |
| **EliteBook** | Corporativo premium | R$ 7K-15K |
| **OMEN** | Gamer | R$ 6K-20K |
| **Victus by HP** | Gamer entrada | R$ 3.5K-6K |

### Como ler modelo HP

```
Ex: HP 240 G10
→ 240 = modelo base (2 = série, 40 = tela 14")
→ G10 = 10ª geração do modelo

Ex: Pavilion 15-eg2053nr
→ 15 = 15.6"
→ eg = código de plataforma
→ 2053nr = SKU

Ex: EliteBook 840 G11
→ 8 = série corporativa
→ 40 = 14" (50 = 15.6")
→ G11 = 11ª geração
```

### Problemas Comuns

| Modelo | Problema Típico |
|--------|----------------|
| HP 240/250 Gx | Teclado afunda no centro, trackpad vagabundo |
| Pavilion 15 | Bateria descarrega rápido, dobradiça barulhenta |
| Pavilion x360 | Dobradiça do 2-em-1 QUEBRA (muito frequente!) |
| Spectre x360 | Coil whine (apito da placa), temperatura alta |
| EliteBook 840/845 | HP Sure Start corrompe BIOS após update |
| ProBook | Webcam HP Privacy Camera não liga (clientes acham que quebrou) |
| OMEN | OMEN Gaming Hub + Windows Update = conflito de driver |
| HP (geral) | HP Support Assistant enche o saco, pop-ups infinitos |

---

## 🔴 Lenovo — Líder Global, Excelente Teclado

### Linhas e Posicionamento

| Linha | Público | Faixa de Preço |
|-------|---------|---------------|
| **IdeaPad 1/3** | Entrada | R$ 1.8K-3K |
| **IdeaPad 5** | Médio doméstico | R$ 3K-5K |
| **IdeaPad Flex** | 2-em-1 acessível | R$ 3K-5K |
| **Yoga** | Premium 2-em-1 | R$ 5K-12K |
| **ThinkPad E** | Corporativo entrada | R$ 3.5K-6K |
| **ThinkPad T** | Corporativo premium | R$ 7K-15K |
| **ThinkPad X1** | Ultra-premium executivo | R$ 12K-25K |
| **LOQ** | Gamer entrada | R$ 3.5K-6K |
| **Legion** | Gamer premium | R$ 6K-20K |

### ThinkPad = O Melhor Teclado

```
TrackPoint (borrachinha vermelha no meio) = 100% ThinkPad
Teclado "perfeito": 1.8mm travel, resistente a líquido
ThinkPad T14 = "tanque de guerra corporativo"
```

### Problemas Comuns

| Modelo | Problema Típico |
|--------|----------------|
| IdeaPad 1/3 | 4GB RAM soldada! Impossível upgrade → lento eterno |
| IdeaPad 1/3 | eMMC em vez de SSD → MUITO lento |
| Yoga (todos) | Dobradiça do 2-em-1 pode travar/quebrar |
| ThinkPad T14 | USB-C Thunderbolt falha (controlador queima) |
| ThinkPad (todos) | BIOS Update automático via Vantage pode travar |
| Legion 5 | NVIDIA Optimus (troca GPU integrada/dedicada) buga |
| Lenovo (todos) | Lenovo Vantage = bloatware enche o saco |
| Lenovo (geral) | Bateria só carrega até 80% = Conservation Mode ativado (NÃO é defeito!) |

---

## 🇧🇷 Positivo / VAIO / Multilaser — Nacionais Populares

### Positivo

```
Principal marca brasileira. MUITO comum em:
- Governo (licitações)
- Escolas
- Cliente residencial de entrada

Linhas:
- Vision R15: entrada (Celeron/i3, 4-8GB RAM, eMMC ou SSD)
- Motion: médio (i5, 8GB, SSD)
- Duox: tablet
- Positivo Casa Inteligente: notebooks + Alexa integrada

Preço: R$ 1.2K a R$ 3K
```

### VAIO (licenciada pela Positivo no Brasil)

```
Marca VAIO pertence à Positivo no Brasil desde ~2015
Modelos: VAIO FE14, FE15, FE16
Posicionamento: médio (acima do Positivo Vision, abaixo do Dell/HP)
Preço: R$ 2.5K a R$ 4.5K
```

### Multilaser / Multi

```
Marca de entrada, baixíssimo custo
Modelos: Multi Ultra, Multi PC (netbooks), Multi Book
Preço: R$ 800 a R$ 2K
⚠️ Qualidade MUITO inferior. "Barato que sai caro."
```

### Problemas Comuns (Nacionais)

| Marca/Modelo | Problema Típico |
|-------------|----------------|
| Positivo Vision R15 | 4GB RAM + eMMC → Windows 11 mal roda |
| Positivo Vision R15 | Bateria descarrega mesmo desligado |
| Positivo Motion | Conector DC (carregador) quebra fácil |
| Positivo (todos) | Teclado desgasta rápido, teclas caem |
| VAIO FE | SSD troca (M.2) — upgrade fácil, mas cliente não sabe |
| VAIO FE | Trackpad de plástico, impreciso |
| Multilaser Multi | Tela TN lavada (ângulo de visão zero) |
| Multilaser Multi | eMMC soldada, sem slot pra SSD, impossível expandir |
| Multilaser Multi | Carregador proprietário, difícil achar substituto |

---

## 🟣 Samsung — Galaxy Book e Ecossistema

```
Linhas no Brasil:
- Galaxy Book 2/3/4/5: Ultrabook premium (Core i5/i7/Ultra, 8-16GB)
- Galaxy Book Pro: Fino, leve, AMOLED
- Galaxy Book Ultra: Topo de linha
- Galaxy Book Go: Entrada com Snapdragon (ARM!)

Diferencial: integração com celular Samsung (Quick Share, Buds, etc.)
Preço: R$ 3K a R$ 12K
```

### Problemas Comuns

| Modelo | Problema Típico |
|--------|----------------|
| Galaxy Book (todos) | Samsung Settings conflita com Windows Update |
| Galaxy Book Pro | AMOLED pode ter burn-in (tela marcada) |
| Galaxy Book Go | Snapdragon ARM = apps x86 em emulação → lentidão |
| Galaxy Book 2/3 | Bateria incha precocemente |

---

## 🔶 Acer — Custo-Benefício Imbatível

```
Linhas:
- Aspire 1/3/5: Entrada/Médio (R$ 1.5K - R$ 4K)
- Aspire Vero: Sustentável (plástico reciclado)
- Nitro: Gamer entrada (R$ 3.5K - R$ 6K)
- Predator: Gamer premium (R$ 7K - R$ 20K)
- Swift: Ultraportátil premium
- TravelMate: Corporativo
```

### Problemas Comuns

| Modelo | Problema Típico |
|--------|----------------|
| Aspire 3/5 | Dobradiça plástica quebra (parafuso solta da carcaça) |
| Aspire 1 | eMMC 64GB → impossível Windows + apps |
| Nitro 5 | Cooler barulhento, superaquecimento |
| Predator | Predator Sense (software controle) buga após update |

---

## 🔷 ASUS — Variedade e Inovação

```
Linhas:
- VivoBook: Entrada/Médio (R$ 2K - R$ 5K)
- Zenbook: Premium/Ultrabook (R$ 5K - R$ 12K)
- ExpertBook: Corporativo
- TUF Gaming: Gamer durável/militar (R$ 4K - R$ 8K)
- ROG (Republic of Gamers): Gamer premium (R$ 6K - R$ 25K)
- ProArt: Criativo (designers, editores)
```

### Problemas Comuns

| Modelo | Problema Típico |
|--------|----------------|
| VivoBook | Dobradiça frágil (mesmo problema do Acer) |
| VivoBook OLED | Burn-in em OLED de entrada |
| Zenbook | Teclado NumberPad no trackpad não funciona |
| TUF Gaming | Armoury Crate (software) pesa no sistema |
| ROG | Bateria descarrega conectado na tomada (bypass bug) |

---

## 🎮 Avell — Gamer Brasileiro Premium

```
Marca brasileira especializada em notebooks gamer/workstation
Vende direto, configurável no site
Modelos: Storm, Ion, A72
Preço: R$ 5K - R$ 25K
Qualidade: boa (usa chassis Clevo/Tongfang)

Problemas: suporte pequeno, garantia só 1 ano sem extensão, reposição de peças demorada
```

---

## 🖥️ Desktops Pré-Montados

### Marcas Comuns no Brasil

| Marca | Linhas | Público |
|-------|--------|---------|
| **Dell** | OptiPlex, Inspiron Desktop | Empresarial/Doméstico |
| **HP** | EliteDesk, ProDesk, Pavilion Desktop | Empresarial/Doméstico |
| **Lenovo** | ThinkCentre, IdeaCentre | Empresarial/Doméstico |
| **Positivo** | Master, Union | Governo/Escolas |
| **Itautec** | STI | Governo (legado) |
| **Montados** | - | Lojas locais, Pichau, Terabyte |

### Diferença crítica Desktop vs Notebook

```
Desktop = fonte padrão (ATX), fácil substituir
Desktop corporativo (OptiPlex/EliteDesk) = fonte proprietária, tamanho customizado
SFF (Small Form Factor) = cabe em qualquer lugar, mas fonte é minúscula e cara
```

---

## 🎯 Identificando a Máquina do Cliente

```powershell
# Windows (via PC Resolve PowerShell)
Get-CimInstance Win32_ComputerSystem | Select Manufacturer, Model
Get-CimInstance Win32_BIOS | Select SerialNumber, SMBIOSBIOSVersion
```

```bash
# macOS (via Terminal)
system_profiler SPHardwareDataType | grep "Model Identifier\|Serial Number"
```

```bash
# Linux
sudo dmidecode -s system-manufacturer
sudo dmidecode -s system-product-name
sudo dmidecode -s system-serial-number
```

---

## ⚡ Resumo Rápido por Cliente

| Cliente típico | Máquina provável | Problema #1 |
|---------------|-----------------|-------------|
| Advogado/Contador | Dell Latitude / Lenovo ThinkPad | Certificado digital |
| Designer/Editor | MacBook Pro / Dell XPS | Kernel panic / driver |
| Estudante | Positivo / IdeaPad 1 / Aspire 1 | Lento (4GB + eMMC) |
| Empresa grande | Dell Latitude / HP EliteBook | VPN, AD, proxy |
| Home office | Inspiron / Pavilion / Galaxy Book | Wi-Fi, impressora |
| Gamer | Alienware / Legion / Nitro | Driver NVIDIA |
| Idoso | Positivo / Multilaser | "Sumiu tudo", golpe, phishing |
| Servidor público | Positivo Master / HP EliteDesk | Sistema legado, certificado |

---

## ⚠️ Dicas Jedi

- **"4GB RAM + eMMC"** = receita pra lentidão. Identifique na hora e avise o cliente: upgrade impossível.
- **ThinkPad com bateria em 80%** = Conservation Mode, NÃO defeito. Vantage → desabilitar.
- **HP com câmera preta** = botão físico de privacy. Olhe a câmera: tem uma tampinha laranja?
- **Notebook Linux de fábrica** (Inspiron, Positivo) → cliente comprou e estranhou. Explicar que economizou na licença Windows.
- **Dell Latitude Fn lock** = Esc tem um cadeado. Fn+Esc destrava. Cliente sempre acha que teclado quebrou.

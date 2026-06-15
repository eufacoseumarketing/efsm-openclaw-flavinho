# 🖨️ Impressoras — Guia Completo HelpDesk

> Do spooler travado à troca de fusor. Marcas, problemas, soluções.
> Atualizado: 31/05/2026

---

## 🟢 NÍVEL 1 — Tipos e Fundamentos

### Tipos de Impressora

| Tipo | Como funciona | Uso típico |
|------|---------------|------------|
| **Laser** | Toner + fusor (calor). Pó fixado no papel | Escritório, alto volume, texto |
| **Jato de Tinta** | Cartucho com tinta líquida, cabeçote imprime | Casa, fotos, baixo volume |
| **Tanque de Tinta (Bulk Ink)** | Reservatório recarregável de tinta | Casa/escritório econômico |
| **Térmica** | Calor em papel térmico (sem tinta) | Cupom fiscal, etiqueta, NFC-e |
| **Matricial** | Agulhas batem em fita com tinta | Nota fiscal, formulário contínuo |

### Componentes de uma Laser
```
1. Toner           → Pó que vira imagem (magenta, cyan, yellow, black)
2. Cilindro (Drum) → Recebe imagem eletrostática, transfere toner
3. Fusor           → Cilindros aquecidos (~200°C) que fixam o toner
4. Unidade de imagem → Cilindro + revelador (em algumas, integrado ao toner)
```

### Consumíveis e vida útil
```
Toner:         ~1.500 a 20.000 páginas
Cilindro:      ~12.000 a 50.000 páginas
Fusor:         ~50.000 a 200.000 páginas
Kit manutenção: Fusor + rolos (a cada ~50.000 pág em média)
```

### Conexões
```
USB Tipo B     → Clássico, cabo quadrado na impressora
USB Tipo C     → Modelos recentes
Ethernet RJ-45 → Rede cabeada (IP fixo ou DHCP)
Wi-Fi 2.4 GHz  → Rede sem fio (WPS, Wi-Fi Direct)
Wi-Fi 5 GHz    → Modelos mais novos
Bluetooth      → Impressoras portáteis (Zebra, Brother PocketJet)
```

---

## 🟡 NÍVEL 2 — Principais Marcas

### HP (Hewlett-Packard) — ~35% do mercado
**Linhas:**
- **LaserJet** → Laser corporativa (M404, M428, M607)
- **OfficeJet** → Jato de tinta escritório (OfficeJet Pro 9010)
- **DeskJet** → Jato de tinta doméstica (DeskJet 2700, 4100)
- **Smart Tank** → Tanque de tinta (Smart Tank 585, 7305)

**Peculiaridades:**
- HP Smart app (meio polêmico, força conta HP em alguns modelos)
- Firmware que bloqueia toner não-original (⚠️ atualizar = risco!)
- Driver Universal Print Driver (UPD) → um driver pra todas LaserJet
- Web JetAdmin → gerenciamento de frota

**Problemas típicos:**
- Erro "Cartucho não reconhecido" → comum em DeskJet/OfficeJet
- HP Smart instalando automaticamente (indesejado)
- LaserJet M402/M404: erro 49 (firmware crash)

---

### Epson — ~20% do mercado
**Linhas:**
- **EcoTank** → Tanque de tinta, garrafa de reposição (L3250, L4260, L5290)
- **WorkForce** → Jato de tinta corporativo (WF-7840, WF-C5790)
- **Expression** → Doméstica fotográfica (Expression Photo XP-8700)

**Peculiaridades:**
- EcoTank: tanque de tinta recarregável (economia absurda)
- Cabeçote NÃO vai no cartucho → se entupir, é caro
- Tinta original Epson é pigmentada (dura mais que corante)
- PrecisionCore → tecnologia de cabeçote

**Problemas típicos:**
- Cabeçote entupido (EcoTank parada por semanas → limpeza de cabeçote)
- "Pad de tinta cheio" (waste ink pad counter) → precisa resetar via software
- Wi-Fi Direct conflitando com rede normal

---

### Canon — ~19% do mercado
**Linhas:**
- **imageCLASS** → Laser (LBP226dw, MF465dw)
- **PIXMA** → Jato de tinta doméstica/foto (G3010, TS6350)
- **MegaTank** → Tanque de tinta (G3010, G4110)
- **SELPHY** → Portátil fotográfica (térmica com sublimação)

**Peculiaridades:**
- Cartucho com cabeçote integrado (PG-245, CL-246) → troca = cabeçote novo
- MegaTank concorre direto com EcoTank Epson
- imageCLASS tem fama de robusta

**Problemas típicos:**
- Erro B200 (cabeçote queimado) → PIXMA
- Erro "Absorvente de tinta cheio" → precisa trocar pad ou reset
- PIXMA não reconhece cartucho recondicionado

---

### Brother — ~8% do mercado
**Linhas:**
- **HL** → Laser monocromática (HL-L2350DW, HL-L5100DN)
- **DCP** → Multifuncional laser (DCP-L5652DN)
- **MFC** → Multifuncional completa (MFC-L5710DW, MFC-J6940DW)

**Peculiaridades:**
- Menos bloqueio de toner não-original que HP (⚠️ vantagem!)
- Tambor (drum) separado do toner (econômico a longo prazo)
- Firmware raramente causa problemas
- Driver genérico bom, compatível com BR-Script (PostScript)

**Problemas típicos:**
- "Toner Low" mesmo com toner cheio → resetar gear/flag do toner
- DR mode não resetado ao trocar cilindro
- Sensor de porta aberta com defeito (microswitch)

---

### Samsung → HP (adquirida em 2017)
**Linhas (legado):**
- **Xpress** → Laser pequena/média (M2020, M2835DW, M4070)
- **ProXpress** → Laser corporativa (M4560)

**Peculiaridades:**
- Samsung foi comprada pela HP. Linha agora é HP.
- Modelos Samsung ainda em campo, driver Samsung legacy
- Toner Samsung é caro e menos compatível com alternativos

**Problemas típicos:**
- Toner reset: nem sempre funciona com alternativo
- Erro #U1-2320 (fusor) comum
- Driver Samsung conflitando com driver HP no mesmo PC

---

### Outras Marcas Relevantes

**Xerox** — Corporativa pesada (WorkCentre, VersaLink, AltaLink)
- Cilindro/fusor caro, mas duram muito
- Drivers PostScript e PCL
- Problema típico: erro 116-xxx (scanner/fusor)

**Lexmark** — Corporativa (MX, CX, MS, CS series)
- Forte em ambientes corporativos e saúde
- Problema típico: erro 900.xx (firmware)

**Ricoh** — Multifuncionais corporativas
- Muito comum em locadoras
- Problema típico: SC (Service Code) no painel → precisa técnico

**Zebra** — Impressoras térmicas (etiquetas, código de barras)
- ZPL (Zebra Programming Language)
- Problema típico: calibração de etiqueta, sensor de gap

**Elgin, Daruma, Sweda, Bematech** — Fiscais (térmicas, ECF)
- Comuns no varejo brasileiro
- Problema típico: driver, comunicação serial/USB

---

## 🔥 NÍVEL 3 — Sistema de Impressão Windows

### Arquitetura do Spooler
```
App → GDI → Spooler (%systemroot%\System32\spool\PRINTERS\)
        → Print Processor → Driver → Port Monitor → Impressora
```

### Driver Types
```
Tipo 1 (User Mode)    → Legado, Windows XP
Tipo 2 (Kernel Mode)  → Windows 2000/XP/Vista (NÃO usar mais)
Tipo 3 (User Mode)    → Padrão atual, isolado do kernel
Tipo 4 (v4 Driver)    → Moderno, isolado, sem UI completa
```

**Regra:** Prefira Tipo 3 ou 4. Tipo 2 pode causar BSOD!

### Comandos Essenciais
```cmd
:: Serviço do spooler
net stop spooler
net start spooler

:: Limpar fila travada (PARAR spooler ANTES)
net stop spooler
del /q /f C:\Windows\System32\spool\PRINTERS\*
net start spooler
```

```powershell
# Listar impressoras
Get-Printer | Select Name,PrinterStatus,DriverName,PortName

# Status com problema
Get-Printer | Where-Object {$_.PrinterStatus -ne "Normal"}

# Ver fila de impressão
Get-PrintJob -PrinterName "HP LaserJet"

# Remover todos jobs travados
Get-PrintJob -PrinterName "*" | Remove-PrintJob

# Reiniciar spooler
Restart-Service Spooler -Force

# Drivers instalados
Get-PrinterDriver | Select Name,Manufacturer,Type

# Portas
Get-PrinterPort | Select Name,Protocol
```

---

## ⚡ NÍVEL 4 — Troubleshooting Jedi

### Problema #1: "Não imprime" (o clássico)

```cmd
:: Ritual de diagnóstico:
:: 1. A impressora tá LIGADA? (LED aceso? Display mostra algo?)
:: 2. Impressora padrão certa?
::    Configurações → Dispositivos → Impressoras
:: 3. Fila tem jobs travados?
::    Get-PrintJob -PrinterName "*"
:: 4. Status offline ou pausado?
::    Get-Printer | Select Name,PrinterStatus
:: 5. Spooler rodando?
::    Get-Service Spooler
```

```
Sequência de reset (se tudo acima OK):
1. Cancelar todos os documentos
2. Desligar impressora (da tomada, 30 segundos)
3. Parar spooler: net stop spooler
4. Limpar pasta: del C:\Windows\System32\spool\PRINTERS\* /q
5. Iniciar spooler: net start spooler
6. Ligar impressora
7. Testar página de teste
```

### Problema #2: Impressora offline

```
Causas comuns:
- Cabo USB desconectado/defeituoso
- Wi-Fi desconectou (impressora mudou de rede)
- IP da impressora mudou (era DHCP, deveria ser fixo)
- Sleep mode profundo (não acorda via rede)
- Porta WSD em vez de TCP/IP (WSD = Windows Service Discovery, problemático)

Solução:
→ Verificar cabo / ping no IP
→ Trocar porta WSD por TCP/IP (Standard TCP/IP Port)
→ IP fixo na impressora ou reserva DHCP no roteador
→ Desabilitar sleep mode no painel da impressora
```

### Problema #3: Qualidade ruim / manchado / falhado

**Laser:**
```
Linhas verticais pretas  → Cilindro riscado (trocar)
Fundo cinza/sujo         → Cilindro no fim da vida ou toner ruim
Manchas repetidas        → Fusor sujo ou cilindro (medir distância entre manchas!)
Pontos brancos           → Toner acabando ou sujeira no laser
Imagem apagando          → Toner acabando, agitar o toner
```

**Tinta:**
```
Riscos/lacunas na cor X  → Bico entupido (limpeza de cabeçote)
Cores erradas            → Cartucho errado no slot errado
Não imprime cor X        → Tinta acabou OU bico entupido
Papel borrado/molhado    → Excesso de tinta, papel errado, cabeçote sujo
```

### Problema #4: Wi-Fi da impressora

```
Não conecta na rede:
→ A maioria só conecta em 2.4 GHz (não 5 GHz!)
→ Senha errada (óbvio, mas comum)
→ WPS: aperta botão no roteador + botão na impressora
→ Wi-Fi Direct: impressora cria rede própria (não é a mesma do PC!)
→ Distância: parede grossa entre impressora e roteador = problema

Configurar IP fixo:
→ Painel da impressora → Rede → TCP/IP → Manual
→ Ex: IP 192.168.1.250, Máscara 255.255.255.0, Gateway 192.168.1.1
```

### Problema #5: Atolamento de papel (jam)

```
Localização do atolamento:
- Bandeja de entrada  → papel mal colocado, umidade
- Dentro do fusor      → papel rasgou, emendou
- Bandeja de saída     → papel dobrando, sensor sujo

Papel úmido = atolamento na certa!
Envelope e etiqueta = JAMAIS na laser sem especificação!
```

---

## 🎯 Marcas — Problemas Específicos

| Marca | Erro Comum | Solução Rápida |
|-------|-----------|----------------|
| **HP LaserJet** | 49.XXXX (firmware) | Desligar 5 min, religar. Se repetir: atualizar firmware |
| **HP DeskJet** | Cartucho não reconhecido | Limpar contatos dourados com álcool isopropílico |
| **HP Smart Tank** | Não imprime após recarga | Aguardar 30s após fechar tampa, NÃO desligar durante carga |
| **Epson EcoTank** | Cabeçote entupido | Head Cleaning 3x no menu, depois Power Cleaning se necessário |
| **Epson** | Waste Ink Pad Counter | Precisar de software de reset (WIC Reset Utility) |
| **Canon PIXMA** | B200 (cabeçote queimado) | Geralmente troca de cabeçote/cartucho |
| **Canon** | Absorvente cheio | Entrar em service mode, resetar ou trocar pad |
| **Brother** | Toner Low não reseta | Girar gear do toner, reset do drum se for DR |
| **Brother** | "No Paper" com papel | Sensor de papel sujo ou com mola travada |
| **Samsung** | #U1-2320 (fusor) | Desligar/religar, se repetir trocar fusor |
| **Samsung** | Toner não reconhecido | Chip do toner pode ter queimado, testar outro |

---

## 🛠️ Manutenção Preventiva

### Laser (a cada 6 meses ou 20.000 pág)
```
☐ Limpar rolos de alimentação (pano úmido)
☐ Limpar contatos do toner e cilindro
☐ Verificar/limpar fusor (CUIDADO: quente!)
☐ Aspirar pó de toner solto dentro da máquina (NUNCA soprar!)
☐ Atualizar firmware (com cautela em HP!)
☐ Verificar contador de páginas do kit manutenção
```

### Tinta (a cada uso ou semanalmente)
```
☐ Imprimir algo colorido pelo menos 1x por semana (evita entupir)
☐ Limpeza de cabeçote se qualidade cair
☐ Verificar nível de tinta
☐ Limpar vidro do scanner (se multifuncional)
☐ NUNCA deixar sem cartucho/tinta (cabeçote resseca)
```

---

## 📝 Diagnóstico Rápido — Script PowerShell

```powershell
function Test-PrinterHealth {
    param([string]$PrinterName = "*")
    
    Write-Host "=== DIAGNÓSTICO DE IMPRESSÃO ===" -Foreground Cyan
    
    # Spooler
    $spooler = Get-Service Spooler
    Write-Host "Spooler: $(if($spooler.Status -eq 'Running'){'✅'}else{'❌'}) $($spooler.Status)"
    
    # Impressoras
    $printers = Get-Printer
    Write-Host "`nImpressoras instaladas: $($printers.Count)"
    
    foreach ($printer in $printers) {
        $status = if($printer.PrinterStatus -eq 'Normal'){'✅'}else{'⚠️'}
        $jobs = (Get-PrintJob -PrinterName $printer.Name -ErrorAction SilentlyContinue).Count
        Write-Host "  $status $($printer.Name) | Status: $($printer.PrinterStatus) | Driver: $($printer.DriverName) | Porta: $($printer.PortName) | Jobs: $jobs"
    }
    
    # Portas
    Write-Host "`nPortas TCP/IP:"
    Get-PrinterPort | Where-Object {$_.Protocol -eq 'TCP/IP'} | ForEach-Object {
        Write-Host "  $($_.Name) → $($_.PrinterHostAddress):$($_.PortNumber)"
    }
    
    # Erros recentes
    Write-Host "`nErros recentes no Event Log:"
    Get-WinEvent -LogName System -MaxEvents 20 | Where-Object {$_.Id -eq 372 -or $_.ProviderName -eq 'Print'} | Select -First 5 | ForEach-Object {
        Write-Host "  ⚠️ $(Get-Date $_.TimeCreated -Format 'HH:mm:ss') - $($_.Message -replace '\n',' ' -replace '\r','')"
    }
}
```

---

## 🔍 NÍVEL 5 — Descoberta de Impressora na Rede (LIÇÃO APRENDIDA EFSM 01)

### O problema
Cliente tem uma impressora de rede mas não sabe marca, modelo, nem IP.
Você precisa achar e instalar.

### Fluxo vencedor (validado 15/06/2026)

```
PASSO 1 — Levantar a rede (instantâneo)
  ipconfig /all                        → IP do PC + gateway
  Get-NetNeighbor -AddressFamily IPv4  → tabela ARP (só IPs REAIS, ~2s)

PASSO 2 — Filtrar candidatos
  Remove gateway, IP do próprio PC, e IPs com MAC de fabricante
  não-impressora (Intel, Foxconn, Realtek...)

PASSO 3 — Scan ASSÍNCRONO (via arquivo, NUNCA síncrono)
  Usar padrão de arquivo da kb/execucao-assincrona-powershell.md
  Testar portas: 9100 (RAW), 631 (IPP), 515 (LPR)
  Alvo: SÓ os IPs reais (+ gateway como fallback pra impressoras
  com web interface)

PASSO 4 — Poll rápido lendo o arquivo
  A cada ~3s, Get-Content no .out pra ver progresso
  Marcador .done = finalizou
  Teto: ~2 min

PASSO 5 — Com o IP da impressora
  Test-NetConnection $ip -Port 9100     → confirma RAW
  Invoke-WebRequest http://$ip:631      → web interface (se tiver)
  Adicionar via TCP/IP Standard no Windows
```

### O que NUNCA fazer
- ❌ Varrer todos os 254 IPs às cegas (demora, sobrecarrega)
- ❌ Scan de rede SÍNCRONO (segura o slot, trava o agente)
- ❌ Invoke-WebRequest pra IPs desconhecidos (se não responder, trava)
- ❌ Tentar montar array no PowerShell com aspas duplas interpoladas
  (escape quebra fácil — use arquivo temporário)

### Por que Get-NetNeighbor é o segredo
A tabela ARP contém TODO dispositivo que o PC já falou na rede local.
Em vez de testar 254 IPs (a maioria vazio), você testa só os ~10-20
que realmente existem. Exemplo real EFSM 01: 19 IPs → scan em 30s →
impressora encontrada.

### Script de descoberta (via arquivo, assíncrono)
```powershell
# Dispara em background
$d="$env:PUBLIC\PCR"; New-Item -ItemType Directory -Force $d | Out-Null
$t="PCR_net_scan"; Remove-Item "$d\$t.*" -ErrorAction SilentlyContinue

# Pega os IPs da ARP (comando interno, montamos no script)
Start-Process powershell -WindowStyle Hidden -ArgumentList @('-NoProfile','-Command',
  "& { $base=(Get-NetIPConfiguration | Where-Object {`$_.IPv4DefaultGateway}).IPv4Address.IPAddress -replace '\.\d+$',''; Get-NetNeighbor -AddressFamily IPv4 | Where-Object {`$_.State -eq 'Reachable' -or `$_.State -eq 'Stale'} | ForEach-Object { `$_.IPAddress } | ForEach-Object { `$ip=`$_; foreach (`$p in 9100,631,515) { if ((Test-NetConnection `$ip -Port `$p -WarningAction SilentlyContinue).TcpTestSucceeded) { `"`$ip -> impressora (porta `$p)`"; break } } } } *>&1 | Out-File -Encoding utf8 '$d\$t.out'; 'DONE' | Out-File '$d\$t.done'")

# Poll (roda a cada ~3s)
$d="$env:PUBLIC\PCR"; $t="PCR_net_scan"
if (Test-Path "$d\$t.done") { "STATUS=FINISHED"; Get-Content "$d\$t.out" }
else { "STATUS=RUNNING"; Get-Content "$d\$t.out" -Tail 8 -ErrorAction SilentlyContinue }

# Limpeza
Remove-Item "$env:PUBLIC\PCR\PCR_net_scan.*" -Force -ErrorAction SilentlyContinue
```

---

## ⚠️ Dicas Jedi

- **Papel importa!** Papel reciclado solta mais pó e entope. Papel úmido atola.
- **Toner original vs compatível:** Compatível é 50-70% mais barato, mas pode sujar, entupir, dar erro de reconhecimento. Em produção crítica = original.
- **Tinta original vs compatível:** Compatível entope mais cabeçote. EcoTank com tinta original = paz.
- **Porta WSD = 💀.** Sempre troque por TCP/IP Standard.
- **Nunca atualize firmware de HP** sem ler changelog: podem bloquear toner compatível.
- **Impressora parada = impressora morta.** Tinta resseca, toner empedra. Use pelo menos 1x/semana.
- **Wi-Fi 2.4 GHz** é o que 90% das impressoras usam. Se seu roteador separa as bandas, conecte na 2.4.

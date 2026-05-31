# 🖥️ Multi-Monitor, Projetor & Video — Guia HelpDesk

> 2+ telas, projetor, resolução, cabos (HDMI/VGA/DP), wireless display, duplicar/estender.
> Atualizado: 31/05/2026

---

## 🟢 Modos de Projeção

```
Win+P = menu rápido de projeção:

🖥️ Tela do PC somente   → Monitor externo DESLIGADO
🖥️🖥️ Duplicar            → Mesma imagem nas duas telas
🖥️➡️🖥️ Estender           → Área de trabalho expandida (MAIS USADA)
🖥️ Segunda tela somente → Monitor principal desliga

⚠️ 90% dos chamados de "projetor não funciona" = Win+P no modo errado.
```

---

## 🟢 Cabos de Video

| Cabo | Aparência | Máx. Resolução | Áudio | Comum em |
|------|-----------|---------------|-------|----------|
| **HDMI** | Trapézio | 4K@60Hz | ✅ Sim | Notebook, TV, monitor |
| **DisplayPort** | Retângulo com canto chanfrado | 8K@60Hz | ✅ Sim | Monitor gamer, estação |
| **USB-C DP** | Oval pequeno | 8K@60Hz | ✅ Sim | Ultrabooks modernos |
| **VGA** | Azul, 15 pinos, parafuso | 1080p | ❌ Não | Projetor antigo, legado |
| **DVI** | Branco, 24 pinos | 1080p/1440p | ❌ Não | Monitor antigo |
| **Mini DP** | DisplayPort pequeno | 4K@60Hz | ✅ Sim | Notebooks antigos |
| **Thunderbolt** | USB-C com raio | 8K@60Hz | ✅ Sim | MacBook Pro, Dell XPS |

⚠️ **VGA não transmite áudio!** Cliente conecta VGA no projetor e reclama que não tem som.
⚠️ **Adaptador VGA→HDMI precisa ser ATIVO** (conversor de sinal analógico→digital). Adaptador passivo NÃO funciona.

---

## 🔥 Configuração Avançada

### Resolução Diferente nas Telas

```powershell
# Listar monitores e resoluções
Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorList
```

```
1. Config → Sistema → Tela → Múltiplas Telas
2. Selecionar monitor → Resolução → escolher a NATIVA do monitor
3. "Recomendado" = resolução nativa. Usar sempre essa!

Problema: TV 4K como monitor → Windows sugere 150-300% de escala
→ Ajustar: Escala → valor confortável (125-150% comum em 4K)
```

### Monitor Pisca / Perde Sinal

```
1. Cabo mal encaixado (HDMI é meio solto — empurrar firme)
2. Cabo HDMI de R$ 5 = perda de sinal (testar outro)
3. Frequência (Hz) errada → Config avançadas de vídeo → Taxa de atualização
4. Driver de vídeo → reinstalar via DDU
5. Fonte do monitor? (monitores antigos desligam sozinhos por capacitor ruim)
```

### "Monitor aparece Detectar mas tela preta"

```
1. Win+P → verificar modo (não tá em "Segunda tela somente"?)
2. Monitor ligado? (sim, cliente jura que tá. Pedir pra verificar LED.)
3. Entrada certa no monitor? (HDMI 1 vs HDMI 2, input source)
4. Notebook: fn+F4/F5/F7/F8 (atalho de troca de vídeo da marca)
5. Resolução maior que o monitor suporta → reduzir
```

---

## 🎯 Projetor

### Problemas Clássicos

```
1. "Imagem azul / sem sinal"
   → Projetor na entrada errada (VGA, HDMI 1, HDMI 2)
   → Apertar Source/Input no projetor ou controle

2. "Imagem cortada / não cabe na tela"
   → Resolução errada no PC (projetor de 1024x768 recebendo 1080p)
   → Win+P → Extender → arrumar resolução do monitor 2

3. "Projetor desliga sozinho após uns minutos"
   → Timer no projetor? (Projetor Epson tem timer de desligamento)
   → Superaquecimento (ventoinha suja) → limpeza do filtro

4. "Lâmpada do projetor acabou"
   → Luz vermelha piscando "LAMP" = trocar lâmpada
   → Verificar horas de uso no menu do projetor
```

### Wireless Display / Miracast

```
Win+K = Conectar a uma tela sem fio

Requisitos:
- PC com Wi-Fi (Miracast)
- TV/Monitor compatível ou adaptador (Chromecast, Microsoft Wireless Display)
- Ambos na mesma rede (ou direct Wi-Fi)

Problema comum: PC não acha a TV
→ TV conectada (YouTube, Netflix funcionam?)
→ Wi-Fi do PC LIGADO (Miracast usa o chip Wi-Fi mesmo na rede cabeada!)
→ Firewall bloqueando?
```

---

## ⚡ Resolução de Problemas Jedi

### "Tela externa não liga de jeito nenhum"

```
1. Testar monitor com OUTRO PC (e outro cabo) → monitor funciona?
2. Testar OUTRO monitor no PC → PC detecta?
3. Bootar com monitor externo conectado → BIOS aparece no externo?
   Se SIM → problema de driver Windows
   Se NÃO → problema de hardware (placa/porta)
4. Device Manager → Adaptadores de vídeo → desinstalar → reiniciar
```

### "Tela duplicada mas uma fica preta"

```
= Resolução ou frequência incompatível entre monitores
→ Extender em vez de duplicar
→ Ou igualar resoluções
```

### "Notebook não detecta segundo monitor pela docking station"

```
1. Docking precisa de driver (Dell WD19, HP Thunderbolt, Lenovo)
2. Firmware da dock atualizado?
3. USB-C do notebook suporta vídeo? (Nem TODO USB-C passa vídeo!)
4. Notebook carregando pela dock? (Algumas docks só funcionam com energia)
```

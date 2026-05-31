# 🌐 Roteador & Wi-Fi Doméstico — Guia HelpDesk

> Roteador, mesh, repetidor, 2.4 vs 5GHz, canais, port forwarding, problemas comuns.
> Atualizado: 31/05/2026

---

## 🟢 Anatomia do Roteador Doméstico

```
Internet do Provedor
        │
   [Modem/ONT] (fibra óptica / cabo coaxial)
        │
   [Roteador] ─────────── Wi-Fi ──── 📱💻🖥️
        │
   [Portas LAN] ───────── cabo ──── PC desktop, TV, impressora
```

⚠️ **Modem ≠ Roteador.** Mas a maioria dos provedores entrega um COMBO (modem+roteador).

---

## 🟢 Bandas Wi-Fi: 2.4 GHz vs 5 GHz

| | 2.4 GHz | 5 GHz |
|---|---------|-------|
| **Alcance** | Longe (atravessa paredes) | Curto (~2 cômodos) |
| **Velocidade** | Até ~100 Mbps | Até ~1 Gbps |
| **Interferência** | MUITA (micro-ondas, Bluetooth, vizinhos) | Pouca |
| **Canais** | 1, 6, 11 (sobrepostos) | Muitos, não sobrepõem |
| **Compatibilidade** | Tudo funciona | Dispositivos 2014+ |

### "Internet lenta" = 2.4 GHz lotado?

```powershell
# Ver canal e banda
netsh wlan show interfaces
netsh wlan show networks mode=bssid
```

```
Solução:
1. Separar SSID: "MinhaRede" (2.4) e "MinhaRede_5G" (5GHz)
   → Forçar dispositivos pro 5GHz
2. Ou usar Band Steering (roteador decide automaticamente)
3. Mudar canal 2.4 GHz pra 1, 6 ou 11 (menos interferência)
```

---

## 🟡 Problemas Comuns e Soluções

### "Wi-Fi não pega no quarto"

```
Causa: parede grossa, distância, interferência, roteador mal posicionado.

Soluções (da mais barata pra mais cara):
1. Reposicionar roteador: CENTRO da casa, ALTO, sem obstáculo
2. Repetidor: barato, mas corta velocidade pela metade
3. Powerline: usa rede elétrica (bom pra desktops, horrível pra celular)
4. Mesh: vários roteadores espalhados (melhor solução)
```

### "Wi-Fi cai quando micro-ondas liga"

```
= Interferência de 2.4 GHz (micro-ondas opera em 2.45 GHz)
→ Migrar dispositivo pro 5 GHz
```

### "Internet cai toda hora"

```
Diagnóstico:
1. Wi-Fi cai ou internet cai? Conectar CABO no roteador → testar
   → Se cabo funciona, problema é Wi-Fi
   → Se cabo NÃO funciona, problema é roteador/provedor

2. Ping pro roteador: ping 192.168.15.1 -t
   → Se ping cai = Wi-Fi/router ruim
   → Se ping não cai mas internet não funciona = provedor

3. Ping pra internet: ping 8.8.8.8 -t
   → Se ping constante = internet OK, problema é outro (DNS, roteador)
   → Se ping cai = provedor instável
```

### "Velocidade contratada ≠ velocidade que chega"

```
1. Testar no CABO primeiro (elimina Wi-Fi)
2. Testar em site confiável: fast.com, speedtest.net, brasilbandalarga.com.br
3. Se no cabo bate contratado mas no Wi-Fi não: problema é Wi-Fi
4. Se no cabo NÃO bate: chamar provedor
5. Velocidade Wi-Fi = SEMPRE menor que cabo (normal, não é defeito)
```

---

## 🔥 IP Fixo, DHCP, DMZ, Port Forward

### IP do Roteador (Gateway)

```
Comum:
- 192.168.0.1 (D-Link, TP-Link, Multilaser)
- 192.168.1.1 (TP-Link, ASUS, Intelbras)
- 192.168.15.1 (Vivo, Oi)
- 192.168.25.1 (NET/Claro)
- 10.0.0.1 (Alguns roteadores)

Como descobrir:
ipconfig → Gateway Padrão
```

### Port Forwarding (liberar porta)

```
Quando: câmera IP, servidor de jogo, acesso remoto a DVR

1. IP do roteador → login/senha (geralmente atrás do roteador)
2. Achar menu: Port Forwarding, NAT, Virtual Server, Redirecionamento
3. Criar regra: porta externa → IP interno do PC → porta interna
4. ⚠️ PC precisa de IP FIXO (reservar no DHCP do roteador)
5. Verificar se abriu: yougetsignal.com/tools/open-ports/
```

### DMZ

```
⚠️ DMZ = Todas portas abertas pro IP escolhido = PERIGO!
Só usar pra teste rápido, nunca permanente.
```

---

## 🛠️ Roteadores de Provedor — Marcas e Acessos

| Provedor | Gateway | Login/Senha Padrão |
|----------|--------|-------------------|
| **Vivo Fibra** | 192.168.15.1 | admin/admin (ou no adesivo) |
| **Claro/NET** | 192.168.0.1 | user/user ou admin/admin |
| **Oi Fibra** | 192.168.15.1 | (no adesivo embaixo) |
| **TIM** | 192.168.1.1 | admin/timbrasil |
| **Algar** | 192.168.127.254 | admin/admin |
| **Brisanet** | 192.168.100.1 | admin/admin |

⚠️ **Muitos provedores BLOQUEIAM acesso às configs do roteador.** Cliente precisa ligar lá pra pedir mudança.

---

## 🧪 Diagnóstico de Rede Doméstica (Script)

```powershell
# Script rápido de diagnóstico de rede doméstica
Write-Host "=== DIAGNÓSTICO DE REDE ==="
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select -First 1).NextHop
Write-Host "Gateway: $gateway"

Write-Host "`n--- Ping Gateway ---"
Test-Connection $gateway -Count 4 | Format-Table Address,ResponseTime

Write-Host "--- Ping Internet ---"
Test-Connection 8.8.8.8 -Count 4 | Format-Table Address,ResponseTime

Write-Host "`n--- DNS ---"
Resolve-DnsName google.com | Format-Table Name,IPAddress

Write-Host "`n--- Wi-Fi ---"
netsh wlan show interfaces | Select-String "SSID|Signal|Band|Channel|Receive rate"
```

---

## ⚡ Wi-Fi Profissional vs Doméstico

```
Casa GRANDE ou escritório? Não adianta roteador doméstico.

Solução profissional:
- UniFi (Ubiquiti) → Access Points
- TP-Link Omada
- Aruba Instant On

Solução doméstica "pro":
- Mesh (TP-Link Deco, Google Wi-Fi, Xiaomi Mesh)
- Roteador ASUS RT-AX86U ou similar

NUNCA:
- 3 repetidores em cascata → lentidão GARANTIDA
- Roteador de 2015 com Wi-Fi 4 (802.11n)
```

---

## 🎯 Playbook: "Internet Não Funciona"

```
1. O LED de "Internet/DSL/WAN" do roteador tá aceso?
   → NÃO: cabo solto, fibra rompida, provedor fora do ar
   → SIM: problema pode ser interno

2. Ping 192.168.15.1 (gateway) → OK?
   → NÃO: Wi-Fi do roteador morreu, reiniciar roteador
   → SIM: ir pro próximo passo

3. Ping 8.8.8.8 → OK?
   → NÃO: internet do provedor caiu, sem sinal
   → SIM: ir pro próximo passo

4. nslookup google.com → resolve nome?
   → NÃO: DNS quebrado. Trocar DNS pra 8.8.8.8 ou 1.1.1.1
   → SIM: conexão tá OK. Problema é outro (navegador, firewall, etc.)

5. Reiniciar o roteador? (30 segundos desligado)
   → "Tô sem internet" = "Já reiniciei o roteador?" — pergunta obrigatória!
```

### Checklist Final

```
☐ Cabo de rede/conexão fibra tá firme?
☐ Roteador reiniciado? (30 segundos desligado)
☐ Wi-Fi conectado? (esqueceu a senha?)
☐ Gateway responde ping?
☐ DNS funciona?
☐ Provedor não tá em manutenção? (ligar lá)
```

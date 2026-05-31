# 🌐 Rede de Computadores — Guia Completo

> Do ping ao BGP. Tudo que o HelpDesk precisa pra diagnosticar e resolver problemas de rede.
> Atualizado: 31/05/2026

---

## 🟢 NÍVEL 1 — Fundamentos

### Modelo OSI (decoreba essencial)

```
7. Aplicação     → HTTP, SMTP, DNS, FTP    (dados que o usuário vê)
6. Apresentação  → SSL/TLS, ASCII, JPEG    (tradução e criptografia)
5. Sessão        → NetBIOS, RPC, SMB       (controle de diálogo)
4. Transporte    → TCP, UDP                (entrega confiável ou não)
3. Rede          → IP, ICMP, ARP           (roteamento e endereçamento)
2. Enlace        → MAC, VLAN, Switch       (quadros entre dispositivos)
1. Física        → Cabo, Wi-Fi, fibra      (bits no fio/ar)
```

**Mnemônico:** **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing
**Mnemônico reverso:** **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way

**Regra de troubleshooting:** Sempre cheque de baixo pra cima (camada 1 primeiro!)

### TCP/IP Stack (modelo prático)
```
Aplicação  → HTTP, DNS, DHCP, SMTP
Transporte → TCP (garantido), UDP (rápido)
Internet   → IP (endereçamento), ICMP (ping)
Acesso     → Ethernet, Wi-Fi
```

### Endereçamento IP

```
IPv4: 192.168.1.100 / 255.255.255.0 (máscara)
CIDR: 192.168.1.100/24

Classes (histórico, mas ainda aparece):
A: 1.0.0.0    a 126.255.255.255    /8
B: 128.0.0.0  a 191.255.255.255    /16
C: 192.0.0.0  a 223.255.255.255    /24

IPs privados (NÃO roteáveis na internet):
10.0.0.0/8        → 10.x.x.x
172.16.0.0/12     → 172.16.x.x a 172.31.x.x
192.168.0.0/16    → 192.168.x.x

Loopback: 127.0.0.1 (localhost)
APIPA: 169.254.x.x (auto-atribuído quando DHCP falha)
```

### Sub-redes (essencial pra HelpDesk)
```
/24 = 255.255.255.0  → 254 hosts (padrão doméstico)
/23 = 255.255.254.0  → 510 hosts
/22 = 255.255.252.0  → 1022 hosts
/16 = 255.255.0.0    → 65.534 hosts (empresa grande)

Quer 50 IPs? → /26 = 255.255.255.192 = 62 hosts
Quer 200 IPs? → /24 = 255.255.255.0 = 254 hosts
```

---

## 🟡 NÍVEL 2 — Protocolos Essenciais

### DHCP — Dynamic Host Configuration Protocol
```
Cliente → DHCPDISCOVER (broadcast: "Alguém me dá um IP?")
Servidor → DHCPOFFER ("Toma, usa 192.168.1.50")
Cliente → DHCPREQUEST ("Ok, vou usar esse!")
Servidor → DHCPACK ("Confirmado, lease de 24h")
```

```cmd
ipconfig /release      # Libera o IP atual
ipconfig /renew        # Pede novo IP
ipconfig /all          # Vê tudo: IP, máscara, gateway, DNS, lease
```

### DNS — Domain Name System
```
Resolução: google.com → 142.250.217.78
Tipos de registro:
A        → nome → IPv4
AAAA     → nome → IPv6
CNAME    → alias → nome canônico
MX       → servidor de email
TXT      → texto (SPF, DKIM, verificação)
PTR      → IP → nome (reverso)
NS       → servidor DNS do domínio
```

```cmd
nslookup google.com        # Resolução básica
nslookup -type=MX gmail.com  # Servidores de email
ipconfig /displaydns       # Cache DNS local
ipconfig /flushdns         # Limpar cache
```

### ARP — Address Resolution Protocol
```
IP → MAC. Ex: "Quem tem 192.168.1.1? Manda MAC!"
```

```cmd
arp -a                    # Tabela ARP (IP → MAC)
arp -d 192.168.1.1       # Limpar entrada específica
```

### NAT — Network Address Translation
```
Rede interna (privada) → Roteador (traduz) → Internet (IP público)

Tipos:
- SNAT: Vários IPs privados → 1 IP público (casa/empresa)
- PAT (Port Address Translation): SNAT com portas diferentes
- CGNAT: Operadora faz NAT (seu IP público ≠ IP real na internet)
```

---

## 🔥 NÍVEL 3 — Wi-Fi Profundo

### Padrões
```
Wi-Fi 4 (802.11n)  → 2.4/5 GHz, até 600 Mbps
Wi-Fi 5 (802.11ac) → 5 GHz, até 6.9 Gbps
Wi-Fi 6 (802.11ax) → 2.4/5 GHz, até 9.6 Gbps
Wi-Fi 6E            → Adiciona 6 GHz
Wi-Fi 7 (802.11be)  → Multi-link, até 46 Gbps
```

### Canais 2.4 GHz (só 3 não-sobrepostos!)
```
Canal 1  → 2401-2423 MHz
Canal 6  → 2426-2448 MHz   ← São os únicos que não interferem
Canal 11 → 2451-2473 MHz

NUNCA use canais 2,3,4,5,7,8,9,10 em 2.4 GHz!
```

### Canais 5 GHz (muitos, sem sobreposição)
```
36-48   → Baixo (UNII-1)
52-64   → Médio (UNII-2) — requer DFS!
100-144 → Alto (UNII-2e)
149-165 → Muito alto (UNII-3)
```

### Problemas comuns de Wi-Fi
```
Sinal fraco (RSSI)        → <-70 dBm = ruim, < -80 dBm = inutilizável
Interferência             → Microondas, Bluetooth, vizinhos
DFS (Dynamic Freq. Selection) → Canal 52-64/100-144 pode mudar sozinho
Canais congestionados     → Muitos APs no mesmo canal
Obstáculos                → Concreto, metal, espelhos = morte do Wi-Fi
```

```cmd
:: Diagnóstico Wi-Fi no Windows
netsh wlan show interfaces        # Sinal, canal, velocidade, BSSID
netsh wlan show networks mode=bssid  # Todas redes + canais
netsh wlan show wlanreport        # Relatório completo (HTML)
```

### Força do sinal (RSSI)
```
-30 dBm   → Excelente (colado no roteador)
-50 dBm   → Muito bom
-60 dBm   → Bom
-70 dBm   → OK (limite pra streaming)
-80 dBm   → Ruim (vai cair)
-90 dBm   → Inútil
```

---

## ⚡ NÍVEL 4 — Troubleshooting Jedi

### Metodologia — Sempre nesta ordem:

```
1. Camada 1 (FÍSICA): Cabo conectado? LED piscando? Wi-Fi ligado?
2. Camada 2 (ENLACE): MAC address visível? Switch reconhece?
3. Camada 3 (REDE): IP válido? Gateway pinga? DNS funciona?
4. Camada 4 (TRANSPORTE): Porta aberta? Firewall bloqueando?
5. Camada 7 (APLICAÇÃO): App configurado certo? Proxy?
```

### Sequência de diagnóstico — O Ritual

```cmd
:: 1. VER O QUE TEM
ipconfig /all

:: 2. IP VÁLIDO?
::    Se 169.254.x.x → DHCP falhou!
::    Se 0.0.0.0 → cabo desplugado!

:: 3. GATEWAY RESPONDE?
ping 192.168.15.1          # ou seu gateway

:: 4. INTERNET RESPONDE?
ping 8.8.8.8               # Google DNS (sempre no ar)

:: 5. DNS FUNCIONA?
nslookup google.com        # Se falhar mas ping 8.8.8.8 ok → DNS quebrado

:: 6. ROTA ESTÁ COMPLETA?
tracert 8.8.8.8            # Onde o salto para? Ali é o problema

:: 7. PACOTES CHEGAM NO DESTINO?
# Usar Wireshark ou:
pathping 8.8.8.8           # Combina ping + tracert + perda de pacotes
```

```powershell
# Reset completo de rede (martelo grande)
netsh winsock reset
netsh int ip reset
netsh winhttp reset proxy
ipconfig /flushdns
ipconfig /release
ipconfig /renew
# REINICIAR depois
```

### Interpretação de Resultados

| Cenário | Diagnóstico |
|---------|-------------|
| ping gateway OK, ping 8.8.8.8 OK, mas sites não abrem | DNS quebrado |
| ping gateway OK, ping 8.8.8.8 falha | Problema no modem/operadora |
| ping gateway falha | Rede local quebrada (switch, cabo, Wi-Fi) |
| IP 169.254.x.x | DHCP não respondeu |
| ping OK mas muito lento (>50ms no gateway) | Interferência Wi-Fi ou cabo ruim |
| tracert mostra * * * após salto X | Ali tá o bloqueio |

---

## 🛠️ Comandos de Rede no Windows

### Diagnóstico
```cmd
ipconfig /all                 # TUDO sobre interfaces
ping -t 8.8.8.8               # Ping contínuo (Ctrl+C pra parar)
ping -n 100 -l 1500 8.8.8.8   # 100 pings de 1500 bytes (teste de MTU)
tracert -d 8.8.8.8            # Tracert sem resolver DNS (mais rápido)
pathping 8.8.8.8              # Estatísticas de cada salto
netstat -ano                  # Todas conexões + PID do processo
netstat -b                    # Conexões + executável
nslookup -debug google.com    # Resolução DNS detalhada
telnet 192.168.1.1 80         # Teste de porta (precisa habilitar cliente Telnet)
```

```powershell
# Testar porta (PowerShell, sem telnet)
Test-NetConnection 192.168.1.1 -Port 80
Test-NetConnection google.com -Port 443

# Diagnóstico completo de rede
Get-NetAdapter | Select Name,Status,LinkSpeed,MacAddress
Get-NetIPAddress | Where-Object AddressFamily -eq IPv4 | Select InterfaceAlias,IPAddress,PrefixLength
Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select NextHop,InterfaceAlias
Get-DnsClientServerAddress | Select InterfaceAlias,ServerAddresses

# Testar conectividade completa
Test-Connection -ComputerName 8.8.8.8 -Count 10 | Select Address,ResponseTime
```

---

## 🎯 Problemas Comuns e Soluções

### "Internet não funciona"

**Sintoma:** Navegador não abre nada.
```cmd
# Check 1: IP válido?
ipconfig | findstr /i "IPv4"
# Se 169.254 → DHCP falhou: ipconfig /renew

# Check 2: Gateway pinga?
ping 192.168.15.1
# Se falha → roteador/cabo/Wi-Fi: verificar conexão física

# Check 3: Internet pinga?
ping 8.8.8.8
# Se OK mas sites não abrem → DNS! nslookup google.com

# Check 4: Proxy?
netsh winhttp show proxy
# Se configurado e não deveria: netsh winhttp reset proxy
```

### "Wi-Fi conecta mas não tem internet"

```
1. Esquecer rede + reconectar
2. ipconfig /release && ipconfig /renew
3. netsh wlan show interfaces → ver RSSI (se <-75 dBm, sinal fraco)
4. Mudar de banda (5 GHz → 2.4 GHz ou vice-versa)
5. Desabilitar/abilitar adaptador
6. Router: verificar canal, reiniciar
```

### "Internet lenta"

```cmd
# 1. Verificar latência até gateway (deve ser <5ms no cabo, <15ms Wi-Fi)
ping -n 20 192.168.15.1

# 2. Verificar perda de pacotes
pathping 8.8.8.8

# 3. Verificar DNS lento
nslookup google.com    # Quanto tempo demora?

# 4. Wi-Fi: trocar canal (usar WiFi Analyzer pra achar canal livre)
```

### "Não acessa servidor X na rede"

```cmd
# Testar: ping, depois porta
ping 192.168.1.50
Test-NetConnection 192.168.1.50 -Port 445  # SMB
Test-NetConnection 192.168.1.50 -Port 3389 # RDP

# Se ping OK mas porta falha:
# → Firewall do Windows, firewall do servidor, serviço parado
Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object {$_.LocalPort -eq 445}
```

### "VPN não conecta"

```cmd
# 1. Tá resolvendo o nome do servidor?
nslookup vpn.empresa.com.br

# 2. Portas abertas?
Test-NetConnection vpn.empresa.com.br -Port 443   # SSTP/SSL
Test-NetConnection vpn.empresa.com.br -Port 1723  # PPTP
Test-NetConnection vpn.empresa.com.br -Port 500   # IKEv2 (UDP!)
Test-NetConnection vpn.empresa.com.br -Port 4500  # IKEv2 NAT-T (UDP!)

# 3. Firewall bloqueando?
netsh advfirewall show allprofiles
```

---

## 📡 Conceitos Avançados

### MTU — Maximum Transmission Unit
```
Tamanho máximo do pacote sem fragmentar. Padrão: 1500 bytes (Ethernet).

Problema: VPN/PPPoE usa cabeçalho extra → MTU efetivo < 1500
Solução: descobrir MTU ideal
ping -f -l 1472 8.8.8.8    # -f = não fragmentar, -l = tamanho
                              # Se "Packet needs to be fragmented" → diminuir
                              # 1472 + 28 (cabeçalho IP/ICMP) = 1500

MTU comum em fibra: 1500
MTU comum em ADSL/VPN: 1492 ou 1450
```

### DNS Avançado
```
DNS público rápido:
Google:   8.8.8.8 / 8.8.4.4
Cloudflare: 1.1.1.1 / 1.0.0.1
Quad9:    9.9.9.9

DNSSEC → Segurança, evita envenenamento
DNS over HTTPS (DoH) → DNS criptografado via HTTPS
DNS over TLS (DoT) → DNS criptografado via TLS
```

### VLAN (Virtual LAN)
```
Separa redes logicamente no mesmo switch físico
Ex: VLAN 10 = TI, VLAN 20 = Vendas, VLAN 30 = Visitantes
Tag: 802.1Q
```

---

## 🔒 Firewall do Windows — Comandos Úteis

```powershell
# Perfis
Get-NetFirewallProfile | Select Name,Enabled

# Regras bloqueando
Get-NetFirewallRule -Action Block -Enabled True | Select DisplayName,Direction

# Liberar porta
New-NetFirewallRule -DisplayName "MeuApp" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow

# Bloquear programa
New-NetFirewallRule -DisplayName "BloqX" -Direction Outbound -Program "C:\app.exe" -Action Block

# Restaurar padrão (CUIDADO!)
netsh advfirewall reset
```

---

## 🎯 Playbooks de Rede pra PC Resolve

### Script de Diagnóstico Rápido
```powershell
function Test-NetworkHealth {
    $gw = (Get-NetRoute -DestinationPrefix '0.0.0.0/0').NextHop
    $dns = (Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.ServerAddresses.Count -gt 0}).ServerAddresses -join ', '
    
    Write-Host "=== DIAGNÓSTICO DE REDE ===" -Foreground Cyan
    Write-Host "Gateway: $gw"
    Write-Host "DNS: $dns"
    
    # Gateway
    $gwPing = Test-Connection $gw -Count 2 -Quiet
    Write-Host "Gateway ($gw): $(if($gwPing){'✅ OK'}else{'❌ FALHOU'})"
    
    # Internet
    $netPing = Test-Connection 8.8.8.8 -Count 2 -Quiet
    Write-Host "Internet (8.8.8.8): $(if($netPing){'✅ OK'}else{'❌ FALHOU'})"
    
    # DNS
    try { [System.Net.Dns]::GetHostEntry("google.com") | Out-Null; Write-Host "DNS: ✅ OK" }
    catch { Write-Host "DNS: ❌ FALHOU" }
    
    # Wi-Fi (se aplicável)
    $wifi = netsh wlan show interfaces 2>$null | Select-String "Signal"
    if ($wifi) { Write-Host $wifi }
    
    # Adaptadores
    Get-NetAdapter | Where-Object Status -eq Up | Select Name,LinkSpeed | ForEach-Object {
        Write-Host "Adaptador: $($_.Name) @ $($_.LinkSpeed)"
    }
}
```

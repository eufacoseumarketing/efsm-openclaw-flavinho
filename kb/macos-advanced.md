# 🍎 macOS: Backup, Recovery, Rede, Segurança

> Time Machine, Recovery Mode, Wi-Fi, AirDrop, Gatekeeper, SIP, TCC, XProtect.
> Atualizado: 31/05/2026

---

## 💾 Time Machine (Backup Nativo)

```bash
# Ativar: System Settings → Geral → Time Machine → Adicionar Disco
# Disco precisa ser HFS+ ou APFS, dedicado (ideal: 2x o tamanho do disco interno)

# Entrar no Time Machine: Menu Bar → ícone do relógio → Entrar no Time Machine

# Forçar backup:
tmutil startbackup

# Verificar status:
tmutil status
```

**Restaurar arquivo:** Entrar Time Machine → navegar no tempo → selecionar → Restaurar

---

## 🚑 Recovery Mode (Modo de Recuperação)

```
Intel Mac:    Cmd+R durante boot
Apple Silicon: Desligar → segurar botão power → Opções → Continuar

Recovery tem:
- Restaurar do Time Machine
- Reinstalar macOS (NÃO apaga dados)
- Safari (pra pesquisar ajuda)
- Disk Utility (reparar/apagar disco)
- Terminal (comandos avançados)
- Startup Security Utility (Apple Silicon)
```

### Trocar senha esquecida pelo Recovery
```bash
# Terminal no Recovery:
resetpassword
# Interface gráfica abre → selecionar usuário → nova senha
```

---

## 🌐 Rede no macOS

### Diagnóstico

```bash
# Wi-Fi
networksetup -listallhardwareports
networksetup -getairportnetwork en0
airport -I                 # Info detalhada do Wi-Fi

# Ping (infinito no Mac!)
ping -c 4 google.com

# DNS
scutil --dns
dscacheutil -flushcache    # Limpar cache DNS

# TCP/IP
ifconfig en0
```

### AirDrop

```
Problema: "AirDrop não aparece o dispositivo"

Requisitos:
- Ambos Wi-Fi e Bluetooth LIGADOS (nos dois dispositivos)
- AirDrop: Finder → AirDrop → "Permitir ser descoberto por: Todos"
- Distância < 9 metros
- iPhone: Wi-Fi e Bluetooth ligados, tela desbloqueada
```

---

## 🔒 Segurança no macOS

### Gatekeeper
```bash
# Ver estado
spctl --status
```

### SIP (System Integrity Protection)
```bash
# Verificar (Recovery Mode → Terminal)
csrutil status

# ⚠️ Desabilitar (SÓ pra apps muito específicos):
csrutil disable
# REABILITE depois: csrutil enable
```

### Firewall
```bash
# Ativar/desativar
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Ver status
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
```

### TCC (Privacidade)
```bash
# Resetar permissões de app específico
tccutil reset Camera
tccutil reset Microphone
tccutil reset All com.nomedoapp
```

---

## 🛠️ Troubleshooting — Playbooks

### Mac não liga
```
1. Verificar carregador (LED laranja/verde?)
2. Apple Silicon: segurar power 10 segundos → soltar → ligar
3. Intel: shift+control+option+power (reset SMC)
4. Recovery → Disk Utility → reparar disco
```

### Mac lento
```
1. Activity Monitor → CPU/Memory → quem tá consumindo?
2. Fechar apps pesados
3. Reiniciar (resolve mais do que deveria)
4. Verificar espaço em disco (>20 GB livre?)
5. Spotlight reindexando? (mdutil -E /)
```

### App não responde
```
1. Cmd+Option+Esc → Selecionar app → Forçar Encerrar
2. Activity Monitor → app → ⓧ → Forçar Encerrar
3. Terminal: killall NomeDoApp
```

### Safari/Chrome lento
```
1. Safari → Preferências → Avançado → "Mostrar menu Desenvolvedor"
   → Desenvolvedor → Limpar Caches
2. Chrome → chrome://settings → "Redefinir e limpar"
```

---

## 🎯 Apple Ecosystem — Problemas Comuns

```
Handoff (continuar no Mac o que fazia no iPhone):
- Ambos mesmo Apple ID, Wi-Fi e Bluetooth ligados
- System Settings → Geral → AirDrop & Handoff → "Permitir Handoff"

Universal Clipboard (copiar no iPhone, colar no Mac):
- Mesmas condições do Handoff + macOS Sierra+

"iPhone não aparece no Finder":
- Cabo USB original/conectado direito
- iPhone desbloqueado, "Confiar neste computador"
- Finder → Preferências → "Mostrar CDs, DVDs e dispositivos iOS"
```

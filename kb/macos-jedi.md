# 🍎⚡ macOS Nível Jedi — Guia Avançado

> Kernel, launchd profundo, NVRAM, TCC, SIP, Recovery tricks, diagnóstico hardcore.
> Atualizado: 31/05/2026

---

## 🧬 Boot — O Caminho Completo

### Apple Silicon (M1-M4) — iBoot

```
1. Boot ROM → carrega iBoot (1º estágio)
2. iBoot → verifica assinatura do kernel
3. Kernel (XNU) → carrega kexts, monta APFS
4. launchd (PID 1) → inicia TUDO
5. loginwindow → tela de login

Recovery: Apple Silicon NUNCA perde o recoveryOS
(boot ROM tem recovery mínimo gravado em hardware)
```

### Intel — EFI

```
1. EFI firmware → POST → handoff
2. boot.efi → carrega kernel
3. Kernel (XNU) → kexts, APFS
4. launchd → sistema
5. loginwindow → tela de login
```

### Diagnosticar boot lento

```bash
# Ver tempo de boot
log show --predicate 'eventMessage contains "BOOT_TIME"' --last 1h

# Ou:
sysctl kern.boottime
uptime  # Subtrair do horário atual = quando bootou
```

---

## 🧠 launchd — Anatomia Jedi

```bash
# launchd = PID 1. Controla TUDO no macOS.
# Domínios:
# System  → /System/Library/LaunchDaemons/
# Global  → /Library/LaunchDaemons/ + /Library/LaunchAgents/
# User    → ~/Library/LaunchAgents/

# Listar carregados por domínio
launchctl print system
launchctl print user/$(id -u)
launchctl print gui/$(id -u)

# Diagnosticar: quem matou o Finder?
launchctl blame gui/$(id -u)/com.apple.Finder

# Verificar se um LaunchAgent está ativo
launchctl list | grep nomedoservico

# Forçar reinício de serviço do sistema
sudo launchctl kickstart -k system/com.apple.audio.coreaudiod

# Bootstrap (carregar serviço desabilitado)
sudo launchctl bootstrap system /Library/LaunchDaemons/com.empresa.agent.plist

# Bootout (remover completamente)
sudo launchctl bootout system /Library/LaunchDaemons/com.empresa.agent.plist

# Habilitar/Desabilitar permanentemente
sudo launchctl enable system/com.empresa.agent
sudo launchctl disable system/com.empresa.agent
```

### Onde serviços quebrados se escondem

```bash
# Serviços com status ≠ 0 (erro!)
launchctl list | grep -v "^-\|^PID" | awk '$2!=0'

# Agentes/daemons de terceiros (NÃO Apple)
ls /Library/LaunchDaemons/ | grep -v apple
ls /Library/LaunchAgents/ | grep -v apple
ls ~/Library/LaunchAgents/ | grep -v apple
```

---

## 📜 NVRAM — Memória Não-Volátil

```bash
# NVRAM armazena configurações entre boots
# Intel: Cmd+Opt+P+R (reset)
# Apple Silicon: NÃO TEM reset manual (faz parte do processo)

# Ver variáveis
nvram -p

# Variáveis comuns problemáticas:
nvram boot-args              # Argumentos do kernel
nvram -d boot-args           # Limpar
sudo nvram StartupMute=%01   # Silenciar som de boot

# Limpar variável específica
sudo nvram -d nome_da_variavel

# Reset completo NVRAM (Intel):
# Desligar → Cmd+Opt+P+R → segurar até 2º boot
```

---

## 🔐 SIP — System Integrity Protection

```bash
# SIP protege /System, /usr (exceto /usr/local), /bin, /sbin

# Verificar status (Recovery → Terminal)
csrutil status

# Componentes do SIP (cada um pode ser desabilitado individualmente):
csrutil enable --without fs          # Filesystem protection
csrutil enable --without kext        # Kext signing
csrutil enable --without nvram       # NVRAM protection
csrutil enable --without debug       # Debugging restrictions
csrutil enable --without dtrace      # DTrace restrictions

# Habilitar TUDO (padrão)
csrutil clear
```

⚠️ **SIP desligado = apps podem modificar arquivos do sistema = perigo.**

---

## 🔬 TCC — Internals Jedi

```bash
# Transparency, Consent, and Control
# Banco de dados: /Library/Application Support/com.apple.TCC/TCC.db
# (criptografado, não editável diretamente)

# Ver permissões de um app específico
sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
  "SELECT service, client, auth_value FROM access WHERE client LIKE '%Spotify%';"

# Resetar permissões por categoria
tccutil reset Camera com.zoom.us
tccutil reset Microphone
tccutil reset ScreenCapture
tccutil reset All           # CUIDADO! Perde TUDO!

# Full Disk Access (a permissão suprema):
# System Settings → Privacidade → Acesso Total ao Disco
# Apps que precisam: antivírus, backup, limpeza
```

---

## 🧪 Kernel Extensions (kexts)

```bash
# Listar kexts carregadas
kextstat

# Kexts de terceiros (NÃO Apple)
kextstat | grep -v com.apple

# Desde Big Sur, kexts = deprecated
# Apple prefere System Extensions (mais seguras)

# Verificar System Extensions
systemextensionsctl list

# Kext problemática (causa de kernel panic)?
# Buscar nos crash logs:
ls ~/Library/Logs/DiagnosticReports/Kernel*
```

---

## 💀 Kernel Panic — O equivalente a BSOD

```bash
# Logs de kernel panic
ls ~/Library/Logs/DiagnosticReports/Kernel*
# Nome do arquivo: Kernel-YYYY-MM-DD-HHMMSS.panic

# Analisar último crash
cat ~/Library/Logs/DiagnosticReports/Kernel-*.panic | grep "Kernel Extensions in backtrace"

# Se tiver kext de terceiro no backtrace = CULPADO!
```

### Panic comum: "SOCD report detected: (AP watchdog expired)"
```
= Apple Silicon watchdog timeout
= CPU morreu ou kernel travou
= Causa comum: sleep/wake, hardware bridge, Thunderbolt
= Se recorrente → hardware → Apple Support
```

---

## 🛠️ Recovery Mode — Truques Avançados

### Apple Silicon — Opções Escondidas

```
Desligar → segurar power → Opções:
- Startup Security Utility: reduzir segurança (permitir kexts, boot externo)
- Terminal no Recovery (comandos Jedi abaixo)
- Reinstall macOS (NÃO apaga dados, desde que APFS)
- Restore do Time Machine
- Safari (pra pesquisar no Google o erro!)

Reduzir segurança de boot:
Recovery → Startup Security Utility → 
"Permitir extensões de kernel de desenvolvedores"
"Permitir mídia de inicialização externa"
```

### Terminal Jedi no Recovery

```bash
# Montar disco (se não estiver)
diskutil list
diskutil mountDisk /dev/diskX

# Reparar APFS
fsck_apfs -fy /dev/diskXsY

# Verificar/Restaurar ACL de permissões
chmod -R -N ~/
diskutil resetUserPermissions / $(id -u)

# Deletar arquivo que impede boot
rm -rf "/Volumes/Macintosh HD - Dados/Users/usuario/Library/Caches/*"

# Recriar usuário corrompido (sem perder dados)
# https://support.apple.com/guide/mac-help/mchlp1145/mac

# Verificar o que ocupa espaço (pode impedir boot)
du -sh "/Volumes/Macintosh HD - Dados/"*
```

### Reinstall macOS sem perder dados

```
Recovery → Reinstall macOS → Selecionar "Macintosh HD"
= Baixa ~12 GB, instala em cima
= NÃO apaga dados, NÃO apaga apps, NÃO apaga configurações
= Corrige sistema corrompido mantendo tudo do usuário
```

---

## 🧩 Disk Utility — Jedi

```bash
# Listar discos detalhado
diskutil list internal / external

# Info completa de um volume APFS
diskutil apfs list

# Verificar volume (read-only, seguro)
diskutil verifyVolume /

# Reparar volume (precisa desmontar!)
diskutil repairVolume /

# Adicionar volume APFS (não particiona, compartilha espaço!)
diskutil apfs addVolume diskXsY APFS "NomeVolume"

# Apagar disco (CUIDADO!)
diskutil erasedisk APFS "Nome" diskX

# Secure Erase (SSD)
diskutil secureErase 0 diskX    # Rápido
diskutil secureErase 4 diskX    # 7-pass (HDD apenas, SSD NÃO!)
```

---

## 🎯 Playbooks Jedi

### "Mac não boota, tela preta com ?"
```
= Não acha disco de boot

1. Recovery → Disk Utility → disco aparece?
   Se SIM → reparar
   Se NÃO → disco morreu ou desconectou
2. Startup Disk → selecionar Macintosh HD
3. Reinstall macOS (não apaga dados)
```

### "Kernel panic frequente"
```
1. Desconectar TUDO (USB, Thunderbolt, monitor externo)
2. Ver ~/Library/Logs/DiagnosticReports/
3. Últimas kexts no backtrace = suspeito
4. Safe Mode (Shift durante boot): funciona?
   Se SIM → problema é software de terceiro
5. EtreCheck → escaneia e lista possíveis causas
```

### "Sistema usando MUITO espaço misterioso"
```bash
# Analisar com DaisyDisk/GrandPerspective
# Ou linha de comando:
sudo du -sh /Users/*/.Trash
sudo du -sh ~/Library/Caches
sudo du -sh ~/Library/Application\ Support/Code/Cache
sudo du -sh /Library/Updates
sudo du -sh /System/Volumes/Data/.cleansups

# Snapshots do Time Machine (locais, comem espaço!)
tmutil listlocalsnapshots /
sudo tmutil deletelocalsnapshots /
```

### "Mouse/Teclado Bluetooth não conecta"
```bash
# Resetar módulo Bluetooth (Intel):
sudo pkill bluetoothd

# Ou:
sudo rm -f /Library/Preferences/com.apple.Bluetooth.plist
# Reiniciar

# Apple Silicon: não tem como resetar BT separadamente, só reiniciar
```

---

## 🧘 Dicas Finais do Mestre

- **Reinstall macOS não apaga dados.** É o "sfc /scannow" do Mac. Sempre tente antes de formatar!
- **Safe Mode (Shift no boot)** limpa caches e desabilita terceiros. Testa antes de qualquer diagnóstico complexo.
- **Apple Diagnostics (D no boot)** testa hardware. Se falhar = problema físico.
- **Console.app** é o Event Viewer do Mac. Tudo que o sistema faz tá lá.
- **log show --last 15m | grep -i error** = diagnóstico instantâneo.
- **Nunca delete arquivos do sistema.** Diferente do Windows, o sistema é read-only. Se tá mexendo em /System, já fez besteira.
- **SIP desligado + sudo sem saber o que faz = Mac brickado.** Respeite o SIP.

# ⚙️ macOS Terminal & Unix — Guia HelpDesk

> Comandos shell, brew, launchd, diagnóstico por linha de comando.
> Atualizado: 31/05/2026

---

## 🟢 Terminal Básico

### Shell padrão: zsh (desde Catalina)

```bash
# Navegação
pwd                        # Onde estou?
ls -la                     # Listar tudo (inclusive ocultos)
cd ~/Downloads             # Ir pra pasta
open .                     # Abrir pasta atual no Finder
open arquivo.pdf           # Abrir arquivo com app padrão

# Arquivos
cp -r origem destino       # Copiar (recursivo)
mv origem destino          # Mover/renomear
rm -rf pasta/              # Deletar (CUIDADO! Sem lixeira!)
mkdir -p caminho/pasta     # Criar pasta (pais também)
touch arquivo.txt          # Criar arquivo vazio
cat arquivo.txt            # Ver conteúdo
less arquivo.txt           # Ver com scroll (q pra sair)
tail -f log.txt            # Ver últimas linhas em tempo real
```

---

## 🟢 Diagnóstico via Terminal

```bash
# Sistema
sw_vers                                # Versão do macOS
uname -a                               # Kernel, arquitetura
sysctl -n machdep.cpu.brand_string     # CPU
sysctl hw.memsize                      # RAM total (bytes)
system_profiler SPHardwareDataType     # Hardware completo

# Processos (similar ao Get-Process)
ps aux | grep nomeprocesso
top                  # Activity Monitor em texto (q pra sair)
htop                 # Mais bonito (brew install htop)

# Disco
df -h                # Espaço em disco
du -sh *             # Tamanho de cada pasta
diskutil list        # Listar discos e partições

# Rede
ifconfig             # Interfaces de rede
netstat -an          # Conexões ativas
ping -c 4 google.com # Ping (4 pacotes, ≠ Windows que é infinito)
nslookup google.com  # DNS
dscacheutil -flushcache  # Limpar cache DNS

# Logs
log show --last 1h   # Logs da última hora
log stream           # Logs em tempo real (Ctrl+C pra parar)

# Bateria (MacBook)
pmset -g batt        # Status da bateria
pmset -g stats       # Estatísticas
system_profiler SPPowerDataType | grep "Cycle Count"  # Ciclos
```

---

## 🔥 Homebrew — O "Winget" do Mac

```bash
# Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Comandos essenciais
brew search firefox       # Procurar
brew install firefox      # Instalar
brew uninstall firefox    # Remover
brew update               # Atualizar fórmulas
brew upgrade              # Atualizar tudo instalado
brew list                 # Listar instalados
brew doctor               # Diagnosticar problemas

# Casks (apps GUI)
brew install --cask google-chrome
brew install --cask visual-studio-code
brew install --cask spotify
```

---

## ⚡ launchd — O "services.msc" do Mac

```bash
# launchd controla TODOS os serviços/daemons no macOS
# NÃO tem services.msc!

# Ver o que tá rodando
launchctl list

# Carregar/descarregar serviços
launchctl load /System/Library/LaunchDaemons/com.apple.nomedoservico.plist
launchctl unload /System/Library/LaunchDaemons/com.apple.nomedoservico.plist

# Onde ficam:
# /System/Library/LaunchDaemons/    → Sistema
# /Library/LaunchDaemons/           → Todos usuários
# ~/Library/LaunchAgents/           → Seu usuário

# Exemplo: reiniciar servico de rede
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
```

---

## 🎯 defaults — O "Registry" do Mac

```bash
# macOS não tem registry! Configurações são arquivos .plist
# defaults lê/escreve preferências

# Ler
defaults read com.apple.finder

# Escrever (ex: mostrar arquivos ocultos no Finder)
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder    # Aplicar

# Ex: mostrar extensões de arquivo
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Ex: mostrar caminho completo no Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Deletar preferência (reset)
defaults delete com.apple.finder AppleShowAllFiles

# Onde os .plist ficam:
# ~/Library/Preferences/    → Preferências de apps
# /Library/Preferences/     → Preferências do sistema
```

---

## 🛠️ Comandos de Manutenção

```bash
# Reindexar Spotlight (quando busca não funciona)
sudo mdutil -E /

# Verificar/Reparar disco (APFS)
diskutil verifyVolume /
diskutil repairVolume /

# Resetar permissões do disco (Recovery Mode)
# Bootar no Recovery → Terminal → diskutil resetUserPermissions / `id -u`

# Limpar caches (safe)
rm -rf ~/Library/Caches/*

# Verificar integridade do SIP
csrutil status
```

---

## ⚠️ Dicas Jedi

- **sudo** é seu amigo. Tudo que mexe no sistema pede sudo.
- **NÃO tem C:, D: etc.** Tudo começa em `/`. Disco externo = `/Volumes/NomeDoDisco`.
- **Killall** = mata processo por nome (ex: `killall Finder` reinicia o Finder).
- **Ping no Mac é infinito por padrão** (Ctrl+C pra parar). `ping -c 4` pra 4 pacotes.
- **Ctrl+C** = cancelar. **Ctrl+D** = EOF/sair. **Ctrl+Z** = suspender.

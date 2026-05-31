# 🔧 macOS Maintenance & Performance

> Activity Monitor, EtreCheck, limpeza, malware, desempenho.
> Atualizado: 31/05/2026

---

## 🟢 Activity Monitor

```bash
# Abrir: Applications → Utilities → Activity Monitor (ou Cmd+Espaço)
# Equivalente ao Gerenciador de Tarefas do Windows

# Abas:
CPU     → Quem tá comendo processador?
Memory  → RAM usada, Pressão de Memória (Verde=OK, Amarelo=Atenção, Vermelho=CRÍTICO)
Energy  → Quem tá sugando bateria?
Disk    → Leituras/escritas
Network → Uso de rede
```

**Pressão de Memória > Uso de RAM.** Verde é saudável mesmo com RAM "cheia" (macOS usa RAM livre como cache).

### Diagnóstico via Terminal

```bash
# Processos por CPU
ps aux --sort=-%cpu | head -10

# Processos por RAM
ps aux --sort=-%mem | head -10

# Uptime
uptime

# Espaço em disco
df -h

# O que tá ocupando espaço
du -sh ~/Library/Caches ~/Library/Application\ Support ~/Downloads ~/Library/Mail

# Purge (liberar RAM inativa — seguro)
sudo purge
```

---

## 🟢 Limpeza do Sistema

```bash
# Caches (seguro)
rm -rf ~/Library/Caches/*

# Logs antigos
sudo rm -rf /private/var/log/*.gz

# Mail downloads (anexos de email)
rm -rf ~/Library/Mail/V*/**/Attachments/*

# Xcode (se instalado, COME espaço)
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*
```

### Ferramentas de Limpeza

```bash
# OnyX (grátis, confiável) — limpeza completa + scripts manutenção
brew install --cask onyx

# EtreCheck (grátis) — diagnóstico completo do sistema
# https://etrecheck.com

# GrandPerspective / DaisyDisk — visualizar uso de disco
brew install --cask grandperspective
```

---

## 🔥 Malware no Mac

```
XProtect → Antimalware nativo da Apple (silencioso, automático)
MRT (Malware Removal Tool) → Remove malware conhecido
Gatekeeper → Bloqueia apps não assinados

O Mac NÃO é imune a malware! Mas é menos visado.

Ferramentas adicionais:
- Malwarebytes for Mac (grátis)
- DetectX Swift (grátis, focado em ameaças Mac)
```

```bash
# Instalar Malwarebytes
brew install --cask malwarebytes

# Verificar processos suspeitos no launchd
launchctl list | grep -v apple
```

---

## 🟢 Scripts de Manutenção

```bash
# macOS roda scripts de manutenção automaticamente (3:15 AM)
# weekly, daily, monthly — /etc/periodic/

# Rodar manualmente:
sudo periodic daily
sudo periodic weekly
sudo periodic monthly

# Reindexar Spotlight (busca lenta/quebrada)
sudo mdutil -E /
```

---

## ⚠️ Sinais de Alerta

- **Pressão de Memória Amarela/Vermelha** = MUITA RAM em uso. Fechar apps pesados.
- **Kernel_task comendo CPU** = superaquecimento. Refrigeração!
- **Disco quase cheio (<20 GB)** = pode travar tudo. Limpar urgente.
- **Mac MUITO lento do nada** = Spotlight reindexando? Aguardar algumas horas.

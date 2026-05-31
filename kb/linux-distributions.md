# 🐧 Linux Distributions — Guia Completo de Diferenças

> Famílias, package managers, comandos diferentes, paths, init systems, firewalls.
> Atualizado: 31/05/2026

---

## 🗺️ Árvore Genealógica

```
Debian ─────────┬── Debian Stable/Testing/Sid
                ├── Ubuntu (Desktop + Server)
                │   ├── Linux Mint
                │   ├── Pop!_OS
                │   └── elementaryOS
                └── Kali, Raspbian, Proxmox

RHEL ───────────┬── Red Hat Enterprise Linux
                ├── CentOS (até 8) → CentOS Stream
                ├── Fedora
                ├── AlmaLinux (substituto CentOS)
                └── Rocky Linux (substituto CentOS)

Arch ───────────┬── Arch Linux
                ├── Manjaro
                ├── EndeavourOS
                └── SteamOS (Steam Deck)

SUSE ───────────┬── openSUSE Leap
                └── SUSE Linux Enterprise (SLE)

Independentes ──┬── Alpine Linux (Docker!)
                ├── Gentoo (compila tudo)
                ├── NixOS (declarativo)
                └── Void Linux
```

---

## 📦 Package Managers — A Diferença #1

| Distro | Manager | Instalar | Buscar | Remover | Update | Upgrade |
|--------|---------|----------|--------|---------|--------|---------|
| **Debian/Ubuntu** | apt | `apt install` | `apt search` | `apt remove` | `apt update` | `apt upgrade` |
| **RHEL/Fedora** | dnf | `dnf install` | `dnf search` | `dnf remove` | `dnf check-update` | `dnf upgrade` |
| **CentOS 7** | yum | `yum install` | `yum search` | `yum remove` | `yum check-update` | `yum update` |
| **Arch/Manjaro** | pacman | `pacman -S` | `pacman -Ss` | `pacman -R` | `pacman -Sy` | `pacman -Syu` |
| **Alpine** | apk | `apk add` | `apk search` | `apk del` | `apk update` | `apk upgrade` |
| **openSUSE** | zypper | `zypper install` | `zypper search` | `zypper remove` | `zypper refresh` | `zypper update` |

### Exemplos comparativos

```bash
# "Instalar nginx" →
# Ubuntu/Debian:  sudo apt install nginx -y
# Fedora/RHEL:    sudo dnf install nginx -y
# CentOS 7:       sudo yum install nginx -y
# Arch:           sudo pacman -S nginx
# Alpine:         sudo apk add nginx
# openSUSE:       sudo zypper install nginx

# "Atualizar tudo" →
# Ubuntu/Debian:  sudo apt update && sudo apt upgrade -y
# Fedora:         sudo dnf upgrade --refresh -y
# CentOS 7:       sudo yum update -y
# Arch:           sudo pacman -Syu
# Alpine:         sudo apk update && sudo apk upgrade
# openSUSE:       sudo zypper refresh && sudo zypper update
```

---

## ⚙️ Gerenciamento de Serviços

```bash
# Systemd (Ubuntu 16.04+, Debian 8+, RHEL 7+, Fedora, Arch, openSUSE)
systemctl start nginx
systemctl enable nginx
systemctl status nginx

# SysVinit (CentOS 6, Debian 6, sistemas antigos)
/etc/init.d/nginx start
service nginx start
chkconfig nginx on

# OpenRC (Alpine, Gentoo)
rc-service nginx start
rc-update add nginx default
rc-status

# Runit (Void Linux)
sv start nginx
```

⚠️ **Desde 2015, systemd domina.** Mas Docker containers Alpine usam OpenRC. CentOS 7 usa systemd mas com wrappers do yum.

---

## 🔒 Firewalls

| Distro | Ferramenta | Ativar | Permitir porta |
|--------|-----------|--------|---------------|
| **Ubuntu/Debian** | ufw | `ufw enable` | `ufw allow 80/tcp` |
| **RHEL/Fedora/CentOS** | firewalld | `systemctl start firewalld` | `firewall-cmd --add-port=80/tcp --permanent` |
| **Alpine** | iptables direto | - | `iptables -A INPUT -p tcp --dport 80 -j ACCEPT` |
| **Arch** | ufw ou iptables | escolhe | depende do que instalou |

### Comparação lado a lado

```bash
# "Abrir porta 80 e 443" →
# Ubuntu (ufw):
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# RHEL/CentOS (firewalld):
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --reload

# iptables puro (qualquer distro):
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

---

## 🔐 SELinux vs AppArmor

| | SELinux | AppArmor |
|---|---------|----------|
| **Usado por** | RHEL, CentOS, Fedora | Ubuntu, Debian, openSUSE |
| **Verificar** | `getenforce` | `aa-status` |
| **Desabilitar temp** | `setenforce 0` | `systemctl stop apparmor` |
| **Desabilitar perm** | `/etc/selinux/config` → `SELINUX=disabled` | `GRUB_CMDLINE_LINUX="apparmor=0"` |
| **Modo permissivo** | `setenforce 0` | `aa-complain /path/to/bin` |
| **Ver logs** | `ausearch -m avc` | `dmesg \| grep DENIED` |

⚠️ **NUNCA desabilite permanentemente!** Use modo permissivo/complain pra testar.

---

## 📁 Paths e Arquivos Diferentes

| O que | Ubuntu/Debian | RHEL/CentOS/Fedora | Alpine |
|-------|--------------|-------------------|--------|
| **Apache** | `apache2` | `httpd` | `apache2` |
| **Config Apache** | `/etc/apache2/` | `/etc/httpd/` | `/etc/apache2/` |
| **Config NGINX** | `/etc/nginx/` | `/etc/nginx/` | `/etc/nginx/` |
| **Config SSH** | `/etc/ssh/sshd_config` | `/etc/ssh/sshd_config` | `/etc/ssh/sshd_config` |
| **Logs sistema** | `/var/log/syslog` | `/var/log/messages` | `/var/log/messages` |
| **Network config** | `/etc/netplan/` (18.04+) | `/etc/sysconfig/network-scripts/` | `/etc/network/interfaces` |
| **Shell padrão** | bash | bash | ash/busybox |
| **Root shell** | bash | bash | ash |

---

## 🎯 Alpine Linux — O Diferente (Importante pra Docker!)

```bash
# Alpine = minimalista. MUITO usado em Docker por ser minúsculo (~5MB).

# Package manager: apk (não apt!)
apk add nginx
apk search nginx
apk del nginx

# Shell: BusyBox ash (não bash!)
# Não tem bash por padrão
# Sintaxe diferente: menos features
# Se precisar de bash: apk add bash

# Init: OpenRC (não systemd!)
rc-service nginx start
rc-status

# Não tem useradd padrão
adduser usuario
addgroup grupo

# Não tem systemctl, journalctl, timedatectl
# Logs: /var/log/messages
# Hora: date ou apk add tzdata

# Não tem curl ou wget por padrão em algumas imagens
wget -O - https://...    # Se tiver busybox wget
apk add curl              # Se precisar
```

---

## 🟢 Ubuntu Server vs Desktop — Diferenças

| | Ubuntu Server | Ubuntu Desktop |
|---|--------------|---------------|
| **GUI** | ❌ | ✅ GNOME |
| **Network** | netplan (.yaml) | NetworkManager |
| **Firewall** | ufw (não ativo) | ufw (não ativo) |
| **Instala apps** | apt + snap | apt + snap + App Center |
| **Boot usr/gui** | Não | GDM (login gráfico) |

---

## 🔥 Diferenças Críticas de Comandos

### Comandos com nomes diferentes

| Ação | Ubuntu/Debian | RHEL/CentOS/Fedora |
|------|--------------|-------------------|
| Instalar pacote | `apt install` | `dnf install` |
| Procurar pacote | `apt search` | `dnf search` |
| Qual pacote dono do arquivo? | `dpkg -S /path/file` | `rpm -qf /path/file` |
| Listar pacotes instalados | `dpkg -l` | `rpm -qa` |
| Serviço | `systemctl` | `systemctl` (igual ✅) |
| Firewall | `ufw` | `firewall-cmd` |
| SELinux/AppArmor | `aa-status` | `getenforce` |
| Habilitar serviço | `systemctl enable` | `systemctl enable` (igual ✅) |
| Hostname | `hostnamectl` | `hostnamectl` (igual ✅) |

### Syntax traps

```bash
# grep -P (Perl regex)
# Funciona em Ubuntu/Debian, NÃO funciona no Alpine (busybox grep)
grep -P "\d+" /var/log/syslog    # ❌ Alpine
grep -E "[0-9]+" /var/log/syslog # ✅ Alpine (POSIX regex)

# useradd vs adduser
# Ubuntu/Debian: ambos funcionam (adduser é interativo)
# RHEL: useradd (adduser não existe)
# Alpine: adduser (useradd não existe)

# bash shebang
#!/bin/bash   # ❌ Alpine sem bash instalado
#!/bin/sh     # ✅ Alpine (busybox ash)
```

---

## 🧪 Diagnóstico: "Qual distro é essa?"

```bash
# Método 1: lsb_release (Ubuntu/Debian e derivados)
lsb_release -a

# Método 2: os-release (TODOS modernos)
cat /etc/os-release

# Método 3: Analisar o package manager
which apt && echo "Debian/Ubuntu"
which dnf && echo "Fedora/RHEL 8+"
which yum && echo "RHEL 7/CentOS 7"
which pacman && echo "Arch/Manjaro"
which apk && echo "Alpine"
which zypper && echo "openSUSE"

# Método 4: Arquivos de release
cat /etc/debian_version    # Existe = Debian/Ubuntu
cat /etc/redhat-release    # Existe = RHEL/CentOS/Fedora
cat /etc/alpine-release    # Existe = Alpine
cat /etc/arch-release      # Existe = Arch
```

---

## 🎯 Playbook: "Qual comando usar?"

```
1. cat /etc/os-release → identifica a distro
2. ID_LIKE=debian   → apt, ufw, /etc/apache2/, syslog
   ID_LIKE=rhel     → dnf/yum, firewalld, /etc/httpd/, messages
   ID=alpine         → apk, OpenRC, busybox, /etc/network/interfaces
3. Usar tabela acima pra firewall, serviços, caminhos
```

---

## ⚠️ Resumo de Bolso

| Situação | Debian/Ubuntu | RHEL/Fedora | Alpine |
|----------|--------------|-------------|--------|
| Instalar | `apt install` | `dnf install` | `apk add` |
| Firewall | `ufw` | `firewalld` | `iptables` |
| Serviços | `systemctl` | `systemctl` | `rc-service` |
| Logs | `/var/log/syslog` | `/var/log/messages` | `/var/log/messages` |
| Shell | `bash` | `bash` | `ash` (busybox) |
| SELinux/AppArmor | AppArmor | SELinux | Nenhum |

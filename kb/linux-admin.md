# 🐧 Linux System Administration

> Usuários, permissões, systemd, logs, discos, SSH, firewall, cron.
> Atualizado: 31/05/2026

---

## 👤 Usuários e Grupos

```bash
# Listar
whoami                  # Quem sou eu?
id                      # UID, GID, grupos
who                     # Quem tá logado
last                    # Últimos logins

# Criar usuário
sudo useradd -m -s /bin/bash novousuario
sudo passwd novousuario

# Adicionar a grupo (ex: sudo)
sudo usermod -aG sudo novousuario

# Remover
sudo userdel -r novousuario

# Grupos
groups usuario          # Grupos do usuário
sudo groupadd devs      # Criar grupo
```

---

## ⚙️ systemd — O Coração do Linux Moderno

```bash
# Serviços
systemctl status nginx
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl enable nginx       # Iniciar no boot
systemctl disable nginx      # Não iniciar no boot
systemctl is-enabled nginx
systemctl list-units --type=service

# Logs (journalctl — substitui /var/log/syslog)
journalctl -u nginx          # Logs do serviço
journalctl -u nginx -f       # Seguir (Ctrl+C)
journalctl -u nginx --since "1 hour ago"
journalctl -xe               # Últimos logs + explicação

# Sistema
systemctl list-units --state=failed   # Serviços quebrados
systemctl daemon-reload               # Recarregar units
hostnamectl set-hostname novo-nome    # Mudar hostname
```

---

## 💾 Discos e Montagem

```bash
# Listar discos
lsblk
fdisk -l
df -h

# Montar disco
sudo mount /dev/sdb1 /mnt/disco
sudo umount /mnt/disco

# fstab (montagem automática no boot)
# /etc/fstab
# UUID=xxxx-xxxx /mnt/disco ext4 defaults 0 2

# Verificar UUID
blkid
```

---

## 📜 Logs

```bash
# Logs tradicionais
/var/log/syslog          # Sistema geral (Ubuntu/Debian)
/var/log/messages        # Sistema geral (RHEL)
/var/log/auth.log        # Autenticação (logins, sudo)
/var/log/nginx/          # NGINX
/var/log/mysql/          # MySQL/MariaDB

# Buscar nos logs
tail -f /var/log/syslog                # Tempo real
grep "error" /var/log/syslog           # Erros
grep "Failed password" /var/log/auth.log  # Tentativas de login
```

---

## 🔒 SSH

```bash
# Conectar
ssh usuario@192.168.1.100
ssh -p 2222 usuario@ip     # Porta customizada

# Chave SSH (mais seguro que senha!)
ssh-keygen -t ed25519       # Criar chave
ssh-copy-id usuario@ip      # Copiar pra servidor

# Config (~/.ssh/config)
# Host meuserver
#   HostName 192.168.1.100
#   User flavinho
#   Port 22

# Depois: ssh meuserver (só isso!)
```

---

## 🔥 Firewall (ufw — Ubuntu)

```bash
sudo ufw status
sudo ufw enable
sudo ufw allow 22/tcp           # SSH
sudo ufw allow 80/tcp           # HTTP
sudo ufw allow 443/tcp          # HTTPS
sudo ufw allow from 192.168.1.0/24  # Rede local
sudo ufw deny from 10.0.0.5     # Bloquear IP
sudo ufw delete 3               # Remover regra #3
sudo ufw disable                # Desligar
```

### iptables (avançado)
```bash
sudo iptables -L -n -v          # Listar regras
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

---

## ⏰ Cron — Tarefas Agendadas

```bash
# Editar crontab
crontab -e

# Sintaxe: m h dom mon dow comando
# 0 3 * * * /home/user/backup.sh   → Todo dia às 3h
# */5 * * * * /usr/bin/check.sh     → A cada 5 minutos
# 0 0 1 * * /cleanup.sh             → Dia 1 de cada mês

crontab -l                   # Listar
crontab -r                   # Remover
sudo crontab -e              # Crontab do root
```

---

## 🎯 Diagnóstico Rápido

```bash
# Script de saúde do servidor
echo "=== SERVER HEALTH ==="
echo "Uptime: $(uptime -p)"
echo "RAM: $(free -h | awk '/Mem:/{print $3"/"$2}')"
echo "Disco: $(df -h / | awk 'NR==2{print $3"/"$2" ("$5")"}')"
echo "CPU Load: $(uptime | awk -F'load average:' '{print $2}')"
echo "Serviços falhos: $(systemctl --failed --no-legend | wc -l)"
echo "Últimos logins:"
last -5
```

---

## ⚠️ Dicas Jedi

- **systemd substituiu init.d.** Sempre use `systemctl`, não `/etc/init.d/`.
- **journalctl -xe** mostra logs + explicação do erro. Seu melhor amigo.
- **ufw > iptables** pra 90% dos casos. Sintaxe simples.
- **ssh-copy-id** é o jeito seguro de configurar acesso remoto.
- **tail -f /var/log/syslog** quando algo quebra e você não sabe o que é.

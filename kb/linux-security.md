# 🐧🔒 Linux Security — Guia HelpDesk

> SSH hardening, fail2ban, permissões, firewall, auditoria.
> Atualizado: 31/05/2026

---

## 🔐 SSH Hardening

```bash
# /etc/ssh/sshd_config — hardening recomendado:
Port 2222                          # Mudar porta (reduz ruído)
PermitRootLogin no                 # NUNCA login root via SSH
PasswordAuthentication no          # Só chave SSH (depois de configurar)
PubkeyAuthentication yes
MaxAuthTries 3                     # Máximo 3 tentativas
ClientAliveInterval 300            # Timeout de inatividade

# Aplicar:
sudo systemctl restart sshd
```

---

## 🛡️ fail2ban — Bloqueio de Brute Force

```bash
sudo apt install fail2ban -y

# Config: /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
filter = sshd
maxretry = 5              # Bloquear após 5 tentativas
bantime = 3600            # Banir por 1 hora
findtime = 600            # Janela de 10 minutos

sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# Verificar bans
sudo fail2ban-client status sshd
sudo fail2ban-client unban 192.168.1.100
```

---

## 👁️ Auditoria e Verificação

```bash
# Quem tá logado?
who
w                  # + detalhado (o que tá fazendo)

# Últimos logins
last -20

# Tentativas de login falhas
sudo grep "Failed password" /var/log/auth.log | tail -20

# Sudo usado recentemente
sudo grep "sudo" /var/log/auth.log | tail -20

# Arquivos modificados nas últimas 24h
sudo find /etc -type f -mtime -1

# Processos suspeitos
ps auxf                    # Árvore de processos
ss -tulanp                 # Portas abertas

# Verificar rootkits
sudo apt install chkrootkit rkhunter -y
sudo chkrootkit
sudo rkhunter --check
```

---

## 🧹 Boas Práticas

```bash
# Manter atualizado
sudo apt update && sudo apt upgrade -y
sudo snap refresh             # snaps também

# Usuários
# Remover usuários inativos
sudo userdel -r usuario_inativo
# Ver quem tem acesso sudo
getent group sudo

# Permissões de arquivos sensíveis
sudo chmod 600 /etc/shadow
sudo chmod 644 /etc/passwd

# Desabilitar serviços desnecessários
sudo systemctl list-unit-files | grep enabled
sudo systemctl disable servico_desnecessario
```

---

## ⚠️ Checklist de Segurança

```
☐ SSH: root login desabilitado
☐ SSH: autenticação por chave (não senha)
☐ Firewall ativo (ufw/iptables)
☐ fail2ban configurado
☐ Updates automáticos (unattended-upgrades)
☐ Apenas portas necessárias abertas
☐ Nenhum serviço desnecessário rodando
☐ Backups configurados e testados
```

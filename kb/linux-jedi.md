# 🐧⚡ Linux Nível Jedi

> Kernel, performance, debugging profundo, networking avançado, troubleshooting hardcore.
> Atualizado: 31/05/2026

---

## 🧬 Kernel — O Coração

### Módulos do Kernel

```bash
lsmod                        # Módulos carregados
modinfo nome_modulo          # Info do módulo
sudo modprobe nome_modulo    # Carregar
sudo modprobe -r nome_modulo # Remover (se não em uso)
sudo rmmod nome_modulo       # Remover forçado

# Blacklist (impedir carregar)
echo "blacklist nome_modulo" | sudo tee /etc/modprobe.d/blacklist.conf
```

### Kernel Parameters (sysctl)

```bash
# Ver todos
sysctl -a

# Ajustes comuns
sudo sysctl -w net.core.somaxconn=1024
sudo sysctl -w vm.swappiness=10    # Usar menos swap

# Persistente (/etc/sysctl.conf ou /etc/sysctl.d/)
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-custom.conf
sudo sysctl -p
```

---

## ⚡ Performance — Diagnóstico Profundo

### CPU

```bash
# Load average (1m, 5m, 15m)
uptime
cat /proc/loadavg

# Load > Núcleos = sobrecarga
nproc                    # Quantos cores?

# O QUE está causando CPU alta
top -c                   # Shift+P = ordenar por CPU
htop                     # Mais visual
mpstat -P ALL 1          # Por core
```

### RAM

```bash
free -h
cat /proc/meminfo | grep -E "MemTotal|MemAvailable|Cached|SwapTotal"

# O QUE está usando RAM
ps aux --sort=-%mem | head -10

# Out of Memory (OOM) killer
dmesg | grep -i "out of memory"
dmesg | grep -i "killed process"

# Swapiness: 0 = evitar swap, 100 = usar swap agressivamente
cat /proc/sys/vm/swappiness
```

### Disco I/O

```bash
iostat -x 1               # I/O por disco (precisa sysstat)
iotop                     # I/O por processo
dstat -d                  # Estatísticas de disco

# Latência de disco alta?
iostat -x 1 | awk 'NR>3 && $10>10 {print $1, $10"ms"}'
```

---

## 🌐 Networking Jedi

```bash
# Roteamento
ip route show
traceroute google.com
mtr google.com             # traceroute contínuo (instalar)

# DNS troubleshooting
dig google.com             # Consulta DNS detalhada
dig -x 8.8.8.8             # DNS reverso
dig @1.1.1.1 google.com    # Testar servidor específico
nslookup google.com

# Conexões
ss -tulanp                 # Todas portas e processos
ss -s                      # Estatísticas de socket
netstat -i                 # Estatísticas de interface

# Throughput
iperf3 -s                  # Servidor (recebe)
iperf3 -c 192.168.1.100    # Cliente (envia)

# Captura de pacotes
sudo tcpdump -i eth0 port 80 -w captura.pcap
sudo tcpdump -i any host 192.168.1.100
```

---

## 🔬 Debugging Profundo

### strace — Syscalls em Tempo Real

```bash
# Ver TODAS as syscalls de um processo
sudo strace -p 1234

# Filtrar por arquivo
sudo strace -e open,openat,read,write -p 1234

# Ver onde um processo trava
sudo strace -p 1234 2>&1 | tail -20

# Time por syscall (descobrir gargalo)
sudo strace -c -p 1234
```

### lsof — Quem tá usando o quê

```bash
lsof /var/log/syslog         # Quem tá escrevendo aqui?
lsof -i :80                  # Quem tá na porta 80?
lsof -p 1234                 # Arquivos abertos pelo PID 1234
lsof -u usuario              # Arquivos abertos pelo usuário
```

### Core Dumps

```bash
ulimit -c unlimited           # Permitir core dumps
# Quando app crashar → core file gerado
# Analisar com:
gdb /caminho/do/binario core
```

---

## 🛠️ Troubleshooting — Resolução de Problemas Jedi

### Servidor não responde / lento

```bash
# 1. Carga do sistema
uptime && free -h && df -h /

# 2. O QUE tá consumindo?
top -b -n 1 | head -20
iostat -x 1 3

# 3. Disco cheio?
df -h | awk '$5+0 > 90 {print "⚠️ "$0}'

# 4. Inodes (arquivos demais)?
df -i | awk '$5+0 > 90 {print "⚠️ "$0}'

# 5. OOM killer matou algo?
dmesg | tail -50 | grep -i kill

# 6. Logs de erro
journalctl -p 3 -xe --since "10 minutes ago"
```

### Serviço não sobe / morre

```bash
systemctl status servico     # Status + últimas linhas
journalctl -u servico -f    # Logs ao vivo
journalctl -u servico --since "5 minutes ago"

# Verificar porta em uso
ss -tulanp | grep :3001

# Verificar permissões dos arquivos
ls -la /caminho/do/servico
```

### Boot travou / não boota

```
1. GRUB → pressionar 'e' → adicionar "systemd.unit=rescue.target"
   → boots em modo de recuperação

2. Live USB → chroot no sistema → reparar:
   mount /dev/sda1 /mnt
   chroot /mnt
   update-grub
   systemctl list-units --failed
```

---

## 🎯 Playbooks Rápidos

### "Servidor tá lento!"

```bash
top -c -o %CPU             # Quem tá comendo CPU?
free -h                    # RAM acabando? Swap em uso?
iostat -x 1 3              # Disco sobrecarregado?
df -h /                    # Disco cheio?
```

### "SSH não conecta"

```bash
systemctl status sshd      # Serviço rodando?
ss -tulanp | grep :22      # Porta aberta?
sudo ufw status            # Firewall bloqueando?
ping servidor              # Máquina no ar?
```

### "Porta X não responde"

```bash
ss -tulanp | grep :X       # Alguém escutando?
sudo ufw status            # Firewall?
curl localhost:X           # Responde local?
```

---

## 🧘 Sabedoria Jedi

- **/var/log/syslog** e **journalctl -xe** são seus olhos. Se não tá lá, não aconteceu.
- **strace** mostra TUDO que um processo faz. É o "Process Monitor" do Linux.
- **Não reinicie sem ler os logs.** Se reiniciar, perdeu a evidência.
- **df -h E df -i.** Disco cheio ≠ inodes cheios. Ambos matam o sistema.
- **OOM Killer** mata processos quando RAM acaba. Se um serviço some do nada, cheque `dmesg | grep -i kill`.
- **Backup antes de qualquer mudança.** `cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak`

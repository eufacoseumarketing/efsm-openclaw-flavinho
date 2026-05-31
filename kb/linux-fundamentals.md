# 🐧 Linux Fundamentals — Guia HelpDesk

> Distros, filesystem, comandos essenciais, package managers.
> Atualizado: 31/05/2026

---

## 🟢 O Ecossistema Linux

### Principais Distros

| Família | Distros | Package Manager | Onde aparece |
|---------|---------|----------------|--------------|
| **Debian** | Ubuntu, Debian, Mint | apt | Servidores, desktop popular |
| **RHEL** | RHEL, CentOS, Fedora, Alma, Rocky | dnf/yum | Servidores corporativos |
| **Arch** | Arch, Manjaro, Endeavour | pacman | Desktop entusiasta |
| **Alpine** | Alpine Linux | apk | Docker containers |

⚠️ **Ubuntu Server** é o Linux que mais aparece em VPS e servidores. É o que a PC Resolve usa!

---

## 🟢 Sistema de Arquivos

```
/           → Raiz (tudo começa aqui)
/bin        → Binários essenciais (ls, cp, cat)
/sbin       → Binários de sistema (admin)
/etc        → Configurações (tudo é arquivo texto!)
/home       → Usuários (/home/usuario)
/root       → Home do root
/var        → Logs, dados variáveis (/var/log)
/tmp        → Temporários (limpo no boot!)
/usr        → Programas, bibliotecas
/opt        → Software de terceiros
/boot       → Kernel e bootloader
/dev        → Dispositivos (tudo é arquivo!)
/proc       → Processos e kernel (virtual)
/sys        → Hardware e kernel (virtual)
/mnt & /media → Montagem de discos
```

⚠️ **Não tem C:, D: etc.** Tudo é árvore única. Disco novo = monta em uma pasta.

---

## 🟢 Comandos Essenciais

```bash
# Navegação
pwd                 # Onde estou?
ls -la              # Listar TUDO (com ocultos)
cd /caminho         # Navegar
cd ~                # Home
cd -                # Voltar pro diretório anterior

# Arquivos
cp origem destino   # Copiar
mv origem destino   # Mover/renomear
rm arquivo          # Remover
rm -rf pasta        # Remover recursivo (CUIDADO! Não tem lixeira!)
mkdir -p a/b/c      # Criar pastas aninhadas
touch arquivo       # Criar arquivo vazio

# Visualização
cat arquivo         # Ver conteúdo inteiro
less arquivo        # Scroll (q = sair, / = buscar)
head -20 arq        # Primeiras 20 linhas
tail -f log         # Últimas linhas em tempo real (Ctrl+C)
grep "texto" arq    # Buscar texto

# Permissões
chmod 755 script    # rwxr-xr-x
chown user:group f  # Mudar dono
```

### Permissões (modo octal)
```
r=4  w=2  x=1

777 = rwxrwxrwx  (tudo pra todos — PERIGOSO!)
755 = rwxr-xr-x  (dono total, resto leitura+exec)
644 = rw-r--r--  (dono edita, resto lê)
400 = r--------  (só leitura, ninguém mexe)
```

---

## 🟢 Package Managers

### apt (Ubuntu/Debian)

```bash
sudo apt update              # Atualizar lista de pacotes
sudo apt upgrade -y          # Atualizar tudo
sudo apt install nginx       # Instalar
sudo apt remove nginx        # Remover
sudo apt purge nginx         # Remover + configs
sudo apt autoremove          # Limpar dependências órfãs
apt search firefox           # Buscar
apt show nginx               # Info do pacote
```

### snap (Ubuntu — apps em container)

```bash
snap install firefox
snap list
snap remove firefox
```

### dnf (Fedora/RHEL/CentOS)

```bash
sudo dnf update
sudo dnf install nginx
sudo dnf remove nginx
```

---

## 🟢 Sistema Básico

```bash
uname -a                     # Kernel, arquitetura
lsb_release -a               # Versão da distro
hostnamectl                  # Hostname + OS
uptime                       # Tempo ligado
free -h                      # RAM (humano)
df -h                        # Espaço em disco
du -sh /pasta/*              # Tamanho de pastas
lscpu                        # CPU
lsblk                        # Discos e partições
ip a                         # Rede (substitui ifconfig)
```

### Desligar/Reiniciar

```bash
sudo shutdown -h now         # Desligar AGORA
sudo shutdown -r now         # Reiniciar AGORA
sudo shutdown -h +5          # Desligar em 5 minutos
sudo shutdown -c             # Cancelar shutdown agendado
sudo reboot                  # Reiniciar
```

---

## ⚠️ Dicas Fundamentais

- **TUDO é arquivo.** Disco = /dev/sda, processo = /proc/1234, config = /etc/arquivo.conf.
- **TUDO é case-sensitive.** `Arquivo.txt` ≠ `arquivo.txt`.
- **Não tem .exe.** Executável = arquivo com permissão x.
- **sudo** = "fazer como admin". Sem sudo, você é usuário comum.
- **NÃO EXISTE LIXEIRA no terminal.** `rm` deleta pra sempre.
- **man comando** = ajuda de qualquer comando.
- **Ctrl+C** = interromper. **Ctrl+D** = EOF/sair. **Ctrl+Z** = suspender.

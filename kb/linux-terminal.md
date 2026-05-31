# 🐧 Linux Terminal & Shell — Guia HelpDesk

> Bash scripting, pipes, redirecionamento, variáveis, aliases, ferramentas.
> Atualizado: 31/05/2026

---

## 🟢 Pipes e Redirecionamento

```bash
# Pipe: saída de um comando → entrada de outro
ps aux | grep nginx
ls -la | wc -l

# Redirecionamento:
comando > arquivo.txt          # Sobrescrever
comando >> arquivo.txt         # Adicionar ao final
comando 2> erros.txt           # Redirecionar stderr
comando &> tudo.txt            # stdout + stderr
comando 2>/dev/null            # Descartar erros
comando < arquivo.txt          # Entrada de arquivo
```

---

## 🟢 Busca e Filtragem

```bash
# grep — buscar texto
grep "erro" /var/log/syslog
grep -i "erro" log.txt         # Case-insensitive
grep -r "texto" /etc/          # Recursivo
grep -v "ignorar" log.txt      # Excluir
grep -c "erro" log.txt         # Contar ocorrências
grep -B2 -A2 "erro" log.txt    # 2 linhas antes e depois

# find — buscar arquivos
find /home -name "*.log"       # Por nome
find . -type f -mtime -7       # Modificados há 7 dias
find . -size +100M             # > 100 MB
find . -name "*.tmp" -delete   # Achar e deletar

# Outros
which python3                  # Onde tá o executável?
locate nginx.conf              # Busca rápida (precisa updatedb)
```

---

## 🟡 Bash Scripting

```bash
#!/bin/bash
# Primeira linha = shebang (obrigatório!)

# Variáveis
NOME="Flavinho"
echo "Olá $NOME"
echo "Pasta atual: $(pwd)"

# Argumentos
echo "Script: $0"
echo "Arg 1: $1"
echo "Todos: $@"
echo "Quantos: $#"

# Condicionais
if [ -f "/etc/nginx/nginx.conf" ]; then
    echo "Arquivo existe"
elif [ -d "/etc/nginx" ]; then
    echo "Diretório existe"
else
    echo "Nada encontrado"
fi

# Loops
for i in 1 2 3 4 5; do
    echo "Número: $i"
done

while read linha; do
    echo ">> $linha"
done < arquivo.txt

# Funções
backup() {
    tar -czf "/backup/$1-$(date +%Y%m%d).tar.gz" "$2"
}
backup "nginx" "/etc/nginx"

# Exit codes
# 0 = sucesso, qualquer outra coisa = erro
comando && echo "OK" || echo "FALHOU"
echo $?  # Código do último comando
```

---

## 🔥 Aliases e Config

```bash
# Aliases úteis (~/.bashrc ou ~/.zshrc)
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias df='df -h'
alias free='free -h'
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='ss -tulanp'

# Funções úteis
extract() {  # Extrair qualquer formato
    if [ -f $1 ]; then
        case $1 in *.tar.bz2) tar xjf $1 ;; *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;; *.rar) unrar e $1 ;; *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;; *.tbz2) tar xjf $1 ;; *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;; *.Z) uncompress $1 ;; *.7z) 7z x $1 ;;
        esac
    fi
}

# Aplicar depois de editar:
source ~/.bashrc
```

---

## ⚡ Ferramentas Jedi

```bash
# Processamento de texto
awk '{print $1, $3}' dados.txt        # Colunas específicas
sed 's/antigo/novo/g' arquivo.txt     # Substituir

# Monitoramento
htop                 # top melhorado (instalar)
iotop                # I/O de disco por processo
nethogs              # Banda por processo

# Segurança/Diagnóstico
lsof -i :80          # Quem tá usando porta 80?
ss -tulanp           # Todas portas abertas
strace -p 1234       # Syscalls de um processo
lsof -p 1234         # Arquivos abertos por processo
```

---

## 🧙 one-liners Poderosos

```bash
# Top 10 processos por RAM
ps aux --sort=-%mem | head -10

# Arquivos > 100MB
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null

# Deletar arquivos > 30 dias
find /tmp -type f -mtime +30 -delete

# Tamanho total de cada pasta (1 nível)
du -h --max-depth=1 /var | sort -h

# Últimos 10 logins
last -10

# Processos usando porta específica
ss -tulanp | grep :80

# Substituir texto em múltiplos arquivos
find . -name "*.conf" -exec sed -i 's/old/new/g' {} \;
```

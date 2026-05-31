# 📧 Email Profundo — Guia HelpDesk

> POP/IMAP/Exchange, Outlook, SPF/DKIM/DMARC, spam, webmail, problemas comuns.
> Atualizado: 31/05/2026

---

## 🟢 POP vs IMAP vs Exchange — A Diferença Que Explode Chamado

| | POP3 | IMAP | Exchange/365 |
|---|------|------|-------------|
| **Onde ficam os emails** | Baixa pro PC, some do servidor | Ficam no servidor, sincronizados | Servidor + cache local |
| **Vários dispositivos** | ❌ Só no PC | ✅ Sincroniza | ✅ Sincroniza |
| **Contatos/Calendário** | ❌ Não sincroniza | ✅ Sincroniza | ✅ Sincroniza |
| **Porta do servidor** | 110 (995 SSL) | 143 (993 SSL) | 443 (HTTPS) |
| **Perdeu o PC?** | Perdeu os emails! 😱 | Acessa do webmail | Acessa do webmail |

⚠️ **POP é o vilão #1 de "perdi todos meus emails".** Configure IMAP sempre que possível.

---

## 🟢 Configurações de Servidor por Provedor

| Provedor | Servidor Entrada (IMAP) | Servidor Saída (SMTP) | Portas |
|----------|------------------------|----------------------|--------|
| **Gmail** | imap.gmail.com | smtp.gmail.com | 993/465 SSL |
| **Outlook/Hotmail** | outlook.office365.com | smtp.office365.com | 993/587 TLS |
| **Yahoo** | imap.mail.yahoo.com | smtp.mail.yahoo.com | 993/465 SSL |
| **HostGator** | mail.seudominio.com.br | mail.seudominio.com.br | 993/465 SSL |
| **Locaweb** | mail.seudominio.com.br | mail.seudominio.com.br | 993/587 TLS |
| **KingHost** | mail.seudominio.com.br | mail.seudominio.com.br | 993/587 TLS |
| **UOL Host** | imap.uol.com.br | smtp.uol.com.br | 993/587 TLS |
| **Terra** | imap.terra.com.br | smtp.terra.com.br | 993/587 TLS |
| **BOL** | imap.bol.com.br | smtp.bol.com.br | 993/587 TLS |

### Senha de App (Gmail/Outlook com 2FA)

```
⚠️ Gmail e Outlook exigem "senha de aplicativo" se 2FA ativado!
A senha normal NÃO funciona no Outlook/Thunderbird.

Gmail: myaccount.google.com/apppasswords
Outlook: account.microsoft.com/security → Verificação em duas etapas → Senhas de app
```

---

## 🔥 Outlook — Problemas e Soluções

### Perfil Corrompido

```
Sintomas:
- Outlook não abre
- "O arquivo de dados do Outlook foi fechado incorretamente"
- "Erro ao iniciar o Outlook"

Solução rápida:
1. Painel de Controle → Mail (Microsoft Outlook)
2. Perfis → Novo → criar perfil temporário "Outlook2"
3. Configurar email de novo → testar
4. Se funcionar, deletar perfil antigo
```

### OST/PST Gigante

```powershell
# Onde fica o arquivo de dados
# %LocalAppData%\Microsoft\Outlook\
# OST (Exchange/365) ou PST (POP/IMAP)

# Compactar PST:
# Outlook → Arquivo → Configurações de Conta → Arquivos de Dados
# → Selecionar → Compactar

# Problema: OST > 50GB em SSD pequeno
# Solução: reduzir cache de email (configurações de sincronização)
```

### Busca Não Funciona

```
1. Outlook → Arquivo → Opções → Pesquisar → Opções de Indexação
2. Avançado → Reconstruir índice
3. Aguardar indexação terminar (pode demorar horas)

Ou PowerShell:
Get-Service WSearch | Restart-Service
```

### Suplementos (Add-ins) Quebrados

```
1. Outlook → Arquivo → Opções → Suplementos
2. Ir (Gerenciar: Suplementos COM) → Desmarcar tudo
3. Reabrir Outlook
4. Se resolveu, habilitar um por um pra achar o culpado
```

---

## 🔐 SPF / DKIM / DMARC — Email Rejeitado

```
Problema: cliente envia email e volta com "undelivered" ou "mensagem rejeitada"

SPF  → "Quem pode enviar email em nome do meu domínio?"
DKIM → "Assinatura digital que prova que eu enviei"
DMARC → "O que fazer se SPF ou DKIM falhar?"

Causa comum: cliente mudou de hospedagem, DNS desatualizou.
Solução: verificar em mxtoolbox.com → SPF Record Lookup
```

---

## 🛡️ Spam e Phishing

```
"Recebo muito spam" →
1. Não postar email publicamente (sites, fóruns)
2. Usar alias: seunome+loja@gmail.com (Gmail suporta +)
3. Não clicar "descadastrar" em spam (confirma que o email é ativo!)
4. Outlook: Bloquear remetente → Lixo Eletrônico → Opções

"Caí num phishing e passei senha" →
🚨 IMEDIATAMENTE:
1. Trocar senha (de outro dispositivo limpo)
2. Ativar 2FA
3. Verificar regras de email (phishing cria regra pra esconder emails)
4. Verificar encaminhadores automáticos
```

---

## ⚡ Playbooks Rápidos

### "Não recebo email"
```
1. Webmail tá recebendo? → Se sim, problema é no Outlook/app
2. Espaço cheio? webmail → verificar cota
3. Email caiu no spam? Verificar pasta lixo eletrônico
4. Regra desviando? Outlook → Regras → verificar
```

### "Não envio email"
```
1. Servidor SMTP e porta corretos?
2. Senha de app configurada? (Gmail/Outlook com 2FA)
3. Provedor de internet bloqueia porta 25? Testar 587 (TLS)
4. Erro "relay not permitted" = autenticação SMTP desligada
```

### "Outlook pede senha toda hora"
```
1. Senha expirou (Office 365)
2. Credencial salva errada → Painel de Controle → Gerenciador de Credenciais
   → Remover credenciais do Outlook → reabrir e digitar
3. Modern Auth desligado em tenant antigo
4. Perfil corrompido → criar perfil novo
```

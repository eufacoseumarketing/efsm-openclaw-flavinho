# 🏢 Active Directory — Guia Essencial HelpDesk

> Domínio, GPO, perfis, permissões, reset de senha, desbloqueio de conta.
> Foco: tarefas que o HelpDesk mais faz no dia a dia.
> Atualizado: 31/05/2026

---

## 🟢 Conceitos

```
Domain Controller (DC)  → Servidor que gerencia o domínio
Organizational Unit (OU) → "Pasta" que organiza usuários/computadores
Group Policy (GPO)       → Regras aplicadas a usuários/computadores
Security Group           → Grupo de permissão (ex: "Financeiro", "TI")
```

---

## 🟡 Tarefas Diárias do HelpDesk

### Reset de Senha

```powershell
# Resetar senha de usuário
Set-ADAccountPassword -Identity "usuario" -Reset -NewPassword (ConvertTo-SecureString "NovaSenha123!" -AsPlainText -Force)

# Forçar troca no próximo login
Set-ADUser -Identity "usuario" -ChangePasswordAtLogon $true
```

### Desbloquear Conta

```powershell
# Ver se tá bloqueada
Get-ADUser -Identity "usuario" -Properties LockedOut | Select Name,LockedOut

# Desbloquear
Unlock-ADAccount -Identity "usuario"
```

### Verificar Grupos do Usuário

```powershell
Get-ADPrincipalGroupMembership -Identity "usuario" | Select Name
```

### Computador no Domínio

```powershell
# Verificar se PC tá no domínio
Get-ADComputer -Identity "PC-NOME" -Properties OperatingSystem | Select Name,OperatingSystem

# Remover PC do domínio (órfão/antigo)
Remove-ADComputer -Identity "PC-ANTIGO" -Confirm:$false
```

---

## 🔥 Problemas Comuns

### "Não consigo logar no domínio"

```
1. Verificar se o cabo de rede tá plugado (sim, acontece)
2. PC consegue pingar o DC?
3. Relação de confiança quebrada? (erro clássico!)
   Solução: desconectar do domínio → reconectar
   OU: Reset-ComputerMachinePassword -Credential (Get-Credential)
4. DNS do PC apontando pro DC? (ipconfig /all → servidor DNS = IP do DC)
```

### "Relação de confiança falhou"

```powershell
# No PC do cliente (conta local admin):
Reset-ComputerMachinePassword -Credential DOMINIO\Administrador
# Reiniciar

# Ou via PowerShell remoto:
Test-ComputerSecureChannel -Repair -Credential DOMINIO\Administrador
```

### "GPO não aplica"

```cmd
gpupdate /force               # Forçar atualização de política
gpresult /h C:\gpo.html       # Relatório: quais GPOs aplicaram?
gpresult /r                   # Resumo rápido
```

### "Perfil temporário" (Temp Profile)

```
Sintoma: "Você foi conectado com um perfil temporário"

Solução:
1. Regedit → HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
2. Procurar entrada do usuário com .bak no final
3. Remover entrada sem .bak (se existir)
4. Renomear entrada .bak → remover .bak do nome
5. Reiniciar
```

---

## ⚡ Dicas Jedi

- **DNS é TUDO no AD.** Se o DNS não resolve, nada funciona.
- **gpupdate /force** resolve 50% dos "meu acesso sumiu".
- **Conta bloqueada** é o chamado mais comum. 30s pra resolver.
- **Perfil temporário** = registry corrompido. Procedimento acima resolve.
- Sempre verificar **se o PC tá na rede do domínio** antes de qualquer troubleshooting AD.

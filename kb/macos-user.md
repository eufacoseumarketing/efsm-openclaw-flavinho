# 🍎 macOS: iCloud, Usuários, FileVault, Keychain

> Apple ID, iCloud, Login, FileVault, chaves, permissões de usuário.
> Atualizado: 31/05/2026

---

## 🟢 Apple ID e iCloud

### Problemas Comuns

**"iCloud pede senha toda hora"**
```
1. System Settings → Apple ID → Sair → Logar de novo
2. Verificar se a senha expirou ou foi alterada
3. Se tiver iPhone/iPad: ver se tá com a mesma Apple ID
```

**"iCloud cheio"** (5 GB grátis)
```
Solução:
- Comprar mais espaço (iCloud+)
- Otimizar Fotos: Fotos → Preferências → iCloud → "Otimizar Armazenamento"
- Limpar backups antigos de iPhone/iPad no iCloud
- Ver o que tá ocupando: System Settings → Apple ID → iCloud → Gerenciar
```

---

## 🟢 Contas de Usuário

```bash
# Listar usuários
dscl . list /Users | grep -v "^_"

# Grupos do usuário
groups nomedeusuario

# Usuário administrador vs padrão
# Admin = pode sudo, instalar apps, mudar configs
# Padrão = só usa, não administra
```

**"Esqueci a senha do Mac"**
```
1. Apple ID → Resetar senha pelo Apple ID (se vinculado)
2. Recovery Mode → Terminal → resetpassword
3. Outra conta admin no mesmo Mac → System Settings → Usuários → Resetar senha
```

---

## 🟢 FileVault (Criptografia de Disco)

```bash
# Verificar status
fdesetup status

# Recuperar chave de recuperação
# Anotada durante ativação OU guardada no iCloud

# ⚠️ SEM recovery key + sem senha do Mac = DADOS PERDIDOS!
```

---

## 🟢 Keychain (Chaves e Senhas)

```
Keychain Access.app → Gerenciador de senhas do macOS
Guarda: senhas de Wi-Fi, sites, apps, certificados

"Keychain pede senha toda hora" =
1. Keychain Access → Preferências → Redefinir Keychain Padrão
2. Ou: ~/Library/Keychains/ → renomear pasta → reiniciar (recria)
   (PERDE senhas salvas!)
```

---

## 🟡 Permissões de Disco

```bash
# Reparar permissões (Recovery Mode):
# Bootar Recovery → Utilities → Terminal
diskutil resetUserPermissions / `id -u`

# Verificar permissões via Terminal:
ls -la ~/Desktop
```

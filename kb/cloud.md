# ☁️ Cloud Básico — Guia HelpDesk

> OneDrive, Google Drive, Dropbox. Sync, conflitos, espaço cheio, compartilhamento.
> Atualizado: 31/05/2026

---

## 🟢 Os Principais

| Serviço | Espaço Grátis | Cliente PC | Diferencial |
|---------|--------------|-----------|-------------|
| **OneDrive** | 5 GB | Nativo (já vem) | Integração Windows total |
| **Google Drive** | 15 GB | Instalar | Google Docs/Sheets |
| **Dropbox** | 2 GB | Instalar | Sync mais confiável |

---

## 🟡 OneDrive — Problemas e Soluções

### "OneDrive não sincroniza"

```powershell
# Resetar OneDrive (não perde arquivos)
%LocalAppData%\Microsoft\OneDrive\OneDrive.exe /reset

# Reconfigurar
%LocalAppData%\Microsoft\OneDrive\OneDrive.exe

# Verificar status
%LocalAppData%\Microsoft\OneDrive\OneDrive.exe /settings
```

### "Arquivo com ❌ vermelho"
```
= NÃO está sincronizando.

Causas:
- Nome com caractere proibido: * : < > ? / \ | "
- Nome MUITO longo (>400 caracteres no caminho completo)
- Arquivo em uso (aberto em outro app)
- Espaço cheio na nuvem

Solução: renomear arquivo, tirar caracteres especiais, fechar o app que tá usando
```

### "Conflito de versão" (arquivo duplicado com "meu-nome" e "PC-xxxx")
```
= Duas pessoas editaram o mesmo arquivo ao mesmo tempo.

Solução:
1. Abrir ambos, comparar
2. Copiar conteúdo pro principal
3. Deletar o duplicado
```

---

## 🟡 Google Drive

```powershell
# Instalar (via winget)
winget install Google.Drive
```

**"Google Drive não sincroniza"**
```
1. Clicar ícone na bandeja → Pausar → Retomar
2. Sair do Google Drive → Abrir de novo
3. Verificar login
```

**"Sem espaço no Google Drive"**
```
Os 15 GB grátis são COMPARTILHADOS entre:
- Google Drive
- Gmail
- Google Fotos

= Muita foto no Google Fotos = Drive sem espaço!
→ photos.google.com → Configurações → "Alta qualidade" (não Original)
→ OU limpar Gmail antigo
→ OU comprar Google One
```

---

## 🔥 Troubleshooting Universal de Sync

```
1. Sair do app → Reabrir
2. Verificar internet
3. Verificar espaço (PC e nuvem)
4. Verificar login (OneDrive pede reconexão depois de update do Windows)
5. Pausar → Retomar
6. Desinstalar + reinstalar (último recurso)
```

---

## 🎯 Dicas

- **OneDrive + File History** = proteção completa grátis pra arquivos.
- **Senhas de navegador** → Chrome/Edge já sincronizam com conta Google/Microsoft.
- **Fotos do celular** → OneDrive faz backup automático se configurar.
- **Backup 3-2-1** → um deles pode ser a nuvem.

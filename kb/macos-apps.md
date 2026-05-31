# 📦 macOS App Management — Guia HelpDesk

> Instalar, remover, Gatekeeper, permissões de app, código de assinatura.
> Atualizado: 31/05/2026

---

## 🟢 Formatos de Instalação

| Formato | O que é | Como usar |
|---------|---------|-----------|
| **.dmg** | Imagem de disco (mais comum) | Abrir → arrastar app pra /Applications → ejetar |
| **.pkg** | Instalador tradicional | Duplo clique → next/next/install |
| **App Store** | Loja oficial | Baixar e instalar automaticamente |
| **.zip/.tar** | App empacotado | Extrair → arrastar pra /Applications |
| **.app** | App standalone | Só arrastar pra /Applications e usar |

⚠️ **Regra de ouro do Mac:** 90% dos apps são só arrastar o .app pra pasta Applications.

---

## 🟢 Remover Apps

```bash
# Método 1 (básico): Arrastar da pasta Applications pra Lixeira
# Método 2: Launchpad → clicar e segurar → X → Remover
# Método 3: Terminal
sudo rm -rf /Applications/NomeDoApp.app

# ⚠️ Arrastar pra lixeira NÃO remove:
# - Preferências (~/Library/Preferences/)
# - Caches (~/Library/Caches/)
# - Dados do app (~/Library/Application Support/)
```

### App Cleaner (remoção completa)

```bash
# AppCleaner (grátis) — remove app + TODOS os vestígios
brew install --cask appcleaner

# Manualmente (se não quiser instalar nada):
# 1. Arrastar app pra lixeira
# 2. Limpar vestígios:
rm -rf ~/Library/Preferences/*NomeApp*
rm -rf ~/Library/Caches/*NomeApp*
rm -rf ~/Library/Application\ Support/NomeApp/
rm -rf ~/Library/Saved\ Application\ State/com.empresa.NomeApp.savedState/
```

---

## 🔥 Gatekeeper — Controle de Segurança de Apps

### O que é

```
Gatekeeper = verifica se o app é seguro antes de abrir.
3 níveis:
- App Store apenas (mais seguro)
- App Store + Desenvolvedores identificados (padrão)
- Qualquer lugar (desabilitado por padrão)
```

### App bloqueado: "Não é possível abrir porque o desenvolvedor não foi identificado"

```bash
# Solução 1 (recomendada, por app):
# Botão direito no app → Abrir → Confirmar "Abrir"

# Solução 2 (Terminal):
xattr -cr /Applications/NomeDoApp.app

# Solução 3 (remover quarentena):
xattr -d com.apple.quarantine /Applications/NomeDoApp.app

# Solução 4 (desabilitar Gatekeeper TEMPORARIAMENTE):
sudo spctl --master-disable
# ⚠️ REABILITE depois!
sudo spctl --master-enable
```

---

## 🟡 Permissões de App (TCC - Transparency, Consent, and Control)

```
Desde Catalina, macOS pede permissão pra TUDO:
- Acesso à câmera
- Acesso ao microfone
- Acesso aos arquivos (Desktop, Documentos, Downloads)
- Gravação de tela
- Acessibilidade

Configurações → Privacidade e Segurança → cada categoria
```

### App pedindo permissão que não aparece nas configs

```bash
# Resetar banco de dados TCC (MUITO CUIDADO!)
tccutil reset All                    # Reset TUDO (perde TODAS permissões!)
tccutil reset Camera                 # Reset só câmera
tccutil reset Microphone             # Reset só microfone
tccutil reset ScreenCapture          # Reset só gravação de tela
```

---

## 🎯 Problemas Comuns

**"App está danificado e deve ser movido para a Lixeira"**
```
= Certificado do app expirou OU foi revogado.

Solução:
1. xattr -cr /Applications/NomeDoApp.app
2. Tentar abrir de novo
3. Se for app legítimo e antigo → baixar versão mais nova
```

**"App não abre / fecha sozinho"**
```
= Conflito, permissão, app quebrado.

Solução:
1. Cmd+Q → Reabrir
2. Reiniciar Mac
3. Reinstalar app
4. Verificar Console.app por crash reports
```

**"App precisa do Rosetta 2"** (Apple Silicon)
```bash
# Instalar Rosetta 2
softwareupdate --install-rosetta

# Ver se app é Intel ou Apple Silicon
# System Information → Software → Applications → coluna "Kind"
# "Apple Silicon" = nativo | "Intel" = precisa Rosetta
```

---

## ⚠️ Dicas Jedi

- **Se só arrastar .app pra Applications não funciona** = provavelmente é .pkg e precisa de instalador.
- **Gatekeeper bloqueou?** Botão direito → Abrir resolve 80% dos casos.
- **App da App Store não atualiza?** App Store → Atualizações → Cmd+R (atualizar página).
- **Remover app = arrastar pra lixeira** é suficiente pra 90% dos casos. App Cleaner só se der problema depois.

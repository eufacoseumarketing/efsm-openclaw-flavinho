# 💾 Backup & Restore — Guia Completo

> Estratégias, ferramentas, Windows Backup, Restauração do Sistema, recuperação de dados.
> Atualizado: 31/05/2026

---

## 🟢 Estratégia 3-2-1 (Regra de Ouro)

```
3 → 3 cópias dos dados (original + 2 backups)
2 → 2 tipos de mídia diferentes (HD externo + nuvem)
1 → 1 cópia offsite (fora do local físico)
```

---

## 🟡 Ferramentas Nativas do Windows

### Restauração do Sistema (System Restore)

```powershell
# Criar ponto de restauração manual
Checkpoint-Computer -Description "Antes de instalar X" -RestorePointType MODIFY_SETTINGS

# Habilitar proteção do sistema (se desabilitada)
Enable-ComputerRestore -Drive "C:\"

# Listar pontos existentes
Get-ComputerRestorePoint | Select SequenceNumber,Description,CreationTime

# Restaurar
rstrui.exe
```

### Histórico de Arquivos (File History)

```powershell
# Ativar (precisa de drive externo/rede)
# Configurações → Atualização e Segurança → Backup → Adicionar unidade

# Restaurar arquivos manualmente
# Pasta → botão direito → "Restaurar versões anteriores"

# Ver status da proteção
Get-WmiObject Win32_FileHistoryProtectionStatus
```

### Windows Backup (Windows 7 Backup — ainda funciona!)

```powershell
# Criar backup completo
wbAdmin start backup -backupTarget:E: -include:C: -allCritical -quiet

# Criar imagem do sistema
wbAdmin start backup -backupTarget:E: -include:C: -allCritical -quiet

# Listar backups
wbAdmin get versions

# Restaurar
# WinRE → Solucionar Problemas → Opções Avançadas → Restauração da Imagem do Sistema
```

---

## 🔥 Ferramentas e Estratégias

### Backup Manual (Explorer/Cópia)

```
O que copiar SEMPRE:
☐ Desktop
☐ Documentos
☐ Imagens
☐ Downloads
☐ Favoritos do navegador
☐ Arquivos .pst/.ost do Outlook
☐ Certificados digitais (.pfx)
☐ Chaves de ativação (produkey ou similar)
☐ Pastas de apps específicos (NF-e, sistemas, etc.)
```

### OneDrive / Google Drive (Backup em Nuvem)

```powershell
# OneDrive — backup automático de Desktop, Documentos, Imagens
# Configurações do OneDrive → Backup → Gerenciar backup → Ativar pastas

# Verificar status de sincronização
%LocalAppData%\Microsoft\OneDrive\OneDrive.exe /settings
```

### Recuperação de Dados

```powershell
# Arquivo deletado recentemente → Lixeira
# Arquivo deletado mas não sobrescrito → ferramentas de recovery:

# Windows File Recovery (gratuito, Microsoft Store)
winfr C: D: /regular /n *.docx

# Alternativas:
# Recuva (Piriform, gratuito)
# PhotoRec (open source, muito poderoso)
```

---

## 🎯 Script de Backup Rápido

```powershell
function Backup-CriticalData {
    param([string]$Destination = "D:\Backup")
    
    $date = Get-Date -Format "yyyy-MM-dd"
    $backupPath = "$Destination\$date"
    New-Item -ItemType Directory -Force -Path $backupPath | Out-Null
    
    # Desktop, Documentos, Imagens
    Copy-Item "$env:USERPROFILE\Desktop\*" "$backupPath\Desktop\" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item "$env:USERPROFILE\Documents\*" "$backupPath\Documents\" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item "$env:USERPROFILE\Pictures\*" "$backupPath\Pictures\" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Outlook (se existir)
    $pstPath = "$env:LocalAppData\Microsoft\Outlook"
    if (Test-Path $pstPath) {
        Copy-Item "$pstPath\*.pst" "$backupPath\Outlook\" -Force -ErrorAction SilentlyContinue
    }
    
    # Certificado digital (se existir)
    certutil -exportPFX -p "temp123" My * "$backupPath\certificados.pfx" 2>$null
    
    Write-Host "✅ Backup salvo em: $backupPath"
}
```

---

## ⚠️ Dicas

- **NUNCA faça backup no mesmo disco do sistema!**
- **Teste o restore** periodicamente — backup que não restaura não é backup.
- **BitLocker + TPM sem recovery key = dados PERDIDOS** se o Windows corromper.

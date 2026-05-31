# 🛡️ Antivírus Gratuitos — Instalação por Linha de Comando

> Guia prático: quais AVs gratuitos usar, como baixar e instalar silenciosamente via CMD/PowerShell.
> Ideal para deploy remoto via PC Resolve.
> Atualizado: 31/05/2026

---

## 🏆 Ranking — Melhores AVs Gratuitos (2026)

| # | Antivírus | Destaque | Peso |
|---|-----------|----------|------|
| 1 | **Bitdefender Free** | Melhor detecção, super leve | ⭐ Baixo |
| 2 | **Kaspersky Free** | Excelente proteção, muitos extras | ⭐⭐ Médio |
| 3 | **Avast Free** | Completo, modo passivo (coexiste com outro AV) | ⭐⭐ Médio |
| 4 | **AVG Free** | Similar ao Avast (mesma empresa) | ⭐⭐ Médio |
| 5 | **Avira Free** | Bom, mas instalação complexa | ⭐ Médio |
| 6 | **Microsoft Defender** | Já vem no Windows, top 5 global | ✅ Zero (nativo) |
| 7 | **Malwarebytes Free** | Complemento (anti-malware, NÃO antivírus) | ⭐ Baixo |

⚠️ **Regra:** Apenas 1 antivírus residente + Malwarebytes como scanner sob demanda.

---

## 📥 Métodos de Instalação — Visão Geral

### Método 1: Winget (Windows Package Manager) — O MAIS FÁCIL

```powershell
# Listar AVs disponíveis
winget search antivirus

# Instalar com um comando (já faz download + instala silencioso!)
winget install Bitdefender.Bitdefender
winget install Avast.AvastFreeAntivirus
winget install AVG.AVGAntiVirusFREE
winget install Malwarebytes.Malwarebytes
winget install Avira.Avira

# Desinstalar
winget uninstall "Avast Free Antivirus"
```

✅ **Vantagem:** Sempre baixa a versão mais recente, instalação limpa.  
⚠️ **Limitação:** Winget precisa estar atualizado (Windows 10 1809+).

---

### Método 2: Download + Silent Install

Baixar offline installer e instalar silenciosamente via CMD/PowerShell.

---

## 🔧 Guia por Antivírus

---

### 🥇 Bitdefender Free

**Download:** https://www.bitdefender.com/solutions/free.html  
**Instalador:** `bitdefender_free.exe` (web installer, precisa de internet durante instalação)

```powershell
# Download (via PowerShell)
Invoke-WebRequest -Uri "https://download.bitdefender.com/windows/installer/en-us/bitdefender_online.exe" -OutFile "$env:TEMP\bitdefender_free.exe"

# Instalar silencioso
Start-Process -FilePath "$env:TEMP\bitdefender_free.exe" -ArgumentList "/silent" -Wait -NoNewWindow
```

⚠️ Bitdefender Free mudou pra web installer — precisa de internet ativa durante instalação. Sem conta obrigatória.

---

### 🥈 Kaspersky Free

**Download:** https://www.kaspersky.com/downloads/free-antivirus  
**Instalador:** `kav21.x.x.x.xABCDEF_pt-br.exe`

```powershell
# Download (versão mais recente, verificar URL exata no site)
$url = "https://trial.s.kaspersky-labs.com/registered/..." # URL dinâmica

# Alternativa: baixar do site oficial e usar:
Start-Process -FilePath "kaspersky_free.exe" -ArgumentList "/s /mybirthdate=1990-01-01" -Wait
```

⚠️ Kaspersky requer data de nascimento e aceitação de EULA. Parâmetros exatos podem variar por versão.  
⚠️ Suspenso pelo governo dos EUA (2024). No Brasil, ainda disponível.

---

### 🥉 Avast Free Antivirus

**Download offline installer (link direto):**
https://files.avast.com/iavs9x/avast_free_antivirus_setup_offline.exe

```powershell
# Download + Instalar em um script
$url = "https://files.avast.com/iavs9x/avast_free_antivirus_setup_offline.exe"
$out = "$env:TEMP\avast_free_antivirus_setup_offline.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/silent" -Wait

# Ou via winget (mais simples):
winget install Avast.AvastFreeAntivirus --silent
```

**Switch:** `/silent`  
**Desinstalar silencioso:**
```cmd
:: ⚠️ Precisa desabilitar Self-Defense antes!
:: Abrir Avast → Menu → Configurações → Solução de Problemas → Desmarcar "Ativar Autodefesa"
:: Depois editar: %ProgramFiles%\Avast Software\Avast\setup\Stats.ini
:: Adicionar em [Common]: SilentUninstallEnabled=1
:: Executar como SYSTEM (PsExec):
"%ProgramFiles%\Avast Software\Avast\setup\Instup.exe" /control_panel /instop:uninstall /silent /wait
```

---

### AVG AntiVirus Free (Irmão gêmeo do Avast)

**Download offline installer:**
https://www.avg.com/en-us/installation-files-prd-gsr-free (selecionar Offline Installer)

```powershell
# Download + instalar
$url = "https://bits.avcdn.net/productfamily_ANTIVIRUS/insttype_FREE/platform_WIN/installertype_OFFLINE/build_RELEASE"
$out = "$env:TEMP\avg_antivirus_free_setup_offline.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/silent" -Wait

# Ou winget:
winget install AVG.AVGAntiVirusFREE --silent
```

**Switch:** `/silent`  
**Desinstalar:** Mesmo procedimento do Avast (Stats.ini + SYSTEM account + Instup.exe)

---

### Avira Free Antivirus

**Download:** https://download.avira.com/package/antivirus/win/en-us/avira_antivirus_en-us.exe

```powershell
# Avira precisa de um arquivo de configuração (setup.inf)
# Criar C:\temp\setup.inf:
@"
[DATA]
DesktopIcon=0
RestartWindows=0
ShowRestartMessage=0
Guard=1
WebGuard=1
RootKit=1
"@ | Out-File -FilePath "C:\temp\setup.inf" -Encoding ASCII

# Instalar
$installer = "C:\temp\avira_antivirus_en-us.exe"
Start-Process -FilePath $installer -ArgumentList "/INF=`"C:\temp\setup.inf`"" -Wait
```

**Switch:** `/INF="caminho\setup.inf"` (precisa do arquivo .inf!)  
**Desinstalar silencioso:**
```cmd
"%ProgramFiles(x86)%\Avira\Antivirus\setup.exe" /remsilentnoreboot
```

⚠️ Avira é o mais chato de instalar silenciosamente. Prefira winget ou outro AV.

---

### ESET NOD32 Antivirus (Trial → Free?)

**Download 64-bit:**
https://download.eset.com/com/eset/apps/home/eav/windows/latest/eav_nt64.exe

```powershell
# Download + instalar
$url = "https://download.eset.com/com/eset/apps/home/eav/windows/latest/eav_nt64.exe"
$out = "$env:TEMP\eav_nt64.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "--silent --accepteula --msi-property-ehs PRODUCTTYPE=eav" -Wait
```

**Switch:** `--silent --accepteula --msi-property-ehs PRODUCTTYPE=eav`  
**Para 32-bit:** trocar `eav_nt64.exe` por `eav_nt32.exe`

⚠️ ESET NOD32 é pago (trial 30 dias). A versão gratuita não é óbvia; na prática NÃO tem versão free permanente. Incluído aqui caso a PC Resolve tenha licenças.

---

### 🪟 Microsoft Defender (NATIVO — O Melhor Custo-Benefício)

```powershell
# Já vem no Windows 10/11. Verificar status:
Get-MpComputerStatus | Select AntivirusEnabled,RealTimeProtectionEnabled

# Se estiver desativado (ex: depois de remover outro AV):
Set-MpPreference -DisableRealtimeMonitoring $false

# Habilitar via Política de Grupo/Registry se bloqueado:
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0 -Force

# Atualizar assinaturas e fazer scan:
Update-MpSignature
Start-MpScan -ScanType QuickScan
```

✅ **NÃO PRECISA INSTALAR NADA.** Só habilitar se estiver desativado.

---

### Malwarebytes Free (COMPLEMENTO, não antivírus)

**Download offline:**
https://www.malwarebytes.com/mwb-download/thankyou/

```powershell
# Download + instalar (usa Inno Setup)
$url = "https://downloads.malwarebytes.com/file/mb4_offline"
$out = "$env:TEMP\MalwarebytesSetup.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/verysilent /suppressmsgboxes /norestart" -Wait

# Ou winget:
winget install Malwarebytes.Malwarebytes --silent
```

**Switch:** `/verysilent /suppressmsgboxes /norestart` (Inno Setup)

⚠️ Versão Free = scanner manual. NÃO tem proteção em tempo real. Use JUNTO com um AV.

---

## 🚀 Script Completo — Instalador Automático

```powershell
<#
.SYNOPSIS
    Instala antivírus gratuito silenciosamente no PC do cliente.
.DESCRIPTION
    Baixa e instala o AV escolhido. Usa winget quando disponível,
    fallback para download direto + silent install.
.PARAMETER AV
    Nome do AV: Defender, Bitdefender, Avast, AVG, Malwarebytes, Avira
.EXAMPLE
    Install-FreeAV -AV Avast
#>
function Install-FreeAV {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Defender","Bitdefender","Avast","AVG","Malwarebytes","Avira")]
        [string]$AV
    )
    
    # Pasta temp
    $tempDir = "$env:TEMP\PCResolve\AV"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    Write-Host "🔧 Instalando $AV..." -Foreground Cyan
    
    switch ($AV) {
        "Defender" {
            Write-Host "Microsoft Defender já é nativo. Verificando status..."
            $status = Get-MpComputerStatus
            if (-not $status.AntivirusEnabled) {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0 -Force
                Write-Host "✅ Defender habilitado!" -Foreground Green
            } else {
                Write-Host "✅ Defender já estava ativo!" -Foreground Green
            }
        }
        "Bitdefender" {
            $url = "https://download.bitdefender.com/windows/installer/en-us/bitdefender_online.exe"
            $out = "$tempDir\bitdefender_free.exe"
            Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
            Start-Process -FilePath $out -ArgumentList "/silent" -Wait
            Write-Host "✅ Bitdefender Free instalado!" -Foreground Green
        }
        "Avast" {
            $url = "https://files.avast.com/iavs9x/avast_free_antivirus_setup_offline.exe"
            $out = "$tempDir\avast_free_antivirus_setup_offline.exe"
            Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
            Start-Process -FilePath $out -ArgumentList "/silent" -Wait
            Write-Host "✅ Avast Free instalado!" -Foreground Green
        }
        "AVG" {
            $url = "https://bits.avcdn.net/productfamily_ANTIVIRUS/insttype_FREE/platform_WIN/installertype_OFFLINE/build_RELEASE"
            $out = "$tempDir\avg_antivirus_free_setup_offline.exe"
            Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
            Start-Process -FilePath $out -ArgumentList "/silent" -Wait
            Write-Host "✅ AVG Free instalado!" -Foreground Green
        }
        "Malwarebytes" {
            $url = "https://downloads.malwarebytes.com/file/mb4_offline"
            $out = "$tempDir\MalwarebytesSetup.exe"
            Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
            Start-Process -FilePath $out -ArgumentList "/verysilent /suppressmsgboxes /norestart" -Wait
            Write-Host "✅ Malwarebytes Free instalado!" -Foreground Green
        }
        "Avira" {
            $url = "https://download.avira.com/package/antivirus/win/en-us/avira_antivirus_en-us.exe"
            $out = "$tempDir\avira_antivirus_en-us.exe"
            Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
            
            # Criar setup.inf
            @"
[DATA]
DesktopIcon=0
RestartWindows=0
Guard=1
WebGuard=1
RootKit=1
"@ | Out-File -FilePath "$tempDir\setup.inf" -Encoding ASCII
            
            Start-Process -FilePath $out -ArgumentList "/INF=`"$tempDir\setup.inf`"" -Wait
            Write-Host "✅ Avira Free instalado!" -Foreground Green
        }
    }
    
    # Limpar
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "🏁 Pronto!" -Foreground Cyan
}
```

---

## 📊 Resumo — Switches de Instalação Silenciosa

| Antivírus | Switch | Instalador |
|-----------|--------|------------|
| **Microsoft Defender** | N/A (nativo, só habilitar) | `Set-MpPreference` |
| **Bitdefender Free** | `/silent` | Web installer |
| **Avast Free** | `/silent` | Offline .exe |
| **AVG Free** | `/silent` | Offline .exe |
| **Avira Free** | `/INF="setup.inf"` | .exe + arquivo .inf |
| **ESET NOD32** | `--silent --accepteula` | .exe |
| **Malwarebytes** | `/verysilent /suppressmsgboxes /norestart` | .exe (Inno Setup) |

---

## 🎯 Recomendação PC Resolve

### Cenário Padrão (Cliente doméstico/pequena empresa)
```
1º Microsoft Defender (já vem, só garantir que tá ativo)
2º Adicionar Malwarebytes Free como scanner complementar
3º Instalar uBlock Origin no navegador do cliente
```

### Cenário Alta Proteção (Cliente com dados sensíveis)
```
1º Bitdefender Free (substitui Defender) OU Kaspersky Free
2º Malwarebytes Free (scanner complementar)
3º Configurar backup automático (OneDrive/Google Drive)
```

### Comando Único (recomendado pra PC Resolve)
```powershell
# Via API do PC Resolve, após conectar no PC:
# PowerShell: garantir Defender + Malwarebytes
Set-MpPreference -DisableRealtimeMonitoring $false
winget install Malwarebytes.Malwarebytes --silent --accept-package-agreements
```

---

## ⚠️ Notas Importantes

- **winget** é o método mais confiável, mas precisa de internet e App Installer atualizado
- **Offline installers** são melhores pra conexões lentas/instáveis
- **Sempre teste** o comando em VM antes de aplicar em produção
- **Nunca instale 2 AVs** com proteção em tempo real simultaneamente
- Avast/AVG podem ser instalados em **modo passivo** (compatível com outro AV)
- Após instalar, execute Windows Update pra garantir updates de assinatura

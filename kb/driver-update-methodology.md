# Metodologia de Atualização de Drivers 🔧

> **"Ferramenta automática primeiro, site do fabricante por último."**

## 🔥 Regra de Ouro
**NUNCA caçar driver por driver no site do fabricante.** Os sites de fabricantes (Dell, HP, Lenovo) são hostis pra download automatizado — bloqueiam VPS (403), redirecionam, exigem interação manual.

## 📋 Ordem de Ferramentas

| Prioridade | Ferramenta | Quando usar |
|-----------|-----------|-------------|
| 1ª | **Dell SupportAssist** | Notebooks/Desktops Dell |
| 2ª | **Intel Driver & Support Assistant** | Qualquer máquina com CPU Intel |
| 3ª | **Windows Update** | Todos os casos |
| 4ª | **Site do fabricante** | Último recurso |

---

## 🟢 Nível 1: Dell SupportAssist

### Download
```
https://downloads.dell.com/serviceability/catalog/SupportAssistInstaller.exe
```
~1.5 MB, download direto funciona.

### Instalação silenciosa
```cmd
SupportAssistInstaller.exe /VERYSILENT
```

### Serviços que rodam após instalar
- `SupportAssistAgent.exe` — serviço de scan automático
- `SupportAssistUI.exe` — interface gráfica
- `SupportAssistHardwareDiag` — diagnóstico de hardware

### Como usar (remoto/automatizado)
1. Instalar silenciosamente
2. Abrir via caminho: `C:\Program Files\Dell\SupportAssistAgent\bin\SupportAssist.exe`
3. Esperar scan inicial (roda automaticamente)
4. Verificar resultado do scan
5. Revisar TODOS os updates (scrollar!)
6. Instalar

### ⚠️ Atenção
- **BIOS update** aparece na lista → SEMPRE avisar antes
- Suporte a driver de WiFi/Bluetooth pode identificar chip errado (ex: QCA61x4A vs QCA9565)
- Sempre maximizar e scrollar antes de clicar Instalar

---

## 🟡 Nível 2: Intel Driver & Support Assistant

### Download
```
https://www.intel.com/content/www/us/en/support/detect.html
```

### Quando usar
- Qualquer máquina com CPU Intel (integrada, WiFi Intel, chipset)
- Após o SupportAssist (ou quando não for Dell)
- Drivers de GPU Intel HD/Iris, chipset, WiFi Intel, Bluetooth Intel

### Limitações
- Não detecta drivers de terceiros (Realtek, Qualcomm)
- Interface web-based, pode ser pesada

---

## 🟡 Nível 3: Windows Update

### Como usar
```powershell
# Forçar verificação
usoclient StartScan

# Ver updates pendentes
Get-WindowsUpdate
```

### O que o Windows Update atualiza
- Drivers WHQL certificados
- Atualizações de segurança
- Atualizações cumulativas

### Limitações
- Drivers nem sempre são os mais recentes
- Alguns fabricantes não publicam no WU

---

## 🔥 Nível 4: Site do Fabricante (último recurso)

### Problemas conhecidos
| Fabricante | Problema |
|-----------|---------|
| **Dell** | Bloqueia VPS (403). URL direta do driver dá 404 |
| **HP** | Exige detection via site |
| **Lenovo** | Download center complexo |
| **Acer** | Driving detection tool própria |

### Quando NÃO usar
- Não estamos num browser interativo humano
- O cliente não está disponível pra interagir
- Tempo é limitado

### Workaround para Dell
Se absolutamente necessário, usar o Service Tag:
```
https://www.dell.com/support/home/pt-br/product-support/servicetag/<SERVICE_TAG>/drivers
```
Mas isso **NÃO funciona** pra download automatizado — precisa de interação manual.

---

## ⚡ BIOS Update — Checklist

1. ✅ **Backup completo** dos dados do usuário (Downloads, Documentos, Desktop)
2. ✅ **Avisar o cliente** que a máquina vai reiniciar
3. ✅ **Confirmar** que o cliente está ciente dos riscos
4. ✅ **Não desligar** durante o flash (pode brickar)
5. ✅ **Esperar** — o reboot pode levar 3-5 minutos
6. ✅ **Verificar versão** pós-reboot (`wmic bios get smbiosbiosversion`)

---

## 🛠️ Comandos Úteis

### Verificar versão de driver
```cmd
driverquery /v | findstr /i "qualcomm realtek intel"
```

### Verificar data do arquivo de driver
```cmd
dir C:\Windows\system32\drivers\*.sys | findstr /i "ath rt"
```

### Verificar versão da BIOS
```cmd
wmic bios get smbiosbiosversion
```

### Verificar modelo da máquina
```cmd
wmic computersystem get model,manufacturer
```

### Verificar Service Tag (Dell)
```cmd
wmic bios get serialnumber
```

---

## 📝 Caso Real — DESKTOP-PDSLIJO (31/05/2026)

### Máquina
- Dell Inspiron 15-3567 (Service Tag: 56WXWQ2)
- i3-7020U, Qualcomm QCA9565 WiFi, Realtek Audio/Ethernet

### O que foi tentado (e falhou)
1. ❌ Baixar driver manualmente pelo Service Tag — Dell bloqueou VPS (403)
2. ❌ URL direta do driver (ex: `downloads.dell.com/FOLDER.../driver.cab`) — deu 404
3. ❌ Compress-Archive do PowerShell — bug DateTimeOffset em arquivos antigos

### O que funcionou
1. ✅ SupportAssist baixado e instalado silenciosamente
2. ✅ Scan automático encontrou 5 atualizações
3. ✅ Todas as 5 instaladas com sucesso
4. ✅ BIOS flashada de versão antiga → 2.19.0

### O que ficou pendente
- ⚠️ QCA9565 WiFi driver — SupportAssist trouxe QCA61x4A (chip diferente)
- ⚠️ Realtek Ethernet (rt640x64.sys) — continua versão 2016

---

## 🚫 Regras de Backup (durante manutenção)

- **NUNCA** salvar backup na VPS/ambiente PC Resolve
- **SEMPRE** instruir cliente: pendrive, HD externo, Google Drive, OneDrive
- Backup no mesmo disco **não é backup**
- Exceção de salvar na VPS: só com autorização explícita do Zanatto
- Se salvou na VPS por exceção: **deletar depois** que cliente confirmou

# 📎 Microsoft Office — Guia Completo HelpDesk

> Instalação, ativação, atualização, reparo, desinstalação e troubleshooting.
> Versões: Microsoft 365, Office 2021/2019/2016.
> Atualizado: 31/05/2026

---

## 🟢 NÍVEL 1 — Versões e Licenciamento

### O ecossistema Office

| Produto | Modelo | Atualizações | Licença |
|---------|--------|-------------|---------|
| **Microsoft 365** (antes Office 365) | Assinatura | Constantes | Por usuário (5 PCs) |
| **Office 2021** (LTSC) | Perpétuo | Segurança só | Por dispositivo |
| **Office 2019** | Perpétuo | Segurança só | Por dispositivo |
| **Office 2016** | Perpétuo | Fim do suporte: Out/2025 | Por dispositivo |
| **Office Online** | Gratuito | N/A | Conta Microsoft |

### Qual escolher?

```
Microsoft 365 → Sempre atualizado, 1TB OneDrive, 5 dispositivos, suporte
Office 2021   → Pagou uma vez, usa pra sempre, sem features novas
Office Online → Grátis, navegador, limitado (mas resolve 80% dos casos!)
```

### Tecnologia de Instalação

| Tipo | Extensão | Como identificar |
|------|----------|-----------------|
| **Click-to-Run (C2R)** | .exe (streaming) | Pasta `C:\Program Files\Microsoft Office\root\` |
| **MSI (Windows Installer)** | .msi | Pasta `C:\Program Files\Microsoft Office\Office16\` |
| **Microsoft Store** | AppX | Apps individuais (Word, Excel, PowerPoint) |

⚠️ **C2R e MSI NÃO podem coexistir** no mesmo PC. Um quebra o outro.

---

## 🟡 NÍVEL 2 — Instalação e Configuração

### Método 1: Microsoft 365 — Instalação Padrão

```powershell
# 1. Acessar portal.office.com
# 2. Login com conta Microsoft 365
# 3. "Instalar aplicativos" → baixa setup stub
# 4. Executar: o instalador baixa e instala automaticamente

# Linha de comando (se tiver o instalador):
Setup.exe /configure configuration.xml
```

### Método 2: Office Deployment Tool (ODT) — CONTROLE TOTAL

```xml
<!-- configuration.xml -->
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="pt-br" />
      <Language ID="en-us" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Groove" />
    </Product>
  </Add>
  <Updates Enabled="TRUE" Channel="Current" />
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
```

```cmd
:: Download dos arquivos de instalação
setup.exe /download configuration.xml

:: Instalar silencioso
setup.exe /configure configuration.xml

:: Instalar com interface (modo assistido)
setup.exe /configure configuration.xml /display Full
```

**Channels (canais de atualização):**
```
Current        → Novidades mensais (padrão consumidor)
Monthly Enterprise → Novidades mensais com atraso de 1 mês
Semi-Annual Enterprise → Duas vezes por ano (empresas conservadoras)
Semi-Annual Enterprise (Preview) → Teste antes do Semi-Annual
```

### Método 3: Winget (Windows Package Manager)

```powershell
# Buscar
winget search "Microsoft 365"

# Instalar Microsoft 365 Apps for Enterprise
winget install "Microsoft 365 Apps for enterprise" --silent

# Instalar idioma específico
winget install "Microsoft 365 Apps for enterprise" --override "/configure config.xml"
```

### Método 4: Office 2021/2019 (Licença Perpétua)

```xml
<!-- configuration-2021.xml -->
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    <Product ID="ProPlus2021Volume" PIDKEY="XXXXX-XXXXX-XXXXX-XXXXX-XXXXX">
      <Language ID="pt-br" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
```

---

## 🔥 NÍVEL 3 — Ativação e Licenciamento

### Verificar status de ativação

```powershell
# Via PowerShell (precisa do módulo Office)
# Abrir qualquer app Office → Arquivo → Conta → Informações do Produto

# Linha de comando:
cd "C:\Program Files\Microsoft Office\Office16"
cscript ospp.vbs /dstatus          # Status detalhado
cscript ospp.vbs /dstatusall        # Todas licenças instaladas
```

```cmd
:: Caminho típico (varia com versão):
:: Office 365/2021/2019 C2R:
cd "C:\Program Files\Microsoft Office\Office16"
cscript ospp.vbs /dstatus

:: Office 2016 MSI:
cd "C:\Program Files\Microsoft Office\Office16"
cscript ospp.vbs /dstatus
```

### Problemas de Ativação

**Erro clássico: "Produto Não Licenciado"**
```cmd
# 1. Verificar se é assinatura ou perpétuo
cscript ospp.vbs /dstatus

# 2. Se Microsoft 365: verificar assinatura
# portal.office.com → Minha Conta → Assinaturas

# 3. Reativar
cscript ospp.vbs /act

# 4. Se falhar, limpar e reativar:
cscript ospp.vbs /unpkey:XXXXX     # Remove key do produto (pegar últ. 5 chars do /dstatus)
cscript ospp.vbs /act               # Reativar
```

**Erro: "Atingido o limite de ativações"**
```
Microsoft 365 permite 5 PCs por usuário.
→ portal.office.com → Dispositivos → Remover PCs antigos
→ Reinstalar Office e logar novamente
```

**Erro: "Não é possível verificar a licença" (erro 0x80070005)**
```cmd
# Limpar credenciais e tentar de novo
# Painel de Controle → Gerenciador de Credenciais → 
# Remover credenciais "MicrosoftOffice16_Data:..."
# Depois reabrir qualquer app Office e logar
```

### Licenças Perpétuas (Office 2021/2019) — Ativação por Telefone
```cmd
cscript ospp.vbs /dstatus          # Anotar ID da Instalação
slui 4                              # Assistente de ativação por telefone
# Seguir instruções na tela
```

---

## ⚡ NÍVEL 4 — Reparo e Troubleshooting Jedi

### Sequência de Reparo (da mais suave à mais agressiva)

```
1. Quick Repair (rápido, 2 min)      → 80% dos casos
2. Online Repair (lento, 15-30 min)  → 95% dos casos
3. SARA Tool (Microsoft)             → casos persistentes
4. Desinstalar + limpar vestígios + reinstalar → 99% dos casos
5. Office Scrub (limpeza total)      → casos extremos
```

### Quick Repair vs Online Repair

```cmd
# Quick Repair: rápido, não precisa de internet, não perde dados
# Configurações → Aplicativos → Microsoft 365 → Modificar → Reparo Rápido

# Online Repair: baixa arquivos, mais completo, NÃO perde dados
# Configurações → Aplicativos → Microsoft 365 → Modificar → Reparo Online
```

```powershell
# Via linha de comando:
# Quick Repair
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeClickToRun.exe" scenario=Repair platform=Repair type=QuickRepair culture=pt-br RepairTrigger=UpdateUI

# Online Repair
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeClickToRun.exe" scenario=Repair platform=Repair type=FullRepair culture=pt-br RepairTrigger=UpdateUI
```

### SARA Tool (Microsoft Support and Recovery Assistant)

```
Download: https://aka.ms/SaRA-officeUninstallFromPC
→ Abrir → selecionar "Office" → "Já instalei o Office mas não consigo ativar"
→ Segue o passo a passo automatizado
```

**Ações da SARA:**
- Remove completamente o Office
- Limpa registry de vestígios
- Remove chaves de ativação corrompidas
- Remove scheduled tasks do Office
- Prepara para reinstalação limpa

### Desinstalação Manual Completa

```powershell
# 1. Desinstalar via Painel de Controle ou:
# Configurações → Aplicativos → Microsoft 365 → Desinstalar

# 2. Se falhar, usar Microsoft Recovery Assistant:
# https://aka.ms/SaRA-officeUninstallFromPC
# "Office" → "Remover o Office"

# 3. Limpeza manual de vestígios (após desinstalação):
# Parar serviço
Stop-Service ClickToRunSvc -Force -ErrorAction SilentlyContinue

# Remover pastas
Remove-Item "C:\Program Files\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Program Files (x86)\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LocalAppData\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue

# Limpar registry (CUIDADO!)
Remove-Item "HKCU:\Software\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "HKLM:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue

# Limpar scheduler tasks
Get-ScheduledTask -TaskPath "\Microsoft\Office\" | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue
```

### Office Scrub (Desinstalação Total) — Script Microsoft

```cmd
:: Baixar e executar o script oficial:
:: https://aka.ms/SaRA-officeUninstallFromPC

:: Ou manual usando ODT:
setup.exe /configure remove-all.xml
```

```xml
<!-- remove-all.xml -->
<Configuration>
  <Remove All="TRUE" />
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
```

---

## 🎯 Problemas Comuns e Soluções

### "O Office para de responder / trava"

```
1. Desabilitar aceleração de hardware:
   Arquivo → Opções → Avançado → Exibir → 
   ☑ Desabilitar aceleração gráfica de hardware

2. Desabilitar add-ins:
   Arquivo → Opções → Suplementos → 
   Gerenciar: Suplementos COM → Ir → Desmarcar todos

3. Modo Seguro do Office:
   Win+R → winword /safe
   Win+R → excel /safe
   Se funcionar = add-in culpado

4. Recriar perfil:
   Fechar Office → Regedit →
   HKCU\Software\Microsoft\Office\16.0\ → renomear pra 16.0_old
   Reabrir Office
```

### "Não consigo instalar/atualizar"

```
Causas e soluções:
1. ClickToRunSvc parado:
   services.msc → Microsoft Office Click-to-Run Service → Iniciar

2. Office antigo (MSI) conflitando:
   Desinstalar versão MSI antes de instalar C2R

3. Windows Installer quebrado:
   msiexec /unregister → msiexec /regserver

4. Falta de espaço:
   10 GB livres mínimos recomendados

5. Proxy/VPN bloqueando:
   Verificar netsh winhttp show proxy
```

### "O Word/Excel abre em branco / não carrega arquivo"

```
1. Word/Excel Safe Mode: winword /safe
2. Desabilitar add-ins (COM e VBA)
3. Resetar chave de registro Data (HKCU\...\Office\16.0\Word\Data)
4. Reparar Office (Quick Repair)
5. Se arquivo específico: pode estar corrompido
```

### "Erro 0-1018, 30088-4, 30183-9 durante instalação"

```
- Desconectar VPN/Proxy
- Desabilitar antivírus temporariamente
- Executar como administrador
- Usar Office Deployment Tool (offline)
- Limpar %TEMP% antes de tentar
```

### "Outlook não conecta / perfil corrompido"

```
1. Recriar perfil:
   Painel de Controle → Mail (32-bit) → Mostrar Perfis → 
   Remover perfil → Adicionar novo

2. Verificar credenciais:
   Gerenciador de Credenciais → remover credenciais Outlook

3. Modo Seguro: outlook /safe

4. ScanPST (reparar arquivo .pst/.ost):
   "C:\Program Files\Microsoft Office\root\Office16\SCANPST.EXE"
```

---

## 🔄 Atualizações do Office

### Verificar e forçar atualização

```powershell
# Arquivo → Conta → Opções de Atualização → Atualizar Agora

# Linha de comando:
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe" /update user updatetoversion=16.0.xxxxx.xxxx

# Ver versão instalada:
# Qualquer app Office → Arquivo → Conta → Sobre o [App]
```

### Gerenciar atualizações via ODT
```cmd
:: Forçar canal específico
setup.exe /configure change-channel.xml
```

```xml
<!-- change-channel.xml -->
<Configuration>
  <Updates Enabled="TRUE" Channel="MonthlyEnterprise" />
</Configuration>
```

### Pausar/Retomar atualizações
```powershell
# Desabilitar atualizações
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe" /changesetting Channel=Broad

# Ou pelo GPO/Registry:
# HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\OfficeUpdate
# DWORD: EnableAutomaticUpdates = 0
```

---

## 📊 Diagnóstico Rápido — Script

```powershell
function Test-OfficeHealth {
    Write-Host "=== DIAGNÓSTICO OFFICE ===" -Foreground Cyan
    
    # Versão e build
    $officePath = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
    if (Test-Path $officePath) {
        $version = (Get-Item $officePath).VersionInfo
        Write-Host "`nOffice: $($version.ProductName) v$($version.ProductVersion)"
    } else {
        Write-Host "`n❌ Office não encontrado no caminho padrão"
    }
    
    # Click-to-Run Service
    $c2r = Get-Service ClickToRunSvc -ErrorAction SilentlyContinue
    Write-Host "ClickToRun Service: $(if($c2r.Status -eq 'Running'){'✅'}else{'❌'}) $($c2r.Status)"
    
    # Tipo de instalação
    if (Test-Path "C:\Program Files\Microsoft Office\root\Office16") {
        Write-Host "Tipo: Click-to-Run"
    } elseif (Test-Path "C:\Program Files\Microsoft Office\Office16") {
        Write-Host "Tipo: MSI"
    } else {
        Write-Host "Tipo: Desconhecido"
    }
    
    # Ativação
    $ospp = "C:\Program Files\Microsoft Office\Office16\OSPP.VBS"
    if (Test-Path $ospp) {
        Write-Host "`nStatus de licenciamento:"
        $result = cscript $ospp /dstatus //Nologo 2>&1
        $result | Select-String "LICENSE STATUS|ERROR CODE|Last 5" | ForEach-Object { Write-Host "  $_" }
    }
    
    # Add-ins problemáticos
    Write-Host "`nVerificando add-ins (pode demorar)..."
    $comAddins = "HKCU:\Software\Microsoft\Office\16.0\Word\Addins"
    if (Test-Path $comAddins) {
        Get-ChildItem $comAddins -ErrorAction SilentlyContinue | ForEach-Object {
            $load = Get-ItemProperty "$($_.PSPath)" -Name LoadBehavior -ErrorAction SilentlyContinue
            if ($load.LoadBehavior -eq 3) {
                Write-Host "  ⚠️ $($_.PSChildName) (carregado automaticamente)"
            }
        }
    }
    
    # Atualizações pendentes
    Write-Host "`nDica: Office → Arquivo → Conta → Atualizar Agora (verificar updates)"
}
```

---

## 🛠️ Linha de Comando — Comandos Úteis

```cmd
:: Office apps via linha de comando:
winword /safe              → Word em modo seguro
winword /a                 → Word sem add-ins
excel /safe                → Excel em modo seguro
excel /r "arquivo.xlsx"    → Abrir como somente leitura
outlook /safe              → Outlook modo seguro
outlook /cleanviews        → Resetar views do Outlook
outlook /resetnavpane      → Resetar painel de navegação
powerpnt /safe             → PowerPoint modo seguro
mspub /safe                → Publisher modo seguro

:: Comandos do ClickToRun:
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe" /update user
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeClickToRun.exe" scenario=Repair platform=Repair type=QuickRepair culture=pt-br RepairTrigger=UpdateUI
```

---

## ⚠️ Dicas Jedi

- **Office C2R e MSI NÃO COEXISTEM.** Se tentar instalar um com o outro = conflito na certa.
- **Outlook .ost/.pst > 50GB** → lentidão. Compactar ou arquivar.
- **Add-ins COM são a causa #1** de crash/travamento. Sempre testar no Safe Mode.
- **Microsoft 365 Admin Center** (admin.microsoft.com) gerencia licenças e instalações de toda a empresa.
- **Office Online (gratuito)** resolve 80% das necessidades sem instalar nada. Use como fallback.
- **ODT (Office Deployment Tool)** é o jeito certo de instalar em lote. Fuja do instalador padrão se precisar de controle.
- **Limpeza de vestígios** é essencial: Office deixa rastros em registry, %ProgramData%, %LocalAppData%, Tasks, e Services.
- **Nunca delete manualmente** a pasta do Office sem antes parar o ClickToRunSvc. Vai dar erro 30068.

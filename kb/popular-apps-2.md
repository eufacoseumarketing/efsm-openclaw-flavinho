# 📦 Aplicativos Populares — Parte 2 (Brasil)

> Certificado digital, Java, apps de governo, bancos, dependências.
> Complementa `kb/popular-apps.md`.
> Atualizado: 31/05/2026

---

## 📊 Mais Apps que Geram Suporte (Brasil)

| # | App | Categoria | Carga |
|---|-----|-----------|-------|
| 12 | Certificado Digital (ICP-Brasil) | Segurança/Gov | 🔥🔥🔥 Altíssima |
| 13 | Java Runtime (JRE) | Dependência | 🔥🔥 Alta |
| 14 | Apps da Receita/Governo | Governo | 🔥🔥 Alta |
| 15 | Plugins de Banco (Warsaw/Gas) | Bancos | 🔥🔥 Alta |
| 16 | Nota Fiscal Eletrônica (NF-e) | Empresarial | 🔥 Média |
| 17 | Visual C++ / .NET Framework | Dependência | 🟢 Média |

---

## 🔐 Certificado Digital (ICP-Brasil)

### O ecossistema

```
Tipos:
A1 → Arquivo (instalado no PC, senha)
A3 → Token USB ou SmartCard (mídia criptográfica)

Marcas comuns de token:
- SafeNet (eToken)    → driver: SafeNet Authentication Client
- Gemalto (IDPrime)   → driver: Gemalto Classic Client / SafeNet
- Certisign           → driver próprio
- Serasa Experian     → driver próprio
```

### Instalação do Certificado A3 (Token)

```powershell
# Passo 1: Instalar driver do token ANTES de plugar
# SafeNet: https://www.thalesdocs.com/gphsm/etoken/sac/10.8/index.html
# Gemalto: https://www.thalesgroup.com/en/markets/digital-identity-and-security

# Passo 2: Plugue o token USB → Windows reconhece

# Passo 3: Instalar cadeia de certificados ICP-Brasil
# https://www.gov.br/iti/pt-br/assuntos/cadeia-de-certificados
# Baixar e instalar TODOS os certificados da cadeia (raiz + intermediárias)

# Passo 4: Verificar se o certificado aparece
certmgr.msc → Pessoal → Certificados → ver se tem o seu

# Passo 5: Testar com o app que vai usar
```

### Verificar Certificado via Linha de Comando
```cmd
:: Listar certificados pessoais
certutil -store -user My

:: Ver detalhes de um certificado específico
certutil -user -repairstore My "NUMERO_SERIAL"

:: Verificar cadeia completa
certutil -verify -urlfetch cert.cer

:: Exportar certificado (backup!)
certutil -exportPFX -p "senha" My NUMERO_SERIAL C:\backup\meucert.pfx
```

### Problemas Comuns (TOP 5)

**1. "Token não é reconhecido" / "Dispositivo não encontrado"**
```
Causas:
- Driver não instalado
- USB com mau contato / porta USB ruim
- Token quebrado (LED não acende?)
- Windows Update removeu o driver

Solução:
1. Tentar outra porta USB (de preferência traseira do desktop)
2. Reinstalar driver do token (SafeNet/Gemalto/Certisign)
3. Verificar no Gerenciador de Dispositivos → Leitores de Cartão Inteligente
4. Se não aparece = token pode estar morto
```

**2. "Certificado aparece mas não funciona" / Erro de assinatura**
```
1. Verificar validade (certmgr.msc → duplo clique → ver data)
2. Verificar se a cadeia ICP-Brasil tá completa:
   Certmgr.msc → clicar no cert → Caminho de Certificação → tudo OK?
   Se tem ❌ = falta certificado intermediário
3. Baixar cadeia completa: https://www.gov.br/iti
4. Testar em outro navegador (Chrome, Edge, Firefox)
```

**3. "Senha do certificado não funciona"**
```
- Máximo de tentativas: 3 (A3, token)
- Se PIN bloqueado → precisa desbloquear com PUK (código de desbloqueio)
- Se não tem PUK → contatar certificadora (Certisign, Serasa, etc.)
- Se Pin+PUK bloqueados → certificado PERDIDO. Emitir novo.
```

**4. "Certificado A1 sumiu após formatar o PC"**
```
- Certificado A1 É UM ARQUIVO. Se não fez backup (.pfx) = PERDEU.
- Se fez backup → importar: certmgr.msc → botão direito em Pessoal → Importar
- Sem backup = emitir novo certificado
- LIÇÃO: Sempre exportar .pfx com senha e guardar em local seguro!
```

**5. "Firefox/Chrome não encontram o certificado"**
```
- Firefox NÃO usa o repositório do Windows por padrão.
  about:preferences#privacy → Certificados → Dispositivos de Segurança → 
  Carregar "C:\Windows\System32\opensc-pkcs11.dll" (ou driver do token)

- Chrome/Edge usam o repositório do Windows (certmgr.msc).
  Se não aparece no certmgr, não vai aparecer no Chrome.
```

---

## ☕ Java Runtime (JRE)

### Por que Java ainda existe?
```
Muitos apps brasileiros são Java:
- IRPF (Receita Federal)
- Conectividade Social / SEFIP (Caixa)
- Sistemas contábeis (Domínio, Alterdata, Questor)
- Sistemas de RH/ponto eletrônico
- PJe (Processo Judicial Eletrônico)
```

### Instalação

```powershell
# Winget
winget install Oracle.JavaRuntimeEnvironment

# Site oficial: https://www.java.com/download

# Instalar silencioso
$url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=xxxxx"
$out = "$env:TEMP\JavaSetup.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/s" -Wait

# Verificar versão instalada
java -version
```

### Problemas Comuns

**"Java não abre" / "Erro de Java"**
```
- Desinstalar TODAS as versões antigas → instalar a mais recente
- Limpar cache Java: Painel de Controle → Java → Geral → Configurações → Excluir Arquivos
- Adicionar site/app na lista de exceções: Java → Segurança → Lista de Sites de Exceção
- Verificar variável JAVA_HOME (se configurada errada)
```

**"App Java pede versão específica"**
```
- Apps antigos exigem Java 8 (não 11/17/21)
- Instalar múltiplas versões é possível, mas configuração é chata
- Preferível: instalar só a versão que o app pede
- Java 8: https://www.java.com/download/ie_manual.jsp
```

**"Aplicativo bloqueado pela segurança do Java"**
```
Painel de Controle → Java → Segurança → 
- Adicionar URL à Lista de Sites de Exceção
- OU baixar nível de segurança para "Médio" (Menos seguro, cuidado!)
```

---

## 🏛️ Apps de Governo

### Conectividade Social / SEFIP (FGTS) — Caixa Econômica

```
Problema clássico: "ICP não funciona no Conectividade Social"

Solução:
1. Verificar se o certificado aparece no certmgr.msc
2. Conectividade Social → Configurações → Certificado Digital → Selecionar
3. Verificar se driver do token é compatível com o app (SafeNet, Gemalto)
4. Se nada funcionar: tentar em outro PC com Windows 10 (app é legado)
5. Alternativa: portal Conectividade Social versão web (gov.br)
```

### eSocial / EFD-Reinf

```
Problema: "Certificado não funciona no portal"

1. Verificar cadeia ICP-Brasil completa
2. Firefox: about:preferences#privacy → carregar módulo PKCS#11 do token
3. Chrome/Edge: já usa repo do Windows
4. Limpar cache do navegador, tentar guia anônima
```

### PJe (Processo Judicial Eletrônico)

```
Problema: "PJe não abre" / "Assinatura não funciona"

1. PJeOffice (assinador): baixar do site do tribunal
2. Firefox ESR ou Chrome específicos (alguns tribunais exigem)
3. Java: precisa estar instalado (alguns PJe ainda usam Java)
4. Token: driver correto, cadeia ICP completa
```

---

## 🏦 Plugins Bancários (Warsaw / Gas / Diebold)

### O que são
```
Warsaw (antigo G-Buster) → "Módulo de Segurança" → Itaú, BB, Caixa, Santander
Gas Tecnologia             → "Módulo de Segurança" → Bradesco, bancos menores
Diebold                    → "Módulo de Proteção"   → Diversos bancos

⚠️ Esses "módulos de segurança" são ESSENCIAIS pra acessar internet banking.
E são uma das maiores causas de problema no Windows.
```

### Problemas Comuns

**"Banco não abre / pede pra instalar módulo de segurança"**
```
1. Desinstalar completamente (Painel de Controle → Programas)
2. Reinstalar do site oficial do banco
3. Verificar se serviço Warsaw/Gas tá rodando: services.msc
4. Se não rodar: iniciar serviço manualmente

Solução radical (Warsaw):
sc stop "Warsaw Core" & sc start "Warsaw Core"
```

**"Módulo de segurança bloqueia acesso"**
```
- Warsaw/Gas podem bloquear TeamViewer, AnyDesk, outros
- Configuração de Proxy: o módulo inspeciona HTTPS (MITM)
- Se tá dando erro de certificado em vários sites = módulo fazendo MITM
```

**"Warsaw não desinstala"** (problema clássico!)
```
1. Painel de Controle → Desinstalar
2. Se falhar: baixar o desinstalador oficial do site da Diebold
3. Remover serviços: sc delete "Warsaw Core"
4. Limpar pastas: C:\Program Files\Diebold\Warsaw\
5. Limpar registry: HKLM\SOFTWARE\Diebold\
```

**"Módulo de segurança + certificado digital = conflito"**
```
- ⚠️ COMBINAÇÃO EXPLOSIVA
- Warsaw inspeciona tráfego HTTPS → pode interferir na comunicação do token
- Solução: desabilitar temporariamente o módulo para usar certificado
- Ou usar navegador diferente (Firefox, que o módulo não inspeciona)
```

---

## 🧾 Nota Fiscal Eletrônica (NF-e / NFC-e / CT-e)

### Software Emissor
```
Marcas comuns:
- Sapeka (Thomson Reuters)      → um dos mais instalados
- Tecnospeed / MasterSAF        → outro bem comum
- Tron Informática              → pequenas/médias
- Emissor gratuito da SEFAZ     → cada estado tem o seu
- Nota Fiscal Fácil (NFF)       → MEI, gratuito
```

### Problemas Comuns

**"Emissor de NF-e não abre"**
```
- Java! Quase todos usam Java. Verificar versão.
- Certificado digital → token plugado, driver ok, cadeia ICP ok
- Data/hora do PC correta (assinatura digital exige!)
```

**"Erro ao transmitir NF-e"**
```
- Verificar internet
- Verificar se certificado é do CNPJ correto
- SEFAZ fora do ar? (comum, tentar mais tarde)
- Data/hora do PC correta? (se estiver errada, certificado falha)
- Proxy/VPN? Desabilitar
```

**"Certificado não aparece no emissor"**
```
- Verificar se aparece no certmgr.msc primeiro
- Verificar se o emissor tem configuração de certificado → selecionar manualmente
- Token no modo certo? (SafeNet pode estar em modo KSP ou PKCS#11)
```

---

## 🧩 Dependências do Windows (Visual C++ / .NET)

### Problema Clássico
```
"Instalei o programa mas ele não abre"
"Aplicativo não foi iniciado corretamente (0xc000007b)"
"Falta MSVCP140.dll / VCRUNTIME140.dll"
```

### Visual C++ Redistributables

```powershell
# Instalar TODOS de uma vez (AIO Installer)
# https://github.com/abbodi1406/vcredist/releases

# Ou via winget:
winget install Microsoft.VCRedist.2015+.x64
winget install Microsoft.VCRedist.2015+.x86
winget install Microsoft.VCRedist.2013.x64
winget install Microsoft.VCRedist.2013.x86
winget install Microsoft.VCRedist.2012.x64
winget install Microsoft.VCRedist.2012.x86
winget install Microsoft.VCRedist.2010.x64
winget install Microsoft.VCRedist.2010.x86
```

### .NET Framework

```powershell
# Verificar versões instaladas
Get-ChildItem "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP" -Recurse | 
    Get-ItemProperty -Name Version -ErrorAction SilentlyContinue | 
    Where-Object Version | Select PSChildName, Version

# Habilitar .NET 3.5 (muitos apps legados precisam!)
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All

# .NET Framework Repair Tool (Microsoft)
# https://www.microsoft.com/download/details.aspx?id=30135
```

### DirectX
```powershell
# Apps/jogos antigos às vezes precisam de DirectX 9
# Instalador oficial da Microsoft:
# https://www.microsoft.com/download/details.aspx?id=35
```

---

## 📝 Script — Verificador de Dependências

```powershell
function Test-Dependencies {
    Write-Host "=== DEPENDÊNCIAS DO SISTEMA ===" -Foreground Cyan
    
    # Java
    $java = Get-Command java -ErrorAction SilentlyContinue
    if ($java) {
        $ver = (& java -version) 2>&1 | Select-String "version"
        Write-Host "Java: ✅ $ver"
    } else { Write-Host "Java: ❌ NÃO INSTALADO" }
    
    # .NET Framework
    $dotnet = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue
    if ($dotnet) {
        Write-Host ".NET Framework: ✅ v$($dotnet.Version)"
    } else { Write-Host ".NET Framework: ❌ NÃO ENCONTRADO" }
    
    # Visual C++
    $vc = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
        Where-Object DisplayName -like "*Visual C++*" | Measure-Object
    Write-Host "Visual C++ Redist: $($vc.Count) instalados $(if($vc.Count -lt 5){'⚠️ POUCOS'})"
    
    # Certificado Digital
    $certs = certutil -store -user My 2>&1 | Select-String "Serial"
    Write-Host "Certificados Digitais: $($certs.Count) encontrados"
    
    # Warsaw/Gas (bancos)
    $warsaw = Get-Service -Name "*Warsaw*" -ErrorAction SilentlyContinue
    $gas = Get-Service -Name "*Gas*" -ErrorAction SilentlyContinue
    if ($warsaw) { Write-Host "Warsaw (Diebold): ⚠️ Instalado" }
    if ($gas) { Write-Host "Gas Tecnologia: ⚠️ Instalado" }
    if (-not $warsaw -and -not $gas) { Write-Host "Módulos bancários: ✅ Nenhum" }
    
    # NF-e (verificar pastas comuns)
    $nfeApps = @(
        "C:\Sapeka", "C:\MasterSAF", "C:\TecnoSpeed",
        "C:\Program Files\Sapeka", "C:\Program Files\MasterSAF"
    )
    $found = $nfeApps | Where-Object { Test-Path $_ }
    if ($found) { Write-Host "Emissor NF-e: ⚠️ $($found -join ', ')" }
    
    Write-Host "`nDica: Problemas com apps Java? Reinstale o Java."
    Write-Host "Dica: 'Falta DLL'? Instale Visual C++ Redistributables."
}
```

---

## 🎯 Guia Rápido por Sintoma

| Sintoma | Causa Provável | Solução |
|---------|---------------|---------|
| "Token não reconhecido" | Driver faltando | Instalar SafeNet/Gemalto driver |
| "Certificado não aparece" | Cadeia ICP incompleta | Instalar cadeia do ITI |
| "App Java não abre" | Java errado ou cache | Desinstalar Java → instalar versão certa |
| "Módulo de segurança quebrou" | Warsaw/Gas corrompido | Desinstalar + reinstalar do banco |
| "NF-e não transmite" | SEFAZ offline / cert errado | Verificar SEFAZ, data/hora, cert |
| "Erro 0xc000007b" | Falta Visual C++ | Instalar todos VCRedist |
| "Falta DLL" | Visual C++ ou .NET | Ver qual DLL no Google + instalar pacote |
| "App pede .NET 3.5" | Windows não tem | `Enable-WindowsOptionalFeature -Online NetFx3` |

---

## ⚠️ Dicas Jedi

- **Certificado digital A1 SEM BACKUP = PERDA TOTAL.** Sempre orientar o cliente a exportar .pfx.
- **Java é a causa raiz de 30% dos problemas** com apps brasileiros. Cache Java corrompido é o vilão.
- **Warsaw/Gas = MITM.** Eles inspecionam tráfego HTTPS. Se der erro de certificado estranho, desconfie deles.
- **Data e hora do Windows ERRADAS** = assinatura digital falha, sites não abrem, certificados não funcionam.
- **Visual C++ AIO Installer** resolve 99% dos "falta DLL" com um clique.

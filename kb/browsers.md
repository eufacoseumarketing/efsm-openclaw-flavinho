# 🌐 Navegadores — Guia Completo HelpDesk

> Edge, Chrome, Firefox. Lentidão, crashes, extensões maliciosas, cache, perfil corrompido.
> Atualizado: 31/05/2026

---

## 🟢 NÍVEL 1 — Fundamentos

### Os 3 Grandes

| Navegador | Engine | Dona | Peso RAM |
|-----------|--------|------|----------|
| **Edge** | Chromium (Blink) | Microsoft | ⭐ Menos (gerenciamento de abas inativas nativo) |
| **Chrome** | Chromium (Blink) | Google | ⭐⭐⭐ Pesado |
| **Firefox** | Gecko (Quantum) | Mozilla | ⭐⭐ Médio |

> Edge e Chrome usam a MESMA engine (Chromium). Extensões compatíveis, mesma base.  
> Firefox é independente — engine própria, foco em privacidade.

### Por que navegador fica lento?

```
1. MUITAS ABAS ABERTAS           → cada aba = 100-300 MB RAM
2. Extensões pesadas/maliciosas  → 5+ extensões = impacto real
3. Cache gigante/corrompido      → navegador lê disco errado
4. Hardware acceleration bugada  → GPU driver problemático
5. Malware (adware, hijacker)    → redireciona, injeta anúncios
6. Perfil de usuário corrompido  → crash, lentidão inexplicável
7. Sync travado                  → sincronizando eternamente
8. DNS lento / proxy             → não é o navegador, é a rede!
```

---

## 🟡 NÍVEL 2 — Comandos e Configurações

### Edge — Flags e Configurações

```cmd
:: Abrir Edge com perfil limpo (modo diagnóstico)
msedge --temp-profile
msedge --inprivate

:: Desabilitar aceleração de hardware
msedge --disable-gpu

:: Resetar flags experimentais
msedge --disable-features=msEdgeFlagReset

:: Limpar cache DNS e socket pools
msedge --disable-features=msEdgeDNS

:: Abrir Edge em modo "limpo total"
msedge --no-experiments --disable-extensions --disable-sync --disable-features=All
```

```powershell
# Edge: locais importantes
# Perfil: %LocalAppData%\Microsoft\Edge\User Data\
# Cache:  %LocalAppData%\Microsoft\Edge\User Data\Default\Cache
# Extensões: %LocalAppData%\Microsoft\Edge\User Data\Default\Extensions

# Resetar Edge sem perder favoritos (via Configurações):
# edge://settings/reset → "Restaurar configurações para os padrões originais"
```

### Chrome — Flags e Configurações

```cmd
:: Abrir Chrome com perfil limpo
chrome --temp-profile
chrome --incognito

:: Desabilitar aceleração de hardware
chrome --disable-gpu

:: Resetar tudo
chrome --reset-variation-state

:: Chrome limpo máximo
chrome --disable-extensions --disable-sync --disable-default-apps --no-first-run
```

```powershell
# Chrome: locais importantes
# Perfil: %LocalAppData%\Google\Chrome\User Data\
# Cache:  %LocalAppData%\Google\Chrome\User Data\Default\Cache
# Extensões: %LocalAppData%\Google\Chrome\User Data\Default\Extensions

# Resetar Chrome:
# chrome://settings/reset → "Restaurar configurações padrão"
```

### Firefox — Flags e Configurações

```cmd
:: Abrir Firefox com perfil novo (temporário)
firefox --ProfileManager
firefox --temp-profile

:: Modo seguro (sem extensões)
firefox --safe-mode

:: Resetar Firefox
firefox --reset-profile
```

```powershell
# Firefox: locais importantes
# Perfil: %AppData%\Mozilla\Firefox\Profiles\
# Cache:  %LocalAppData%\Mozilla\Firefox\Profiles\xxxx.default\cache2

# Sobre configs avançadas:
# about:config → "I accept the risk!"
```

---

## 🔥 NÍVEL 3 — Troubleshooting Jedi

### Ritual Universal (funciona em qualquer navegador)

```
PASSO 1: LIMPAR CACHE E COOKIES
→ Ctrl+Shift+Del → "Todo o período" → Cache + Cookies → Limpar

PASSO 2: VERIFICAR EXTENSÕES
→ edge://extensions / chrome://extensions / about:addons
→ DESATIVAR TUDO (todas mesmo)
→ Se resolveu: reativar uma por uma até achar a culpada

PASSO 3: RESETAR CONFIGURAÇÕES
→ Configurações → Reset → Restaurar padrão
(NÃO perde favoritos, só configurações)

PASSO 4: VERIFICAR MALWARE
→ Configurações → Privacidade → "Limpar dados de navegação" → Avançado
→ Ver se tem "Gerenciado por sua organização" (se não era pra ter = malware)

PASSO 5: RECRIAR PERFIL
→ Fechar navegador
→ Renomear pasta Default/Profile
→ Reabrir (cria perfil novo)
→ Se resolveu = perfil corrompido

PASSO 6: DESINSTALAR + LIMPAR + REINSTALAR
→ Desinstalar navegador
→ Deletar pasta User Data (perde TUDO!)
→ Reinstalar
```

### Como identificar "Gerenciado pela sua organização" indesejado

```
Se em chrome://policy ou edge://policy aparecem políticas que
você não configurou = MALWARE (adware, hijacker, extensão corporativa).

Políticas suspeitas:
- ExtensionInstallForcelist (força instalar extensão)
- HomepageLocation (muda página inicial)
- DefaultSearchProvider (muda buscador)
- RestoreOnStartup (força abrir sites)

Remoção:
1. Desinstalar programa suspeito
2. HKLM\SOFTWARE\Policies\Google\Chrome → deletar
3. HKLM\SOFTWARE\Policies\Microsoft\Edge → deletar
4. Rodar ADWCleaner / Malwarebytes
```

---

### Problema #1: Navegador MUITO lento

```
Diagnóstico:
1. Abrir Gerenciador de Tarefas do navegador:
   Shift+Esc no Chrome/Edge → ver consumo por aba/extensão

2. Diagnóstico interno:
   chrome://performance (Chrome)
   edge://performance (Edge)
   about:performance (Firefox)

Soluções (ordem):
1. Fechar abas que não usa (óbvio mas ignorado)
2. Desabilitar extensões (especialmente adblockers duplicados!)
3. Limpar cache
4. Desabilitar aceleração de hardware:
   Configurações → Sistema → "Usar aceleração de hardware" → OFF
5. Ativar "Economia de memória" (Edge/Chrome):
   Configurações → Desempenho → Memory Saver ON
6. Verificar se o disco tá 100% (HDD sofrendo)
7. Verificar antivírus: alguns escaneiam cada página carregada
```

### Problema #2: "Não abre" / Crash na inicialização

```
Causas (em ordem de probabilidade):
1. Extensão bugada → abrir em modo seguro/sem extensões
2. Perfil corrompido → recriar perfil
3. GPU driver → desabilitar aceleração de hardware
4. Antivírus bloqueando → adicionar navegador à whitelist
5. Falta de RAM → fechar outros apps

Comando de emergência (Edge):
msedge --no-experiments --disable-extensions --disable-sync --disable-gpu --disable-features=All

Comando de emergência (Chrome):
chrome --disable-extensions --disable-gpu --no-sandbox --disable-webgl
```

### Problema #3: Página inicial ou buscador trocou sozinho

```
Isso é MALWARE (browser hijacker).

Remoção:
1. Verificar chrome://policy / edge://policy
2. Configurações → Mecanismo de pesquisa → Restaurar Google/Bing
3. Configurações → Ao iniciar → Remover páginas suspeitas
4. Extensões → Remover desconhecidas
5. ADWCleaner + Malwarebytes
6. Limpar chaves de política no registry
```

### Problema #4: "Aguarde..." / "Restaurando abas..." infinito

```
Causa: Sessão anterior crashou e o navegador trava tentando restaurar.

Solução:
1. Ctrl+Shift+Del (antes de abrir) → limpar tudo
2. Ou deletar arquivos de sessão:
   Chrome/Edge: %LocalAppData%\*\User Data\Default\Sessions\*
   Firefox: %AppData%\Mozilla\Firefox\Profiles\*\sessionstore-backups\*

3. Desabilitar "Continuar de onde parei" nas configurações
```

### Problema #5: Certificado / "Sua conexão não é privada"

```
NET::ERR_CERT_DATE_INVALID       → Data/hora do PC errada!
NET::ERR_CERT_AUTHORITY_INVALID  → Certificado autoassinado ou MITM
NET::ERR_CERT_COMMON_NAME_INVALID → Site usa certificado errado

Solução:
1. Verificar data/hora do Windows (causa #1!)
2. Se só 1 site = problema do site, não seu
3. Se todos sites = antivírus fazendo MITM (Bitdefender, Kaspersky)
   → Desabilitar "Scan HTTPS" / "SSL Scanning" no AV
4. Limpar certificados: certmgr.msc → limpar cache
```

### Problema #6: Download bloqueado / "Arquivo não seguro"

```
Chrome/Edge → Configurações → Privacidade e Segurança → Segurança
→ "Sem proteção" (TEMPORÁRIO, só pro download específico!)

Alternativa: usar outro navegador sem essa proteção
```

---

## ⚡ NÍVEL 4 — Linha de Comando e Automação

### Instalação/Desinstalação por Linha de Comando

```powershell
# Google Chrome — instalar offline
$url = "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
$out = "$env:TEMP\ChromeSetup.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/silent /install" -Wait

# Google Chrome — desinstalar silencioso
$chrome = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" -ErrorAction SilentlyContinue
if ($chrome) {
    Start-Process -FilePath $chrome.UninstallString.Split('"')[1] -ArgumentList "--force-uninstall" -Wait
}

# Microsoft Edge — (já vem no Windows, atualizar ou reinstalar)
# Download: https://www.microsoft.com/en-us/edge/download
Start-Process -FilePath "MicrosoftEdgeSetup.exe" -ArgumentList "/silent /install" -Wait

# Firefox — instalar offline
$url = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=pt-BR"
$out = "$env:TEMP\FirefoxSetup.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/S" -Wait

# Firefox — desinstalar
$ff = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mozilla Firefox*" -ErrorAction SilentlyContinue
if ($ff) {
    $uninstall = "$($ff.InstallLocation)\uninstall\helper.exe"
    Start-Process -FilePath $uninstall -ArgumentList "/S" -Wait
}

# Via winget (todos navegadores):
winget install Google.Chrome --silent
winget install Microsoft.Edge --silent
winget install Mozilla.Firefox --silent
```

### Limpeza Completa de Navegador

```powershell
function Clear-BrowserData {
    param([ValidateSet("Edge","Chrome","Firefox","All")][string]$Browser)
    
    switch ($Browser) {
        "Edge" {
            $paths = @(
                "$env:LocalAppData\Microsoft\Edge\User Data\Default\Cache\*",
                "$env:LocalAppData\Microsoft\Edge\User Data\Default\Code Cache\*",
                "$env:LocalAppData\Microsoft\Edge\User Data\Default\Service Worker\*",
                "$env:LocalAppData\Microsoft\Edge\User Data\Default\GPUCache\*"
            )
            Remove-Item -Path $paths -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Cache Edge limpo"
        }
        "Chrome" {
            $paths = @(
                "$env:LocalAppData\Google\Chrome\User Data\Default\Cache\*",
                "$env:LocalAppData\Google\Chrome\User Data\Default\Code Cache\*",
                "$env:LocalAppData\Google\Chrome\User Data\Default\Service Worker\*",
                "$env:LocalAppData\Google\Chrome\User Data\Default\GPUCache\*"
            )
            Remove-Item -Path $paths -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Cache Chrome limpo"
        }
        "Firefox" {
            $profile = Get-ChildItem "$env:AppData\Mozilla\Firefox\Profiles" -Directory | Where-Object {$_.Name -like "*.default*"} | Select -First 1
            if ($profile) {
                Remove-Item "$($profile.FullName)\cache2\*" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "✅ Cache Firefox limpo"
            }
        }
        "All" {
            Clear-BrowserData -Browser Edge
            Clear-BrowserData -Browser Chrome
            Clear-BrowserData -Browser Firefox
        }
    }
}
```

---

## 🎯 Resets Rápidos

### Edge — Reset Completo
```cmd
:: Deletar perfil (PERDE FAVORITOS, senhas, extensões!)
:: Fechar Edge completamente, depois:
rmdir /s /q "%LocalAppData%\Microsoft\Edge\User Data"

:: Reset menos destrutivo (mantém favoritos):
:: edge://settings/reset → "Restaurar configurações para os padrões originais"
```

### Chrome — Reset Completo
```cmd
:: Deletar perfil
rmdir /s /q "%LocalAppData%\Google\Chrome\User Data"

:: Reset menos destrutivo:
:: chrome://settings/reset → "Restaurar configurações para os padrões originais"
```

### Firefox — Reset Completo
```cmd
:: Refresh Firefox (mantém favoritos, senhas):
:: about:support → "Restaurar o Firefox"

:: Reset total (perde tudo):
firefox --ProfileManager → Criar novo perfil → Deletar antigo
```

---

## 📝 Script de Diagnóstico de Navegador

```powershell
function Test-BrowserHealth {
    param([ValidateSet("Edge","Chrome","Firefox","All")][string]$Browser = "All")
    
    Write-Host "=== DIAGNÓSTICO DE NAVEGADORES ===" -Foreground Cyan
    
    $checks = @{
        Edge = @{
            Path = "$env:LocalAppData\Microsoft\Edge\User Data"
            Exe = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
            Policies = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
        }
        Chrome = @{
            Path = "$env:LocalAppData\Google\Chrome\User Data"
            Exe = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
            Policies = "HKLM:\SOFTWARE\Policies\Google\Chrome"
        }
        Firefox = @{
            Path = "$env:AppData\Mozilla\Firefox\Profiles"
            Exe = "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
        }
    }
    
    $browsers = if ($Browser -eq "All") { $checks.Keys } else { @($Browser) }
    
    foreach ($b in $browsers) {
        $c = $checks[$b]
        Write-Host "`n--- $b ---" -Foreground Yellow
        
        # Instalado?
        if (Test-Path $c.Exe) {
            $ver = (Get-Item $c.Exe).VersionInfo.ProductVersion
            Write-Host "Versão: $ver ✅"
        } else {
            Write-Host "NÃO instalado ❌"
            continue
        }
        
        # Políticas (malware?)
        if ($c.Policies -and (Test-Path $c.Policies)) {
            $policies = Get-ChildItem $c.Policies -Recurse -ErrorAction SilentlyContinue
            if ($policies) {
                Write-Host "⚠️ POLÍTICAS ATIVAS (verificar se é malware!):"
                $policies | ForEach-Object { Write-Host "  $($_.Name)" }
            } else {
                Write-Host "Políticas: ✅ OK (sem políticas forçadas)"
            }
        }
        
        # Tamanho do perfil
        if (Test-Path $c.Path) {
            $size = (Get-ChildItem $c.Path -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
            Write-Host "Perfil: $([math]::Round($size/1MB,0)) MB $(if($size -gt 1GB){'⚠️ GRANDE DEMAIS!'})"
        }
        
        # Extensões
        $extPath = "$($c.Path)\Default\Extensions"
        if (Test-Path $extPath) {
            $extCount = (Get-ChildItem $extPath -Directory -ErrorAction SilentlyContinue).Count
            Write-Host "Extensões: $extCount $(if($extCount -gt 10){'⚠️ MUITAS!'})"
        }
    }
}
```

---

## ⚠️ Dicas Jedi

- **Shift+Esc** abre o gerenciador de tarefas do navegador. Revela qual aba/extensão tá comendo CPU/RAM.
- **chrome://conflicts / edge://conflicts** → mostra módulos DLL de terceiro injetados (antivírus, malware).
- **Navegador lento + HDD** = troque pra SSD. Cache de navegador em HDD é sofrimento puro.
- **"Gerenciado pela sua organização"** quando não era pra ser = malware até provar o contrário.
- **Never click "Allow notifications"** em sites aleatórios. Depois é um inferno remover.
- **DNS over HTTPS (DoH)** nas configurações → resolve lentidão de DNS sem mexer no Windows.
- **Perfil corrompido** é a causa #1 de crash na inicialização. Recriar resolve 90% das vezes.
- **uBlock Origin** é a ÚNICA extensão que todo mundo deveria ter. Bloqueia anúncio, tracking e malware.

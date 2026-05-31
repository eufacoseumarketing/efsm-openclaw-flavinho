# 📦 Aplicativos Populares — Guia de Suporte HelpDesk

> WhatsApp, IRPF, Spotify, Adobe Reader, Zoom, VLC, WinRAR e outros.
> Problemas comuns, instalação, troubleshooting e dicas.
> Foco: apps mais pedidos no suporte brasileiro.
> Atualizado: 31/05/2026

---

## 📊 Top Apps que Mais Geram Suporte (Brasil)

| # | App | Categoria | Carga de Suporte |
|---|-----|-----------|------------------|
| 1 | WhatsApp Desktop | Comunicação | 🔥🔥🔥 Altíssima |
| 2 | IRPF (Receita Federal) | Governo | 🔥🔥🔥 Altíssima (sazonal) |
| 3 | Adobe Reader / Foxit | PDF | 🔥🔥 Alta |
| 4 | Spotify | Música | 🔥🔥 Alta |
| 5 | Zoom / Teams / Meet | Videoconferência | 🔥🔥 Alta |
| 6 | Google Drive / OneDrive | Nuvem | 🔥 Média |
| 7 | VLC Media Player | Mídia | 🔥 Média |
| 8 | AnyDesk / TeamViewer | Acesso Remoto | 🔥 Média |
| 9 | WinRAR / 7-Zip | Compressão | 🟢 Baixa |
| 10 | Discord / Telegram | Comunicação | 🟢 Baixa |

---

## 💬 WhatsApp Desktop

### Versões
```
WhatsApp Desktop (UWP) → Microsoft Store, simples, usa Electron (antigo)
WhatsApp Desktop (Native) → whatsapp.com, app nativo, mais rápido
WhatsApp Web              → web.whatsapp.com, navegador, dependente do celular
```

### Instalação

```powershell
# Winget
winget install WhatsApp.WhatsApp

# Download direto
$url = "https://get.microsoft.com/installer/download?app=WhatsAppDesktop"
Start-Process $url

# Ou via Microsoft Store
# ms-windows-store://pdp/?ProductId=9NKSQGP7F2NH
```

### Problemas Comuns

**"WhatsApp não conecta / 'Celular desconectado'"**
```
1. Celular PRECISA estar online (WhatsApp Desktop depende dele!)
2. No celular: WhatsApp → Configurações → Dispositivos Conectados
3. Desconectar e reconectar o PC
4. Se Wi-Fi do celular ≠ Wi-Fi do PC → reconectar mesmo assim (funciona)
5. Se nada funcionar: desinstalar WhatsApp Desktop, limpar, reinstalar
```

**"WhatsApp não instala / Erro na Microsoft Store"**
```powershell
# Resetar Microsoft Store
wsreset.exe

# Se falhar, baixar instalador direto do site:
# https://www.whatsapp.com/download
```

**"WhatsApp lento / travando"**
```
1. Fechar e reabrir
2. Limpar cache:
   %LocalAppData%\Packages\5319275A.WhatsAppDesktop_*\LocalCache\
   %AppData%\WhatsApp\Cache\
3. Se versão Desktop antiga (UWP branca) → migrar pra nova (whatsapp.com/download)
4. Verificar conexão do celular (WhatsApp no PC depende!)
```

**"Webcam/Microfone não funciona no WhatsApp"**
```
Configurações → Privacidade → Microfone → WhatsApp Desktop: Permitido
Configurações → Privacidade → Câmera → WhatsApp Desktop: Permitido
```

---

## 📊 IRPF — Imposto de Renda Pessoa Física (Receita Federal)

⚠️ **Sazonal:** Março a Maio. Época de suporte PESADO.

### Versões e Download

```
IRPF 2026 → https://www.gov.br/receitafederal (Programa IRPF 2026)
IRPF 2025 → Declaração retificadora de anos anteriores

Requisitos mínimos:
- Windows 10/11 (32 ou 64 bits)
- 4 GB RAM
- 500 MB espaço livre
- Java Runtime (vem embutido no instalador da Receita)
```

### Instalação

```powershell
# Download (link muda todo ano, sempre verificar site oficial!)
# https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf

# Instalação: executar como administrador
Start-Process -FilePath "IRPF2026.exe" -Verb RunAs -Wait

# Se falhar, modo compatibilidade:
# Propriedades do instalador → Compatibilidade → Windows 7 → Executar como admin
```

### Problemas Comuns (TOP 5)

**1. "Erro ao abrir o programa" / Não abre**
```
Causas:
- Java corrompido ou versão errada
- Antivírus bloqueando
- Falta de permissão

Solução:
1. Executar como administrador (botão direito → Executar como administrador)
2. Adicionar pasta do IRPF na whitelist do antivírus
3. Reinstalar o programa
4. Baixar novamente do site oficial (instalador pode estar corrompido)
```

**2. "Arquivo .dec não abre" / "Arquivo corrompido"**
```
- Verificar se é o ANO correto (IRPF 2025 não abre arquivo de 2026)
- Tentar recuperar backup automático (.bak na pasta do IRPF)
- Restaurar declaração pelo Portal e-CAC (gov.br)
```

**3. "Erro de conexão" ao transmitir**
```
- Verificar internet
- Desabilitar VPN se estiver usando
- Tentar em outro horário (servidores da Receita ficam sobrecarregados)
- Verificar se o certificado digital tá instalado (se for declaração com certificado)
```

**4. "Programa fecha sozinho"**
```
- Java bugado → reinstalar IRPF
- Conflito com outro programa → fechar tudo antes de abrir
- RAM insuficiente → fechar navegador/outros apps
```

**5. "CPF inválido" ou "Contribuinte não encontrado"**
```
- ⚠️ Isso NÃO é problema do programa = problema cadastral na Receita
- Cliente precisa acessar e-CAC (gov.br) e regularizar CPF
```

### Dica Mestre IRPF
```
SEMPRE manter a declaração original (.dec) e o recibo de entrega (.rec) salvos
em local seguro. Se perder, é possível recuperar pelo e-CAC, mas é muito mais
trabalhoso.
```

---

## 🎵 Spotify

### Instalação

```powershell
# Winget
winget install Spotify.Spotify

# Download direto
$url = "https://download.scdn.co/SpotifySetup.exe"
$out = "$env:TEMP\SpotifySetup.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -Wait
```

### Problemas Comuns

**"Spotify não abre / tela preta"**
```
1. Fechar Spotify completamente (bandeja também!)
2. Deletar cache:
   %LocalAppData%\Spotify\Data\*
   %AppData%\Spotify\Users\*\local-files.bnk (se existir)
3. Reabrir
4. Se persistir: desinstalar + deletar %AppData%\Spotify\ + reinstalar
```

**"Música não toca / pausa sozinha"**
```
- Trocar dispositivo de saída de áudio (Spotify pode estar no errado)
- Desabilitar "Aceleração de hardware" no Spotify
- Verificar se tem outro dispositivo usando a mesma conta Spotify
  (Spotify Free só toca em 1 dispositivo por vez!)
```

**"Spotify não instala / Erro 17/18"**
```
- Fechar antivírus durante instalação
- Executar como administrador
- Usar instalador offline do site (não o web installer)
- Desinstalar versão Windows Store se tiver conflito
```

**"Anúncios demais"**
```
- Se Free = normal, não tem solução grátis
- Se Premium = verificar se tá logado na conta certa
- Site: spotify.com/account → verificar assinatura
```

---

## 📄 Adobe Acrobat Reader / Foxit Reader

### Adobe Reader
```powershell
# Winget
winget install Adobe.Acrobat.Reader.64-bit

# Download direto
$url = "https://get.adobe.com/reader/download?installer=Reader_DC_2025_MUI_for_Windows"
# Adobe Reader usa web installer - é mais fácil via winget ou site
```

### Foxit Reader (Alternativa Mais Leve)
```powershell
# Winget
winget install Foxit.FoxitReader

# Download direto
$url = "https://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/win/latest/FoxitReader.exe"
$out = "$env:TEMP\FoxitReader.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/silent" -Wait
```

### Problemas Comuns

**"PDF não abre / 'Arquivo danificado'"**
```
1. Tentar abrir em outro leitor (Foxit, navegador, Edge)
2. Se abre em outro = problema do Adobe Reader
3. Reparar Adobe Reader: Ajuda → Reparar instalação
4. Se não abre em nenhum = arquivo realmente corrompido
```

**"Adobe Reader lento demais"**
```
- Sugerir Foxit Reader (muito mais leve!)
- Ou usar o leitor de PDF nativo do Edge (edge://pdf)
- Desabilitar plugins Adobe: Editar → Preferências → 3D e Multimídia → Desabilitar
```

**"Não consigo preencher formulário PDF"**
```
- Adobe Reader Free NÃO edita/salva formulários
- Alternativas grátis: Foxit Reader, navegador Edge
- Se precisa editar: Adobe Acrobat Pro (pago) ou PDFescape (online grátis)
```

---

## 🎥 Zoom / Microsoft Teams / Google Meet

### Zoom
```powershell
winget install Zoom.Zoom

# Silent install
$url = "https://zoom.us/client/latest/ZoomInstaller.exe"
$out = "$env:TEMP\ZoomInstaller.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/silent" -Wait
```

### Problemas Comuns (Videoconferência)

**"Câmera não funciona"**
```
1. Verificar se a câmera tem tampa física (MUITO COMUM!)
2. Configurações → Privacidade → Câmera → App: Permitido
3. Fechar outros apps que usam câmera (outro Zoom, navegador)
4. Tecla de atalho no notebook (Fn+F6, F8, F10 varia por marca)
```

**"Microfone não funciona"**
```
1. Mesmo ritual da câmera (Privacidade → Microfone)
2. Selecionar microfone correto (app pode estar usando o errado)
3. Testar em outro app (Gravação de Voz do Windows)
4. Headset Bluetooth: às vezes conecta como 2 dispositivos (Headphones vs Headset)
   → Selecionar o "Headset" (não "Headphones"!)
```

**"Áudio do Zoom com eco / microfonia"**
```
- Zoom: Configurações → Áudio → ☑ Suprimir ruído de fundo
- Se várias pessoas na mesma sala → 1 microfone só, resto mutado
- Headset resolve 90% dos problemas de áudio
```

**"Zoom fecha / trava durante reunião"**
```
- Desabilitar aceleração de hardware: Configurações → Vídeo → Avançado
- Fechar outros apps (Zoom come RAM!)
- Atualizar Zoom (verifica automaticamente ao abrir)
```

---

## ☁️ Google Drive / OneDrive

### Problemas Comuns

**"Arquivos não sincronizam"**
```
Google Drive:
- Clicar ícone na bandeja → Pausar → Retomar
- Se travou: sair do app, reabrir
- Verificar espaço na conta Google (15 GB grátis, incluindo Gmail e Fotos!)

OneDrive:
- Configurações → Sincronizar → Retomar
- Se arquivo tem ❌ = problema de nome (caractere proibido, nome muito longo)
- Se ⚠️ = conflito de versão (abrir, resolver)
```

**"OneDrive pedindo login toda hora"**
```powershell
# Resetar OneDrive (não perde arquivos, só reconfigura)
%LocalAppData%\Microsoft\OneDrive\OneDrive.exe /reset

# Aguardar 1 minuto, depois:
%LocalAppData%\Microsoft\OneDrive\OneDrive.exe
```

---

## 🎬 VLC Media Player

```powershell
winget install VideoLAN.VLC

# Silent install
$url = "https://get.videolan.org/vlc/last/win64/vlc-3.0.21-win64.exe"
$out = "$env:TEMP\vlc-setup.exe"
Invoke-WebRequest -Uri $url -OutFile $out
Start-Process -FilePath $out -ArgumentList "/S" -Wait
```

### Problemas Comuns
```
"Vídeo não abre" → VLC abre quase tudo. Se nem VLC abre = arquivo corrompido.
"Legenda não aparece" → Arrastar arquivo .srt pra janela do VLC.
"Vídeo travando" → Desabilitar aceleração de hardware: Ferramentas → Preferências → Vídeo → Saída → OpenGL/Modo Direto.
```

---

## 🖥️ AnyDesk / TeamViewer

```powershell
# AnyDesk (mais leve, melhor pra suporte)
winget install AnyDeskSoftwareGmbH.AnyDesk

# TeamViewer (mais completo)
winget install TeamViewer.TeamViewer
```

### Problemas Comuns
```
"AnyDesk não conecta" → Verificar internet, firewall, porta 80/443/6568
"TeamViewer 'Uso comercial detectado'" → Comum em versão free. Alternativa: AnyDesk
"Conexão cai toda hora" → Conexão ruim. Sugerir reduzir qualidade → AnyDesk → Configurações → Qualidade → Baixa
```

---

## 🗜️ WinRAR / 7-Zip

```powershell
# 7-Zip (gratuito, recomendado)
winget install 7zip.7zip

# WinRAR (pago, mas trial não expira funcionalmente)
winget install RARLab.WinRAR
```

### Problemas Comuns
```
"Arquivo corrompido" → Se baixou da internet, baixar de novo. Se recebeu, pedir reenvio.
"Senha do ZIP/RAR" → Não existe como "quebrar". Precisar da senha original.
"Não abre .7z" → WinRAR antigo não abre 7z. Instalar 7-Zip.
```

---

## 🎮 Discord / Telegram

### Discord
```powershell
winget install Discord.Discord
```

### Problemas Comuns
```
"Discord não abre / tela cinza" → Ctrl+R (recarrega). Se não: deletar %AppData%\Discord\Cache
"Microfone robotizado" → Configurações → Voz e Vídeo → desabilitar "Cancelamento de Eco" e "Redução de Ruído"
"Discord não atualiza" → Ctrl+R ou fechar bandeja + abrir de novo
```

### Telegram
```powershell
winget install Telegram.TelegramDesktop
```

---

## 📝 Script — Diagnóstico de Apps Populares

```powershell
function Test-PopularApps {
    Write-Host "=== APPS POPULARES — STATUS ===" -Foreground Cyan
    
    $apps = @(
        @{Name="WhatsApp"; Winget="WhatsApp.WhatsApp"; Exe="WhatsApp.exe"},
        @{Name="Spotify"; Winget="Spotify.Spotify"; Exe="Spotify.exe"},
        @{Name="Adobe Reader"; Winget="Adobe.Acrobat.Reader.64-bit"; Exe="AcroRd32.exe"},
        @{Name="Zoom"; Winget="Zoom.Zoom"; Exe="Zoom.exe"},
        @{Name="VLC"; Winget="VideoLAN.VLC"; Exe="vlc.exe"},
        @{Name="7-Zip"; Winget="7zip.7zip"; Exe="7zFM.exe"},
        @{Name="Google Drive"; Winget="Google.Drive"; Exe="GoogleDriveFS.exe"},
        @{Name="OneDrive"; Winget="Microsoft.OneDrive"; Exe="OneDrive.exe"},
        @{Name="AnyDesk"; Winget="AnyDeskSoftwareGmbH.AnyDesk"; Exe="AnyDesk.exe"},
        @{Name="Discord"; Winget="Discord.Discord"; Exe="Discord.exe"},
        @{Name="Telegram"; Winget="Telegram.TelegramDesktop"; Exe="Telegram.exe"},
        @{Name="IRPF 2026"; ; CheckDir="C:\Program Files\IRPF2026"},
        @{Name="Foxit Reader"; Winget="Foxit.FoxitReader"; Exe="FoxitReader.exe"}
    )
    
    $found = 0
    $missing = 0
    
    foreach ($app in $apps) {
        $installed = $false
        
        if ($app.Exe) {
            $installed = Get-Command $app.Exe -ErrorAction SilentlyContinue
        }
        if (-not $installed -and $app.CheckDir) {
            $installed = Test-Path $app.CheckDir
        }
        
        $status = if ($installed) { "✅"; $found++ } else { "❌"; $missing++ }
        Write-Host "$status $($app.Name)"
    }
    
    Write-Host "`nTotal: $found instalados, $missing não encontrados"
    Write-Host "Dica: winget install <app> para instalar qualquer um"
}
```

---

## 🎯 Recomendações PC Resolve

### Kit Básico (instalar em todo PC de cliente)
```
✅ 7-Zip (substitui WinRAR pago)
✅ Foxit Reader (substitui Adobe Reader pesado)
✅ VLC Media Player (toca qualquer vídeo)
✅ uBlock Origin (no navegador do cliente)
```

### Comando Único pra Instalar o Kit Básico
```powershell
winget install 7zip.7zip Foxit.FoxitReader VideoLAN.VLC --silent --accept-package-agreements
```

### Checklist IRPF (Março-Maio)
```
☐ Verificar se IRPF do ano está instalado
☐ Verificar Java (se necessário)
☐ Ajudar a localizar declaração do ano anterior
☐ Orientar sobre backup da declaração
☐ Verificar certificado digital (se aplicável)
```

---

## ⚠️ Dicas Jedi

- **WhatsApp Desktop** depende do celular online. Sempre verificar se o celular tá conectado antes de qualquer troubleshooting no PC.
- **IRPF fecha sozinho?** 90% das vezes é Java ou antivírus bloqueando. Reinstalar resolve.
- **Adobe Reader lento?** Foxit Reader é grátis, leve e faz tudo que o cliente precisa.
- **Câmera não funciona?** Tampa física é a causa #1. Nos notebooks Dell, o botão fica na lateral.
- **Spotify Free** = 1 dispositivo por vez. Se tocar no celular, pausa no PC e vice-versa.
- **WinRAR "trial expirou"?** Continua funcionando, só mostra popup. 7-Zip é grátis e melhor.
- **PDF que não abre?** O Edge abre PDF nativamente. É o fallback universal.

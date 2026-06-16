# Instalacao do IRPF (Programa Imposto de Renda)

## Descricao
Instalar o programa da Receita Federal para declaracao de Imposto de Renda Pessoa Fisica.

## Pre-requisitos
- Windows 10/11
- 4 GB RAM
- 500 MB de espaco livre
- Conexao com internet durante a instalacao
- Privilegios de administrador (obrigatorio)

## Passo a passo

### 1. Desativar descanso de tela
```cmd
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
```

### 2. Verificar se o IRPF ja esta instalado
```cmd
dir "C:\Arquivos de Programas RFB\IRPF2026" /b
dir "C:\Arquivos de Programas\IRPF2026" /b
```
Se mostrar arquivos (IRPF2026.exe, help, lib, etc), ja esta instalado.

### 3. Baixar o instalador

#### Links Diretos IRPF 2026 (preferir estes):
- Windows (32 bits): https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win32v1.5.exe
- Linux (x64): https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Linux-x86_64v1.5.sh.bin
- MacOS ARM: https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-v1.5_arm.dmg
- MacOS x64: https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-v1.5.dmg
- Multiplataforma (Java): https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-1.5.zip

#### Download via BITS (recomendado, nao trava o agente):
```cmd
bitsadmin /transfer IRPF_Download /download /priority HIGH "https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win32v1.5.exe" "C:\Users\<usuario>\Downloads\IRPF2026Win32v1.5.exe"
```

#### Fallback: pagina de download
https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf

### 4. Executar o instalador (VIA SCHEDULED TASK - bypass UAC)

O instalador EXIGE privilegios de administrador e o UAC bloqueia automacao remota.
Solucao: Scheduled Task com RunLevel Highest:

```powershell
$a = New-ScheduledTaskAction -Execute 'C:\Users\<usuario>\Downloads\IRPF2026Win32v1.5.exe'
$p = New-ScheduledTaskPrincipal -UserId '<usuario>' -LogonType Interactive -RunLevel Highest
Unregister-ScheduledTask -TaskName 'IRPF' -Confirm:$false -ErrorAction SilentlyContinue
Register-ScheduledTask -TaskName 'IRPF' -Action $a -Principal $p -Force
Start-ScheduledTask -TaskName 'IRPF'
```

Aguardar 3-5 segundos para o instalador abrir.

### 5. Trazer a janela do instalador para frente com SetForegroundWindow

O instalador pode abrir ATRAS de outras janelas (Widgets, Explorer, etc). Para forcar:

```powershell
Add-Type -Name F -Namespace Y -MemberDefinition '[DllImport("user32.dll")]public static extern bool SetForegroundWindow(IntPtr h);[DllImport("user32.dll")]public static extern bool ShowWindow(IntPtr h,int c);[DllImport("user32.dll")]public static extern bool SetWindowPos(IntPtr h,IntPtr a,int x,int y,int cx,int cy,uint f);'
$p = Get-Process -Name IRPF2026Win32v1.5 -ErrorAction SilentlyContinue | Select-Object -First 1
[Y.F]::ShowWindow($p.MainWindowHandle, 3)
sleep 0.2
[Y.F]::SetWindowPos($p.MainWindowHandle, -1, 0, 0, 0, 0, 3)  # HWND_TOPMOST
[Y.F]::SetForegroundWindow($p.MainWindowHandle)
```

### 6. Navegar pelo assistente de instalacao (TECLADO - Tab+Enter)

Com a janela em foco (SetForegroundWindow), navegar por Tab+Enter:

- **Tela 1 (Boas-vindas)**: SetForegroundWindow → `Enter` (Avancar e default)
- **Tela 2 (Pasta de destino)**: `Enter` = Avancar (manter padrao: C:\Arquivos de Programas RFB\IRPF2026)
- **Tela 3 (Confirmacao)**: `Tab` `Tab` `Enter` (checkbox "Criar atalho" rouba foco → pular checkbox e Voltar → chegar no Avancar)
- **Tela 4 (Progresso)**: Aguardar ~20s, barra de progresso
- **Tela 5 (Concluido)**: `Enter` = Terminar

### 7. Confirmar instalacao
```cmd
dir "C:\Arquivos de Programas RFB\IRPF2026" /b
```
Deve mostrar: `.install4j`, `help`, `jre`, `lib`, `lib-modulos`

### 8. Verificar atalho na area de trabalho
```cmd
dir "C:\Users\<usuario>\Desktop\*IRPF*"
```

## Resumo de teclas (atualizado)
| Passo | Tecla |
|-------|-------|
| Launch instalador | Scheduled Task (RunLevel Highest) |
| Trazer janela pra frente | SetForegroundWindow + SetWindowPos(HWND_TOPMOST) |
| Tela 1 - Boas-vindas | `Enter` |
| Tela 2 - Pasta destino | `Enter` |
| Tela 3 - Confirmacao | `Tab` `Tab` `Enter` |
| Aguardar progresso | ~20 segundos |
| Tela 5 - Concluir | `Enter` |

## Observacoes importantes
- O arquivo para Windows se chama `IRPF2026Win32v1.5.exe` (~111 MB)
- Instalacao silenciosa (/VERYSILENT, /S) NAO funciona (web-wrapper, retorna exit code 0 mas nao instala)
- O instalador PRECISA de internet durante a execucao
- PRECISA de privilegios de administrador (erro: "Precisa de privilegios de administrador para instalar este programa")
- UAC secure desktop BLOQUEIA qualquer automacao remota (cliques, teclas) → usar Scheduled Task com RunLevel Highest para bypass
- O agente Mesh roda como SYSTEM e nao mostra GUI na sessao do usuario
- **SetForegroundWindow e OBRIGATORIO** antes de mandar Tab/Enter — sem foco, teclas vao pra janela errada
- **Widgets do Windows 11**: painel persistente que NAO fecha com clique, Esc, Win+W ou Win+D. SetWindowPos(HWND_TOPMOST) resolve forcando instalador acima dele
- **Navegacao**: sempre TECLADO (Tab+Enter), nunca clique por coordenada em botoes (Gemini impreciso ~50px)
- mouse_event (commit 4586305) funciona para cliques em janelas de app, mas coordenadas do Gemini sao imprecisas

## Caminho de instalacao
- Padrao do instalador: `C:\Arquivos de Programas RFB\IRPF2026`

## Downloads Diretos - todas as plataformas IRPF 2026

| Plataforma | Link |
|-----------|------|
| Windows 32 bits | https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Win32v1.5.exe |
| Linux x86_64 | https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026Linux-x86_64v1.5.sh.bin |
| MacOS ARM | https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-v1.5_arm.dmg |
| MacOS x64 | https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-v1.5.dmg |
| Multiplataforma (Java) | https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-1.5.zip |

## Links uteis
- Pagina de download: https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf
- Portal e-CAC: https://cav.receita.fazenda.gov.br/
- App Meu Imposto de Renda: Google Play / App Store

## Atualizado
16/06/2026 20:47 - Flavinho (instalacao concluida EFSM 01, metodo atualizado com Scheduled Task + SetForegroundWindow + Tab+Enter)

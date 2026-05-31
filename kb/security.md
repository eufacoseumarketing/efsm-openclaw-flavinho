# 🛡️ Segurança Digital — Guia Completo HelpDesk

> Malware, firewall, antivírus, ransomware, phishing, remoção e prevenção.
> Atualizado: 31/05/2026

---

## 🟢 NÍVEL 1 — Conceitos Básicos

### Tipos de Ameaça

| Ameaça | O que faz | Como chega |
|--------|-----------|------------|
| **Vírus** | Se anexa a arquivos, replica ao executar | Pen drive, download, anexo |
| **Worm** | Se replica sozinho pela rede | Vulnerabilidade, rede |
| **Trojan (Cavalo de Troia)** | Se disfarça de programa legítimo | Download, "ativador", "crack" |
| **Ransomware** | Criptografa seus arquivos e pede resgate | E-mail, RDP fraco, download drive-by |
| **Spyware** | Espiona (teclas, tela, senhas) | Download, addon de navegador |
| **Adware** | Enche de anúncios (pop-up, redirecionamento) | Instalador bundlado |
| **Rootkit** | Esconde a própria existência (nível kernel) | Exploit, drive-by |
| **Botnet** | Transforma PC em zumbi pra ataques | Trojan, worm |
| **Phishing** | Engana pra roubar senhas (site falso) | E-mail, SMS, WhatsApp |
| **Keylogger** | Registra tudo que você digita | Malware físico ou software |
| **Cryptojacker** | Usa seu CPU/GPU pra minerar criptomoeda | Site infectado, download |

---

### Cadeia de Infecção (Cyber Kill Chain)

```
1. Reconhecimento    → Atacante pesquisa você/empresa
2. Armação           → Prepara o malware/exploit
3. Entrega           → Envia (e-mail phishing, pen drive, link)
4. Exploração        → Explora vulnerabilidade no sistema
5. Instalação        → Malware se instala e persiste
6. Comando e Controle→ Malware se comunica com o atacante
7. Ação              → Rouba dados, criptografa, destrói
```

---

## 🟡 NÍVEL 2 — Antivírus e Proteção

### Antivírus Integrados

**Microsoft Defender (Windows Security)**
- Vem com Windows 10/11 — ativado por padrão
- Bom? **Sim.** Nos últimos 5 anos, melhorou MUITO. Top 5 do mercado.
- Proteção em tempo real, cloud-delivered, firewall, ransomware protection

```powershell
# Verificar status
Get-MpComputerStatus | Select AntivirusEnabled,RealTimeProtectionEnabled,AntispywareEnabled

# Atualizar assinaturas
Update-MpSignature

# Scan rápido
Start-MpScan -ScanType QuickScan

# Scan completo (LENTO)
Start-MpScan -ScanType FullScan

# Scan offline (antes do Windows bootar)
Start-MpWDOScan

# Histórico de ameaças
Get-MpThreat
Get-MpThreatDetection
```

### Antivírus de Terceiro (se instalado)

| Nome | Pontos Fortes | Pontos Fracos |
|------|---------------|---------------|
| **Kaspersky** | Ótima detecção | Suspenso pelo governo dos EUA (2024) |
| **BitDefender** | Melhor detecção geral | Consome RAM |
| **ESET NOD32** | Leve, bom em rede | Proteção web fraca |
| **Avast/AVG** | Grátis, ok | Adware/upsell agressivo |
| **McAfee** | Corporativo forte | Lento, difícil desinstalar |
| **Norton** | Completo | Caro, pesado, difícil remover |
| **Malwarebytes** | Anti-malware complementar | NÃO substitui antivírus (é complemento) |

⚠️ **Regra:** SÓ UM antivírus de terceiro + Defender. Mais de 1 = conflito, lentidão, BSOD.

---

## 🔥 NÍVEL 3 — Remoção de Malware

### Sinais de Infecção

```
- PC extremamente lento sem motivo
- Pop-ups mesmo com navegador fechado
- Navegador redireciona pra sites estranhos
- Extensões no navegador que você não instalou
- Programas desconhecidos na lista de apps
- CPU/GPU 100% com tudo fechado (cryptojacker)
- Arquivos criptografados com extensão estranha (ransomware!)
- Câmera/webcam acendendo sozinha
- Antivírus desativado e não reativa
- Amigos recebendo mensagens/link que você não enviou
```

### Ritual de Remoção (Ordem Jedi)

```
PASSO 1: ISOLAR
→ Desconectar da rede (Wi-Fi off, cabo fora)
→ Se suspeita de ransomware: DESLIGAR IMEDIATAMENTE
→ Não conectar backups/HDs externos!

PASSO 2: MODO SEGURO
→ Shift + Reiniciar → Solucionar Problemas → Modo Seguro com Rede
   (Só a rede pra baixar ferramentas)

PASSO 3: LIMPEZA COM FERRAMENTAS
→ 1. Rkill (mata processos maliciosos ativos)
→ 2. ADWCleaner (remove adware/spyware/browser hijackers)
→ 3. Malwarebytes (scan completo)
→ 4. HitmanPro (segunda opinião, scan em nuvem)
→ 5. Zemana AntiMalware (terceira opinião)
→ 6. ESET Online Scanner (quarta opinião, muito completo)

PASSO 4: RESTAURAR NAVEGADOR
→ Resetar Chrome/Edge/Firefox pra padrão (perde extensões!)
→ Limpar cache, cookies, histórico

PASSO 5: VERIFICAR PERSISTÊNCIA
→ Autoruns (Sysinternals): desabilitar entradas suspeitas
→ Task Scheduler: remover tarefas desconhecidas
→ Serviços: desabilitar serviços não-Microsoft suspeitos

PASSO 6: ATUALIZAR E ESCANEAR
→ Windows Update: instalar tudo
→ Atualizar antivírus
→ Scan completo com antivírus + Defender offline scan
→ sfc /scannow (arquivos de sistema podem ter sido alterados)

PASSO 7: VERIFICAR DANOS
→ Checar pastas (Documentos, Downloads, Desktop)
→ Ver se tem arquivos .encrypted, .locked, .crypt etc
→ Verificar regras de firewall novas/suspeitas
→ Executar netstat -ano e ver conexões estranhas
```

### Ferramentas de Remoção (Toolkit Jedi)

```
Rkill               → https://www.bleepingcomputer.com/download/rkill/
ADWCleaner          → https://www.malwarebytes.com/adwcleaner
Malwarebytes        → https://www.malwarebytes.com
HitmanPro           → https://www.hitmanpro.com
ESET Online Scanner → https://www.eset.com/int/home/online-scanner/
Kaspersky Virus Removal Tool → https://www.kaspersky.com/downloads/free-virus-removal-tool
Zemana AntiMalware  → https://www.zemana.com/antimalware
Autoruns            → https://learn.microsoft.com/sysinternals/downloads/autoruns
TCPView             → https://learn.microsoft.com/sysinternals/downloads/tcpview
Process Explorer    → https://learn.microsoft.com/sysinternals/downloads/process-explorer
```

---

## ⚡ NÍVEL 4 — Firewall, Rede e Hardening

### Windows Firewall — Modos e Perfis

```
Domain    → Conectado ao domínio da empresa (Active Directory)
Private   → Rede doméstica/confiável
Public    → Rede pública (café, aeroporto, hotel) — MAIS RESTRITIVO
```

```powershell
# Ver perfis ativos
Get-NetFirewallProfile | Select Name,Enabled

# Configurar todos perfis
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True

# Regras de bloqueio
Get-NetFirewallRule -Action Block -Enabled True

# Bloquear IP suspeito
New-NetFirewallRule -DisplayName "Bloquear_IP_Malicioso" -Direction Outbound -RemoteAddress 10.10.10.10 -Action Block

# Bloquear porta
New-NetFirewallRule -DisplayName "Bloquear_SMB_445" -Direction Inbound -LocalPort 445 -Protocol TCP -Action Block

# Restaurar padrão de fábrica do firewall (CUIDADO!)
netsh advfirewall reset
```

### Portas que DEVEM ser bloqueadas (entrada)
```
135    → RPC (WannaCry!)
137-139 → NetBIOS
445    → SMB (WannaCry, EternalBlue!)
3389   → RDP (se não precisar de fora)
1433   → SQL Server
3306   → MySQL
```

### RDP Security
```
⚠️ RDP (3389) aberto pra internet = PEDINDO ransomware.

Se precisa acessar remotamente:
1. VPN (sempre!)
2. RD Gateway (HTTPS, não RDP direto)
3. Mínimo: porta não-padrão (NÃO é segurança real, só reduz ruído)
4. Network Level Authentication (NLA) obrigatório
5. Conta com senha forte
```

### Hardening Básico do Windows

```
☐ Windows Update automático ligado
☐ Defender com proteção em tempo real
☐ UAC no máximo (NUNCA desabilite!)
☐ Firewall ativado em todos perfis
☐ BitLocker (se Pro/Enterprise) no disco do sistema
☐ Senha forte (mínimo 12 caracteres, sem padrão óbvio)
☐ RDP desabilitado se não usa
☐ PowerShell Execution Policy: RemoteSigned (não Unrestricted!)
☐ Arquivos de Office: desabilitar macros da internet
☐ Extensões de arquivo visíveis (ver .pdf.exe disfarçado)
☐ Backup 3-2-1 (3 cópias, 2 mídias diferentes, 1 offsite)
```

---

## 🧬 Ransomware — Protocolo Especial

### O que fazer IMEDIATAMENTE

```
1. DESLIGAR O PC (botão power 5 segundos)
   → Cada segundo conta. Ransomware criptografa rápido.
   
2. DESCONECTAR DA REDE
   → Tirar cabo, desligar Wi-Fi do roteador
   → Ransomware moderno se espalha lateralmente na rede

3. NÃO PAGAR O RESGATE
   → Não garante que vão devolver
   → Financia o crime
   → Você vira alvo "bom pagador" pra novos ataques

4. IDENTIFICAR A VARIANTE
   → Ver extensão dos arquivos (.abc, .lock, .encrypted)
   → Ver nota de resgate (nome/tema)
   → Site: https://www.nomoreransom.org (identifica e às vezes tem decriptador!)

5. RESTAURAR DE BACKUP
   → Do backup OFFLINE (se backup ficou conectado, foi criptografado também)
   
6. REINSTALAR DO ZERO
   → Sim. Formata e reinstala Windows.
   → NUNCA confie em sistema que teve ransomware, mesmo "removido"
```

### Prevenção Anti-Ransomware
```powershell
# Habilitar proteção contra ransomware no Defender
Set-MpPreference -EnableControlledFolderAccess Enabled

# Pastas protegidas
Add-MpPreference -ControlledFolderAccessProtectedFolders "D:\DocumentosImportantes"

# Ver pastas protegidas
Get-MpPreference | Select -Expand ControlledFolderAccessProtectedFolders
```

---

## 🔍 Ferramentas de Análise de Segurança

### Identificar atividades suspeitas

```powershell
# Processos se comunicando com IPs externos
Get-NetTCPConnection | Where-Object {$_.RemoteAddress -notlike "127.*" -and $_.RemoteAddress -notlike "192.168.*" -and $_.RemoteAddress -notlike "10.*" -and $_.RemoteAddress -notlike "172.1*" -and $_.State -eq "Established"} | Select LocalAddress,LocalPort,RemoteAddress,RemotePort,OwningProcess | Sort RemoteAddress -Unique

# Processos iniciando automaticamente (não Microsoft)
Get-CimInstance Win32_StartupCommand | Where-Object {$_.Command -notlike "*Microsoft*" -and $_.Command -notlike "*Windows*"}

# Tarefas agendadas não-Microsoft
Get-ScheduledTask | Where-Object {$_.TaskPath -notlike "*Microsoft*" -and $_.State -ne "Disabled"} | Select TaskName,TaskPath,State

# Serviços não-Microsoft configurados como Auto
Get-Service | Where-Object {$_.StartType -eq "Automatic" -and $_.BinaryPathName -notlike "*Microsoft*" -and $_.BinaryPathName -notlike "*Windows*"} | Select Name,BinaryPathName
```

### Verificar integridade do sistema
```powershell
# Verificar se arquivos do sistema foram modificados
sfc /scannow

# Verificar imagem do Windows
DISM /Online /Cleanup-Image /ScanHealth

# Verificar integridade de módulos PowerShell
Get-Module -ListAvailable | ForEach-Object {
    Get-FileHash $_.Path -Algorithm SHA256
}
```

---

## 🎯 Playbooks de Segurança

### "PC parece infectado — o que fazer?"

```
1. Desconectar da rede
2. Modo Seguro
3. Rkill → ADWCleaner → Malwarebytes
4. Autoruns → desabilitar suspeitos
5. Gerenciador de Tarefas → ver processos com nome estranho
6. Navegador → resetar, remover extensões
7. Windows Update → atualizar tudo
8. Antivírus → scan completo + offline scan
9. Trocar TODAS as senhas (de outro PC limpo!)
```

### "Recebi e-mail suspeito — como verificar?"

```
1. NUNCA clique no link ou abra o anexo
2. Ver o remetente REAL (email completo, não nome de exibição)
3. Passar mouse sobre link (ver URL real no canto inferior)
4. Erros de português/design tosco = red flag
5. Urgência falsa ("Sua conta será bloqueada!")
6. Remetente que você não conhece = apagar
7. Bancos/Governo NUNCA pedem senha por e-mail

Encaminhar phishing: report@phishing.gov.br (Brasil)
```

### "Senha vazou — o que fazer?"

```
1. Trocar senha IMEDIATAMENTE
2. Ativar MFA/2FA (autenticação de dois fatores)
3. Verificar se usava mesma senha em outros sites (trocar todos!)
4. Verificar haveibeenpwned.com (email em vazamentos?)
5. Verificar se regras de e-mail foram alteradas (forward oculto)
6. Verificar se tem cobranças indevidas
```

---

## 📝 Script — Verificação Rápida de Segurança

```powershell
function Test-SecurityHealth {
    Write-Host "=== VERIFICAÇÃO DE SEGURANÇA ===" -Foreground Cyan
    
    # Windows Defender
    $defender = Get-MpComputerStatus
    Write-Host "`nDefender:"
    Write-Host "  Tempo real: $(if($defender.RealTimeProtectionEnabled){'✅'}else{'❌'})"
    Write-Host "  Assinaturas atualizadas: $(if($defender.AntispywareSignatureAge -lt 3){'✅'}else{'⚠️'}) ($($defender.AntispywareSignatureLastUpdated))"
    Write-Host "  Anti-ransomware: $(if($defender.OnAccessProtectionEnabled){'✅'}else{'❌'})"
    
    # Firewall
    $fw = Get-NetFirewallProfile
    Write-Host "`nFirewall:"
    $fw | ForEach-Object { Write-Host "  $($_.Name): $(if($_.Enabled){'✅'}else{'❌'})" }
    
    # UAC
    $uac = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
    Write-Host "`nUAC: $(if($uac.EnableLUA -eq 1){'✅ Ativado'}else{'❌ DESATIVADO!'})"
    
    # RDP
    $rdp = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
    Write-Host "RDP: $(if($rdp.fDenyTSConnections -eq 1){'✅ Desabilitado'}else{'⚠️ HABILITADO!'})"
    
    # Inicialização suspeita
    $startup = Get-CimInstance Win32_StartupCommand | Where-Object {$_.User -ne "SYSTEM" -and $_.Command -notlike "*Microsoft*" -and $_.Command -notlike "*Windows*" -and $_.Command -notlike "*OneDrive*"} 
    if ($startup) {
        Write-Host "`n⚠️ Inicialização (não-Microsoft):"
        $startup | ForEach-Object { Write-Host "  $($_.Command)" }
    }
    
    # Windows Update pendente
    $updates = (Get-MpComputerStatus).AntispywareSignatureAge
    Write-Host "`nAssinaturas: $updates dias de idade $(if($updates -gt 7){'⚠️ MUITO ANTIGO!'})"
    
    # Conexões externas suspeitas
    $conns = Get-NetTCPConnection | Where-Object {$_.State -eq "Established" -and $_.RemoteAddress -notmatch "^127\.|^192\.168\.|^10\.|^172\.(1[6-9]|2[0-9]|3[01])\.|^169\.254\."} | Select -First 10
    if ($conns) {
        Write-Host "`nConexões externas ativas:"
        $conns | ForEach-Object {
            try { $proc = (Get-Process -Id $_.OwningProcess).Name } catch { $proc = "?" }
            Write-Host "  $($_.RemoteAddress):$($_.RemotePort) ← $proc"
        }
    }
    
    Write-Host "`n=== FIM ===" -Foreground Cyan
}
```

---

## ⚠️ Regras de Ouro

- **Backup 3-2-1** é sua ÚNICA defesa real contra ransomware
- **NUNCA desabilite UAC** — é chato mas salva vidas
- **RDP na internet sem VPN** = questão de tempo até ser atacado
- **Um antivírus só** — mais de um = conflito = falso senso de segurança
- **Patch Tuesday** (2ª terça do mês) → atualize na mesma semana
- **Senha única por serviço** — use gerenciador (Bitwarden, KeePass)
- **MFA em TUDO** que importa (e-mail, banco, redes sociais)
- **Desconfie de grátis** — "ativador", "crack", "keygen" = 80% têm malware

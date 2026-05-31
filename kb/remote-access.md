# 🖥️ Acesso Remoto — Guia Completo

> RDP, AnyDesk, TeamViewer, Quick Assist. Configurar, proteger e diagnosticar.
> Atualizado: 31/05/2026

---

## 🟢 Ferramentas

| Ferramenta | Tipo | Porta | Ideal para |
|-----------|------|-------|-----------|
| **RDP** (Remote Desktop) | Nativo Windows | 3389 | Rede local, servidores |
| **Quick Assist** | Nativo Windows | 443 | Suporte rápido |
| **AnyDesk** | Terceiro | 80/443/6568 | Suporte remoto internet |
| **TeamViewer** | Terceiro | 5938 | Suporte remoto completo |

---

## 🔥 RDP — Configurar e Diagnosticar

### Habilitar RDP

```powershell
# Ativar RDP
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

# Habilitar no firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Verificar se tá ativo
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" | Select fDenyTSConnections
```

### Problemas Comuns RDP

```
"RDP não conecta" →
1. Serviço RDP rodando? services.msc → Remote Desktop Services
2. Porta 3389 aberta? Test-NetConnection PC-ALVO -Port 3389
3. Firewall bloqueando?
4. Network Level Authentication (NLA) → se PC sem senha, não conecta

"Credenciais não funcionam" →
- Password expirou? (domínio)
- PC no domínio? Usar DOMINIO\usuario
- PC local? Usar .\usuario
```

### Segurança RDP

```powershell
# Forçar NLA
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name UserAuthentication -Value 1

# ⚠️ NUNCA exponha RDP (3389) direto na internet!
# Use VPN, RD Gateway, ou AnyDesk em vez disso
```

---

## 🟢 Quick Assist (Nativo, Grátis)

```
Windows 10/11 → Iniciar → "Quick Assist" / "Assistência Rápida"

1. Quem ajuda → "Ajudar alguém" → entrar com conta Microsoft → código
2. Quem recebe → "Obter ajuda" → digitar código → Permitir
```

Prós: Nativo, sem instalar nada, seguro.  
Contras: Precisa de conta Microsoft, ambas as partes precisam de Windows 10/11.

---

## 🎯 AnyDesk / TeamViewer

```powershell
# AnyDesk (mais leve, sem "uso comercial detectado")
winget install AnyDeskSoftwareGmbH.AnyDesk

# TeamViewer
winget install TeamViewer.TeamViewer
```

**"Uso comercial detectado" (TeamViewer)**
- Fecha TeamViewer, espera 5 min, reconecta
- Alternativa: usar AnyDesk
- Se frequente → cliente precisa de licença

---

## ⚠️ Dicas

- **NUNCA RDP direto na internet.** Usar VPN, RD Gateway, ou AnyDesk.
- **Quick Assist** é o jeito mais fácil pra suporte pontual.
- **AnyDesk > TeamViewer** pra uso gratuito (não bloqueia como comercial).

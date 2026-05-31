# ⚙️ BIOS/UEFI, BitLocker & Criptografia — Guia HelpDesk

> Secure Boot, TPM, BitLocker recovery, boot order, como acessar BIOS em cada marca.
> Atualizado: 31/05/2026

---

## 🟢 BIOS vs UEFI

```
BIOS (Legado)          UEFI (Moderno)
├── Tela azul/cinza    ├── Interface gráfica, mouse
├── MBR                 ├── GPT
├── < 2TB disco boot   ├── Sem limite
├── Sem Secure Boot    ├── Secure Boot
└── Teclado apenas     └── Mouse + teclado

⚠️ Desde 2018, TODO PC novo é UEFI.
   Só vê BIOS Legacy em PC com mais de 8 anos.
```

### Como Acessar BIOS/UEFI em Cada Marca

| Marca | Tecla | Nota |
|-------|-------|------|
| **Dell** | F2 | Ou F12 (boot menu) |
| **HP** | F10 | Ou Esc → F10 |
| **Lenovo** | F1 ou F2 | Ou Enter na tela da Lenovo |
| **Lenovo (Novo Vantage)** | Fn+F2 | ThinkPad tem tecla azul Enter |
| **ASUS** | F2 ou Del | Desktop = Del |
| **Acer** | F2 | |
| **Samsung** | F2 | |
| **Positivo** | F2 ou Del | Pode ser F10 em alguns |
| **Apple Intel** | Segurar Option | Cmd+R = Recovery |
| **Apple Silicon** | Segurar power | Depois → Opções |

⚠️ **Fast Boot ativado** = tecla pode não funcionar. Reiniciar SEGURANDO Shift = vai pro menu de recuperação.

---

## 🔐 Secure Boot & TPM

```
Secure Boot = SÓ boota SO assinado (Windows, Linux com shim)
TPM 2.0 = Chip de segurança → REQUISITO do Windows 11!

Problemas:
- "Precisa ativar TPM 2.0 pra instalar Windows 11"
  → BIOS → Security → TPM → Enabled
  → Intel = PTT (Platform Trust Technology)
  → AMD = fTPM
  → É virtual, não precisa chip físico!

- "Linux não boota com Secure Boot ativado"
  → Desabilitar Secure Boot OU usar distro com shim assinado
```

---

## 🛡️ BitLocker — Criptografia de Disco

### Verificar Status

```powershell
manage-bde -status
# Ou via GUI: Painel de Controle → Criptografia de Unidade de Disco BitLocker
```

### Problema #1: "Tela Azul Pedindo Recovery Key"

```
🚨 PÂNICO DO CLIENTE: Tela azul pedindo chave de recuperação!

Causas:
- Update de BIOS/UEFI (tripou o TPM)
- Troca de hardware (RAM, placa-mãe)
- Bateria CMOS morreu / reset de BIOS
- Secure Boot desabilitado do nada

ONDE ACHAR A CHAVE:
1. aka.ms/myrecoverykey → logar com conta Microsoft (se PC doméstico)
2. AD → BitLocker Recovery (se PC empresarial)
3. Papel impresso na gaveta (se cliente anotou — raro)
4. Pendrive USB de recuperação (se cliente criou)

⚠️ SEM A CHAVE = DADOS PERDIDOS! Não tem como quebrar.
```

### Suspender BitLocker Antes de Alterações

```powershell
# Antes de BIOS update, troca de hardware, dual boot:
manage-bde -protectors -disable C:
# Depois da alteração:
manage-bde -protectors -enable C:
```

### Ativar/Desativar BitLocker

```powershell
# Ativar
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -TpmProtector

# Desativar (descriptografar — demora horas!)
Disable-BitLocker -MountPoint "C:"
```

---

## ⚡ Boot Order — Problemas Clássicos

### "PC não boota do pendrive"

```
1. BIOS → Boot → Boot Order → USB em primeiro
2. Secure Boot desabilitado? (necessário pra algumas ISOs Linux)
3. Pendrive formatado como MBR ou GPT? Combinar com BIOS/UEFI:
   - Legacy BIOS → pendrive MBR
   - UEFI → pendrive GPT (FAT32)
4. Rufus > Media Creation Tool pra criar pendrive bootável
```

### "Windows não aparece no boot"

```
1. BIOS acha o disco? (Se não achar, disco morreu ou cabo soltou)
2. Boot Mode (Legacy vs UEFI) combinando com instalação Windows?
   - Se Windows instalou como UEFI e BIOS mudou pra Legacy = não boota
3. Boot repair:
   - Bootar pendrive Windows → Reparar computador → Prompt
   - bootrec /fixmbr
   - bootrec /fixboot
   - bootrec /rebuildbcd
```

---

## 🎯 Playbooks Rápidos

### "Atualização de BIOS deu tela azul pedindo BitLocker key"
```
1. Achar chave → aka.ms/myrecoverykey
2. Digitar chave → vai bootar
3. manage-bde -status → ver se tá pausado
4. Se pausado → manage-bde -protectors -enable C:
```

### "PC não detecta SSD NVMe"
```
1. BIOS → Storage → modo AHCI (não IDE)
2. SATA Operation → AHCI/NVMe
3. SSD mal encaixado no slot M.2
4. SSD incompatível? (SATA vs NVMe no mesmo slot M.2 — nem todo slot aceita ambos)
```

### "Vendo data/hora zerou"
```
= Bateria CMOS acabou
= Desktop: trocar CR2032 na placa-mãe
= Notebook: mais chato, às vezes soldada
= Consertar data/hora → BitLocker pode pedir recovery key
```

---

## 🧘 Dicas Jedi

- **BitLocker recovery key** é a pergunta mais importante antes de QUALQUER manutenção: "Você tem a chave do BitLocker salva?" Se não tiver, suspenda antes de mexer.
- **BIOS update desabilita Secure Boot** → reabilitar após update.
- **TPM não aparece na BIOS?** → Load BIOS Defaults → reboot → TPM reaparece.
- **Nunca desabilite Secure Boot a menos que necessário.** Windows 11 exige.
- **Boot Menu (F12/Dell, F9/HP, F12/Lenovo, Esc/ASUS)** = escolhe boot 1x sem mudar BIOS.

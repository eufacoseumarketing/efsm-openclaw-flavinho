# 🍎 macOS Fundamentals — Guia HelpDesk

> Arquitetura, versões, sistema de arquivos, UI, Finder. Tudo que muda do Windows pro Mac.
> Atualizado: 31/05/2026

---

## 🟢 Arquitetura

### Intel vs Apple Silicon (M1/M2/M3/M4)

| | Intel Mac | Apple Silicon (M1-M4) |
|---|-----------|----------------------|
| **Lançamento** | 2006-2021 | 2020-presente |
| **Arquitetura** | x86_64 | ARM64 (Apple) |
| **Boot** | EFI tradicional | iBoot + recoveryOS |
| **Sistema** | macOS 10.x a 12 | macOS 11+ (Big Sur+) |
| **Rosetta 2** | Não precisa | Emula apps Intel em ARM |
| **Windows (BootCamp)** | Sim | NÃO (só VM: Parallels, UTM) |
| **NVRAM Reset** | Cmd+Opt+P+R | Automático (não tem mais) |
| **SMC Reset** | Sim (placas Intel) | NÃO (tudo integrado no SoC) |

⚠️ **ISSO IMPORTA MUITO:** Apple Silicon não tem Boot Camp, não roda Windows nativo, não tem NVRAM/SMC reset manual.

### Versões do macOS

```
macOS 15 Sequoia   → 2024/2025   (atual)
macOS 14 Sonoma     → 2023/2024
macOS 13 Ventura    → 2022/2023
macOS 12 Monterey   → 2021/2022
macOS 11 Big Sur    → 2020 (início Apple Silicon)
macOS 10.15 Catalina → 2019 (fim 32-bit apps!)

⚠️ Catalina MATOU apps 32-bit. Muitos apps antigos quebraram.
```

---

## 🟢 Sistema de Arquivos

### APFS (Apple File System) — desde 2017

```
Características:
- Snapshots (Time Machine local)
- Clones (copiar arquivo = instantâneo, sem ocupar espaço extra)
- Criptografia nativa (FileVault)
- Space Sharing (volumes compartilham espaço livre no contêiner)

Estrutura típica do disco:
Container APFS
├── Macintosh HD (Sistema + Dados)
├── Macintosh HD - Dados (Dados do usuário, SEPARADO!)
├── Preboot
├── Recovery
└── VM (swap, sleep image)
```

⚠️ **Dados e Sistema são volumes SEPARADOS!** Desde Catalina, o sistema é montado read-only.

---

## 🟢 Interface e Finder

### O que é o quê

| Windows | macOS |
|---------|-------|
| Área de Trabalho | Desktop |
| Explorador de Arquivos | Finder |
| Barra de Tarefas | Dock |
| Menu Iniciar | Launchpad (F4) / Spotlight (Cmd+Espaço) |
| Bandeja do Sistema | Menu Bar (direita) |
| Barra de título do app | Menu Bar (topo da tela, muda por app!) |
| Painel de Controle | System Settings (Preferências do Sistema) |
| Gerenciador de Tarefas | Activity Monitor |
| Ctrl+Alt+Del | Cmd+Option+Esc |

### Atalhos Essenciais

```
Cmd+Espaço     → Spotlight (busca TUDO, abre apps, calcula)
Cmd+Q           → Fechar app COMPLETAMENTE (≠ botão vermelho!)
Cmd+W           → Fechar janela (app continua rodando)
Cmd+Tab         → Alternar apps (≠ janelas!)
Cmd+`           → Alternar janelas do MESMO app
Cmd+Shift+G     → Ir para pasta (digitar caminho)
Cmd+Shift+.     → Mostrar arquivos ocultos no Finder
Cmd+Option+Esc  → Forçar encerrar app (Ctrl+Alt+Del do Mac)
```

⚠️ **Botão vermelho (●) NÃO fecha o app!** Só fecha a janela. O app continua rodando (bolinha no Dock). Pra fechar = Cmd+Q.

---

## 🟡 Estrutura de Pastas

```
/                     → Raiz (mesmo conceito do Linux)
/Applications         → Apps (todos usuários)
~/Applications        → Apps (só seu usuário)
/System               → Sistema (intocável, read-only)
/Library              → Configs do sistema
~/Library             → Configs do seu usuário (oculta!)
/Users/nomeusuario    → Sua home (~)
/usr /bin /etc /var   → Unix padrão
/Volumes              → Discos externos montados
```

⚠️ `~/Library` é OCULTA por padrão (Finder → Ir → segurar Option → Library aparece)

---

## 🎯 Windows → macOS — Tabela de Equivalência

| Descrição | Windows | macOS |
|-----------|---------|-------|
| Gerenciador de tarefas | Task Manager | Activity Monitor |
| Editor de registro | Regedit | defaults (CLI) + .plist files |
| Serviços | services.msc | launchd (launchctl) |
| Informações do sistema | msinfo32 | System Information |
| Gerenciador de disco | diskmgmt.msc | Disk Utility |
| Firewall | Windows Firewall | Firewall (System Settings) |
| Terminal | cmd / PowerShell | Terminal.app |
| Atualizações | Windows Update | Software Update |
| Backup | File History / WSB | Time Machine |
| Restauração | System Restore | Recovery Mode → Reinstall macOS |
| Desinstalar | Add/Remove Programs | Arrastar app pra Lixeira (ou App Cleaner) |
| Pasta Programas | C:\Program Files\ | /Applications |
| Pasta Usuário | C:\Users\ | /Users/ |
| Arquivos do sistema | C:\Windows\ | /System/ |
| Arquivo oculto | Atributo Hidden | Nome começa com . (ponto) |

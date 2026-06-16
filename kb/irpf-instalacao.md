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
dir "C:\Program Files\IRPF2026" /b
dir "C:\Arquivos de Programas\IRPF2026" /b
```
Se mostrar arquivos (IRPF2026.exe, help, etc), ja esta instalado.

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
Se os links diretos nao funcionarem:
https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf

### 4. Executar o instalador

- O instalador EXIGE privilegios de administrador!
- Instalacao silenciosa (/VERYSILENT, /S) NAO funciona (web-wrapper)
- Abrir na sessao do usuario, nao como SYSTEM

#### Metodo A - Win+R com Ctrl+Shift+Enter (recomendado):
1. `Win+R` para abrir Executar
2. Digitar o caminho: `C:\Users\<usuario>\Downloads\IRPF2026Win32v1.5.exe`
3. `Ctrl+Shift+Enter` = executar como administrador
4. UAC: foco comeca no "Nao" → `Seta Esquerda` → `Enter` = Sim
5. Aguardar extracao (~5 segundos)
6. Tela de instalacao abre com foco em "Avancar" → `Enter`

#### Metodo B - Via Start-Process no PowerShell:
1. `Win+R` → `powershell` → `Enter`
2. Digitar:
   ```powershell
   Start-Process "C:\Users\<usuario>\Downloads\IRPF2026Win32v1.5.exe" -Verb RunAs -Wait
   ```
3. UAC: Seta Esquerda + Enter = Sim
4. Aguardar extracao (~5s)
5. Foco em Avancar → Enter

### 5. Navegar pelo assistente de instalacao
Apos a extracao, aparece o assistente. Foco comeca em "Avancar":
- Tela 1 (Boas-vindas): `Enter` = Avancar
- Tela 2 (Termos de licenca): `Enter` = Aceitar e Avancar
- Tela 3 (Pasta de destino): `Enter` = Avancar (manter padrao)
- Tela 4 (Confirmar): `Enter` = Instalar
- Aguardar a instalacao (~15-30 segundos)
- Tela 5 (Concluido): `Enter` = Concluir

### 6. Confirmar instalacao
```cmd
dir "C:\Program Files\IRPF2026" /b
dir "C:\Arquivos de Programas\IRPF2026" /b
```
Deve mostrar: `IRPF2026.exe`, `help`, `lib`, etc.

### 7. Verificar atalho
```cmd
dir "C:\Users\Public\Desktop\*IRPF*"
```

## Resumo de teclas
| Passo | Tecla |
|-------|-------|
| UAC - Confirmar Sim | `Seta Esquerda` + `Enter` |
| Extracao | Aguardar ~5s |
| Avancar (telas 1-4) | `Enter` |
| Instalar | `Enter` |
| Concluir | `Enter` |

## Observacoes importantes
- O arquivo para Windows se chama `IRPF2026Win32v1.5.exe` (~111 MB)
- Instalacao silenciosa NAO funciona (web-wrapper, retorna exit code 0 mas nao instala)
- O instalador PRECISA de internet durante a execucao
- PRECISA de privilegios de administrador (erro: "Precisa de privilegios de administrador para instalar este programa")
- Se o UAC estiver ativo, a tela fica preta no screenshot remoto — usar seta esquerda + Enter as cegas
- O agente Mesh roda como SYSTEM e nao mostra GUI na sessao do usuario — SEMPRE abrir via Executar/Explorer na sessao do usuario

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
16/06/2026 - Flavinho (atendimento EFSM 01, com informacoes do Zanatto)

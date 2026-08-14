# Windows — Criar usuário local sem senha + login automático

**Problema:** Preparar uma máquina Windows para ser usada por outra pessoa:
criar um usuário local (ex: "efsm") sem senha, como administrador, e fazer o
Windows entrar automaticamente nesse perfil ao ligar.

**Pré-requisitos:** Acesso administrativo na máquina (agente roda como SYSTEM).

## Passo a passo

1. Desativar descanso de tela e suspensão (regra de suporte):
   ```cmd
   powercfg /change monitor-timeout-ac 0
   powercfg /change standby-timeout-ac 0
   powercfg /change hibernate-timeout-ac 0
   ```

2. Verificar se o usuário já existe:
   ```cmd
   net user efsm
   ```

3. Criar o usuário sem senha:
   ```cmd
   net user efsm /add
   ```

4. Tornar administrador:
   ```cmd
   net localgroup Administradores efsm /add
   ```

5. Configurar login automático no registro (Winlogon):
   ⚠️ ATENÇÃO: `reg add ... /d ''` no PowerShell interpreta errado — o valor
   vazio vira o próximo argumento (`/f` vira a senha!). Usar PowerShell:
   ```powershell
   Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value '1' -Type String
   Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value 'efsm' -Type String
   Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value '' -Type String
   ```

6. Reiniciar (com confirmação do cliente):
   ```cmd
   shutdown /r /t 15 /c "Reinicio agendado para aplicar login automatico"
   ```

## Como confirmar que funcionou

Após o reboot (aguardar 2-3 min; o agente pode ficar "busy" logo após ligar):
```powershell
query user
Get-Process explorer -IncludeUserName | Select-Object UserName
```
- `query user` deve mostrar `>efsm console ... Ativo`
- `explorer` deve rodar como `User\efsm`

## Remover usuário antigo + pasta de perfil (ex: preparar máquina p/ outra pessoa)

⚠️ SEMPRE confirmar com o cliente antes (exclusão irreversível). Verificar quem está
logado antes (`query user`) — não remover usuário logado.

1. Remover a conta:
   ```cmd
   net user Dell /delete
   ```
2. Remover a pasta do perfil (docs, desktop, OneDrive, AppData) — ASSÍNCRONO,
   pasta grande demora (46k+ arquivos, vários minutos):
   ```powershell
   Remove-Item 'C:\ProgramData\PCR\del_dell.done' -ErrorAction SilentlyContinue
   Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile','-Command',"net user Dell /delete; Remove-Item -LiteralPath 'C:\Users\Dell' -Recurse -Force -ErrorAction SilentlyContinue; 'DONE' | Out-File 'C:\ProgramData\PCR\del_dell.done'"
   ```
3. Poll do marcador `C:\ProgramData\PCR\del_dell.done` (STATUS=RUNNING/FINISHED).
   Durante a exclusão dá pra conferir progresso: conta sumiu do `net user` e a pasta
   vai diminuindo (`Get-ChildItem -Recurse | Measure-Object`).
4. Limpar temporários: `Remove-Item 'C:\ProgramData\PCR\del_dell.*' -Force`

## Lições aprendidas

- ⛔ NUNCA montar script com here-string @'...'@ direto no `--cmd` do run.sh: as
  quebras de linha confundem o parse e o PowerShell fica esperando input — TRAVA o
  agente (agent-busy-cached/max-retries). Se precisar de script multi-linha, gravar
  o .ps1 com um comando de linha única (Set-Content com string única) ou usar
  Scheduled Task. Para remoção de pasta, o Start-Process inline de 1 linha funciona.
- Depois do reboot, o agente pode retornar `agent-busy-max-retries` ou a máquina
  pode "piscar" offline (segundo reboot de Windows Update). Esperar 1-2 min e tentar
  de novo — não spammar.
- Usuário criado com `net user /add` fica no grupo Usuários; adicionar a
  Administradores com `net localgroup Administradores <user> /add`.
- `net user /delete` remove só a conta; a pasta C:\Users\<nome> fica órfã e precisa
  de Remove-Item -Recurse -Force separado.

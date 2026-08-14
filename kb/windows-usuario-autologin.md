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

## Lições aprendidas

- Depois do reboot, o agente pode retornar `agent-busy-max-retries` ou a máquina
  pode "piscar" offline (segundo reboot de Windows Update). Esperar 1-2 min e tentar
  de novo — não spammar.
- Usuário criado com `net user /add` fica no grupo Usuários; adicionar a
  Administradores com `net localgroup Administradores <user> /add`.

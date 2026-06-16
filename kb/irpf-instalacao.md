# Instalacao do IRPF (Programa Imposto de Renda)

## Descricao
Instalar o programa da Receita Federal para declaracao de Imposto de Renda Pessoa Fisica.

## Pre-requisitos
- Windows 10/11 (32 ou 64 bits)
- 4 GB RAM
- 500 MB de espaco livre
- Conexao com internet (o instalador pode ser web-wrapper)
- Java Runtime (vem embutido no instalador)

## Passo a passo

### 1. Desativar descanso de tela
```cmd
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
```

### 2. Verificar se o IRPF ja esta instalado
```cmd
dir "C:\Program Files\IRPF*" /b
dir "C:\Program Files (x86)\IRPF*" /b
dir "C:\Arquivos de Programas\IRPF*" /b
```
Se algum diretorio aparecer, o IRPF ja esta instalado.

### 3. Baixar o instalador
- NAO usar link direto (os links da Receita mudam a cada ano e nao seguem padrao previsivel)
- Abrir o site oficial: https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf
- Na pagina, localizar os botoes de download por sistema operacional
- Clicar no botao "Windows" (geralmente o primeiro = 64 bits)
- O download vai para a pasta Downloads do usuario

### 4. Executar o instalador
O instalador do IRPF e um executavel GUI que precisa rodar na sessao do usuario.

Metodo A - Via PowerShell na sessao do usuario (recomendado):
1. `Win+R` para abrir Executar
2. Digitar: `powershell`
3. `Enter`
4. Na janela do PowerShell, digitar:
   ```powershell
   Start-Process "C:\Users\<usuario>\Downloads\IRPF2026Win64v1.5.exe" -Wait
   ```
5. Seguir o assistente de instalacao na tela
6. Clicar em "Sim" no UAC se aparecer

Metodo B - Via Explorer (fallback):
1. `Win+E` para abrir o Explorer
2. Navegar ate a pasta Downloads
3. Duplo clique no arquivo `IRPF2026Win64v1.5.exe`
4. Seguir o assistente na tela

### 5. Confirmar instalacao
```cmd
dir "C:\Program Files\IRPF2026" /b
dir "C:\Arquivos de Programas\IRPF2026" /b
```
Deve mostrar arquivos como `IRPF2026.exe`, `help`, etc.

### 6. Verificar atalho na area de trabalho
Deve existir um icone "IRPF 2026" na area de trabalho.

## Observacoes importantes
- O nome do arquivo de download varia: `IRPF2026Win64v1.5.exe`, `IRPF2026Windows.exe`, etc.
- NAO usar instalacao silenciosa (`/VERYSILENT`, `/S`) - o instalador retorna exit code 0 mas NAO instala os arquivos (web-wrapper)
- O instalador PRECISA de internet durante a execucao (baixa componentes adicionais)
- Se o instalador mostrar pop-up de erro, verificar conexao com internet e tentar novamente

## Links uteis
- Site oficial: https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf
- Portal e-CAC: https://cav.receita.fazenda.gov.br/
- App Meu Imposto de Renda (celular): Google Play / App Store

## Atualizado
16/06/2026 - Flavinho (atendimento EFSM 01)

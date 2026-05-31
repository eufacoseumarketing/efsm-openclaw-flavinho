# 📱 Mobile + PC e Áudio & Periféricos — Guia HelpDesk

> Android/iOS ↔ PC, parear, hotspot, MTP, fone de ouvido, microfone, webcam.
> Atualizado: 31/05/2026

---

## 📱 Android ↔ PC

### Transferir Arquivos

```
USB → Cabo conectado → puxar barra de notificação no celular
→ "Carregando via USB" → tocar → mudar pra "Transferir arquivos (MTP)"

⚠️ Se NÃO aparecer no PC:
1. Cabo USB é só carga? Testar outro cabo (MUITOS cabos baratos só carregam!)
2. Driver MTP faltando: Windows Update → Atualizações Opcionais → driver MTP
3. Debug USB ativado? Desabilitar Debug USB às vezes resolve
4. Celular travou na tela de bloqueio? Desbloquear enquanto conecta
```

### WhatsApp Web

```
Problema "WhatsApp Web desconecta toda hora"
1. Celular precisa estar conectado à internet SEMPRE
2. Economia de bateria → WhatsApp sem restrição
3. Wi-Fi do celular dormindo? Configurar Wi-Fi → Sempre ativo
4. iPhone: app WhatsApp precisa ficar aberto em segundo plano
```

### Hotspot (Roteador pelo Celular)

```
Celular compartilhando internet com o PC:

Android: Configurações → Conexões → Hotspot → ativar
iPhone: Ajustes → Acesso Pessoal → ativar

Problemas:
- PC não acha o hotspot: 2.4 GHz vs 5 GHz? Trocar banda no celular
- Consome MUITO plano de dados: cliente jura que é "ilimitado" mas reduz velocidade
- Windows Update consome GB em hotspot: configurar como "conexão limitada"
```

---

## 🍎 iPhone/iPad ↔ PC

```
Métodos de transferência (nenhum é tão simples quanto Android):

1. iTunes (clássico, difícil): instalar, conectar cabo, autorizar
2. iCloud: fotos sincronizam automático, arquivos via iCloud Drive
3. Fotos Windows: app Fotos → Importar → iPhone (funciona às vezes)
4. Google Drive / OneDrive: instalar no iPhone, upar, baixar no PC

⚠️ iPhone NÃO expõe arquivos como pen drive (Diferente do Android MTP).
   Cliente sempre acha "defeito" — não é!
```

### Problema Comum

```
"Conectei o iPhone e não aparece no PC"
1. iPhone pergunta "Confiar neste computador?" → TOCAR SIM
2. Tela desbloqueada na hora de conectar
3. iTunes instalado (precisa pra driver)
4. Cabo original Apple (cabos paralelos = só carga)
```

---

## 🎧 Headset e Microfone

### Jack P2 vs USB vs Bluetooth

| Tipo | Vantagem | Problema comum |
|------|---------|---------------|
| P2 (3.5mm) | Universal, simples | PCs novos NÃO têm entrada P2! Só USB-C |
| USB | Som digital, botões funcionam | Driver, Windows muda dispositivo padrão sozinho |
| Bluetooth | Sem fio, liberdade | Pareamento, delay, bateria acaba na call |

### "Microfone não funciona"

```
Windows 11: Configurações → Sistema → Som → Entrada
→ Verificar se o microfone certo tá selecionado
→ Testar (barra azul mexe quando você fala?)

Causas:
1. Dispositivo padrão errado (Windows troca sozinho!)
2. Microfone mutado no fio (botão físico no headset)
3. Permissão de microfone negada: Config → Privacidade → Microfone
4. Notebook: microfone interno vs headset (plug P2 detecta entrada? Driver Realtek)

Teams/Zoom: Configurações do app ignoram configurações do Windows!
→ Verificar DENTRO do app qual microfone tá selecionado
```

### Echo/Retorno em Chamada

```
1. "Ouvir este dispositivo" ativado → Som → Gravação → microfone → Escutar → DESMARCAR
2. Auto-falante causando microfonia → reduzir volume, usar headset
3. Dois dispositivos capturando o mesmo áudio
```

---

## 📷 Webcam

### "Câmera não funciona"

```
Solução escalada:
1. Verificar se a câmera tem tampa física de privacidade (HP, Lenovo!) 🔒
2. Config → Bluetooth e Dispositivos → Câmeras → desabilitar e reabilitar
3. Config → Privacidade → Câmera → permitir apps
4. fn+F6 ou fn+F10 (atalho de teclado da marca)
5. Device Manager → Imaging Devices → desinstalar driver → reiniciar
6. BIOS: verificar se câmera tá desabilitada (comum em Dell Latitude)
```

### Câmera com Imagem Preta/Verde

```
1. Driver da câmera corrompido → reinstalar do site do fabricante
2. Outro app sequestrou a câmera → Teams aberto, Zoom também = conflito
3. Iluminação fraca → câmera fica escura mesmo funcionando
```

---

## 🖨️ Impressora USB vs Bluetooth

```
Impressora Bluetooth:
1. Windows: Config → Bluetooth → Adicionar Dispositivo
2. Impressora em modo pareamento (piscando azul)
3. Após parear: Config → Impressoras → Adicionar → Bluetooth
4. ⚠️ Impressora Bluetooth imprime DEVAGAR e cai conexão direto.
   SEMPRE prefira Wi-Fi ou USB pra impressora!
```

---

## ⚡ Playbooks Rápidos

### "Conectei o celular e não aparece"
```
1. O cabo é de dados ou só carga? ⚡ Testar outro cabo.
2. Celular desbloqueado?
3. Notificação "Transferindo arquivos" ou "Somente carga"?
4. Driver MTP no Windows Update → Opcionais
```

### "Fone sem fio não aparece no Bluetooth"
```
1. Fone em modo pareamento? (segurar botão power 5s até LED piscar azul/vermelho)
2. Bluetooth do PC LIGADO?
3. Fone já pareado com outro dispositivo? Desemparelhar antes.
4. Notebook: modo avião desligado?
```

### "Microfone não funciona em chamada"
```
1. Windows trocou o dispositivo padrão? Verificar tanto no SOM quanto no APP.
2. Botão físico de mute no fio do headset?
3. Permissão de microfone no Windows?
4. Headset USB: trocar porta USB.
```

### "Som não sai no fone de ouvido"
```
1. Fone conectado certo? (Jack P2 tem que empurrar até o CLIQUE)
2. Som → Reprodução → definir como Dispositivo Padrão (botão direito)
3. Headset USB: driver Realtek/Genérico?
4. Notebook: às vezes muta auto-falante ao conectar P2 (é comportamento normal)
```

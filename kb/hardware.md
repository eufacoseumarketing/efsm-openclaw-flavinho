# 🔧 Hardware Diagnostics — Guia Rápido

> Diagnosticar "PC não liga", "tela azul", RAM, disco, superaquecimento sem abrir o gabinete.
> Atualizado: 31/05/2026

---

## 🟢 "PC Não Liga" — Diagnóstico Rápido

```
SINTOMA              → CAUSA PROVÁVEL
Nada acontece        → PSU, cabo de força, tomada
Liga e desliga       → PSU, curto, superaquecimento
Beeps (BIOS)         → RAM, GPU, placa-mãe (contar beeps!)
LED acende, tela off → Monitor, cabo, GPU
Liga, logo congela   → Disco, RAM, Windows corrompido
```

---

## 🟡 Diagnóstico por Software

### Memória RAM

```cmd
:: Ferramenta nativa do Windows
mdsched.exe
:: Reiniciar e testar → 1-2 horas
```

### Disco (HDD/SSD)

```powershell
# Saúde do disco
Get-PhysicalDisk | Select MediaType,Size,HealthStatus,OperationalStatus

# SMART via WMI
Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus | Select Active,PredictFailure

# Teste de superfície (chkdsk completo)
chkdsk C: /f /r
```

### CPU / Temperatura

```powershell
# Temperatura (precisa de HWMonitor ou similar)
# Não tem nativo! Alternativa:
Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace root/wmi | Select CurrentTemperature
```

### Bateria (Notebook)

```cmd
:: Relatório completo da bateria
powercfg /batteryreport /output C:\battery-report.html
```

### Eventos de hardware

```powershell
# Erros de disco nos logs
Get-WinEvent -LogName System | Where-Object {$_.Id -in 7,11,15,51,52,55,153,157} | Select -First 5

# Erros críticos de hardware
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.Level -eq 1} | Select TimeCreated,Id,Message
```

---

## 🔥 Sinais de Alerta por Componente

| Componente | Sinal | Ação |
|-----------|-------|------|
| **HDD** | Ruído de clique, 100% uso, chkdsk erros | Trocar IMEDIATO |
| **RAM** | BSOD aleatória, MEMORY_MANAGEMENT | Testar com mdsched |
| **CPU** | Desliga sozinho, muito lento | Verificar temperatura |
| **PSU** | PC desliga sob carga | Trocar fonte |
| **GPU** | Artefatos, tela preta, driver crash | Testar em outro PC |

---

## ⚠️ Quando escalar

- **Peça aberta** → Não tem como diagnosticar sem abrir
- **Ruído de clique no HDD** → Não tente "consertar", troque
- **Cheiro de queimado** → Desligue tudo, não ligue de novo
- **Capacitor estufado** → Trocar placa-mãe/fonte

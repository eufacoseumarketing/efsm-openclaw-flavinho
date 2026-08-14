$d="C:\temp_flavinho"
New-Item -ItemType Directory -Force $d | Out-Null

$arquivos = @(
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\_BIANC~1.PDF",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\_BIANC~2.PDF",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~1.HTM",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\Bianca Concierge..pptx.pdf",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\Bianca - Concierge..pptx.pdf",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\Bianca Concierge.pptx.pdf",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\Bianca Concierge.pptx - Google Slides.pdf",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BiancaConcierge_Estrategia_Completa.pptx",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~2.PPT",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BiancaConcierge_Premium.pptx",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~3.HTM",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~4.HTM",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~5.PPT",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~6.PPT",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~7.PPT",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~8.PPT",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~9.PPT",
    "C:\Users\efsm\Desktop\Backup Vanessa\Downloads\BIANCC~10.PPT"
)

foreach ($a in $arquivos) {
    if (Test-Path $a) {
        Copy-Item -Path $a -Dest $d -Force
        Write-Host "OK: $a"
    } else {
        Write-Host "FALTA: $a"
    }
}

# Criar zip com nome sem acentos
Add-Type -Assembly System.IO.Compression.FileSystem
$zip = "C:\temp_flavinho\BiancaConcierge_Arquivos.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($d, $zip)
Write-Host "ZIP CRIADO: $zip"
Write-Host "Tamanho: $((Get-Item $zip).Length / 1KB) KB"

$d="C:\temp_flavinho"
New-Item -ItemType Directory -Force $d | Out-Null
$src="C:\Users\efsm\Desktop\Backup Vanessa\Downloads"

$map = @{
    "_BIANC~1.PDF"   = "[bianca_concierge]_-_relatorio_.pdf";
    "_BIANC~2.PDF"   = "[bianca_concierge]_-_relatorio_fev-26_01-02-2026_a_28-02-2026 (1).pdf";
    "BIANCA~1.PDF"   = "Bianca - Concierge..pptx.pdf";
    "BIANCA~2.PDF"   = "Bianca Concierge..pptx.pdf";
    "BIANCA~3.PDF"   = "Bianca Concierge.pptx - Google Slides.pdf";
    "BIANCA~4.PDF"   = "Bianca Concierge.pptx.pdf";
    "BIANCA~1.PPT"   = "BiancaConcierge_Digital_v2 (1).pptx";
    "BIANCA~2.PPT"   = "BiancaConcierge_Digital_v2 (2).pptx";
    "BIANCA~3.PPT"   = "BiancaConcierge_Digital_v2 (3).pptx";
    "BIANCA~4.PPT"   = "BiancaConcierge_Digital_v2 (4).pptx";
    "BI5320~1.PPT"   = "BiancaConcierge_Digital_v2.pptx";
    "BIC3A0~1.PPT"   = "BiancaConcierge_Estrategia_Completa.pptx";
    "BIA7BD~1.PPT"   = "BiancaConcierge_Estrategia_Digital (1).pptx";
    "BIC0C6~1.PPT"   = "BiancaConcierge_Estrategia_Digital (2).pptx";
    "BI0F17~1.PPT"   = "BiancaConcierge_Estrategia_Digital.pptx";
    "BI0F39~1.PPT"   = "BiancaConcierge_Premium.pptx";
    "BIANCA~1.HTM"   = "BiancaConcierge_ProjecaoLeads (1).html";
    "BIANCA~2.HTM"   = "BiancaConcierge_ProjecaoLeads (2).html";
    "BIANCA~3.HTM"   = "BiancaConcierge_ProjecaoLeads.html"
}

foreach ($k in $map.Keys) {
    $f = Join-Path $src $k
    if (Test-Path $f) {
        Copy-Item -Path $f -Destination (Join-Path $d $map[$k]) -Force
        Write-Host "OK: $($map[$k])"
    } else {
        Write-Host "FALTA: $k"
    }
}

Write-Host "--- Compactando ZIP ---"
Add-Type -Assembly System.IO.Compression.FileSystem
$zip = "C:\temp_flavinho\BiancaConcierge_Arquivos.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($d, $zip)
$tam = [math]::Round((Get-Item $zip).Length/1KB, 0)
Write-Host "ZIP CRIADO: $zip"
Write-Host "TAMANHO: $tam KB"
Write-Host "ARQUIVOS NO ZIP: $( (Get-ChildItem $d | Where-Object { $_.Extension -ne '.zip' }).Count )"

$d="C:\temp_flavinho"
New-Item -ItemType Directory -Force $d | Out-Null
$src="C:\Users\efsm\Desktop\Backup Vanessa\Downloads"
Copy-Item "$src\_BIANC~1.PDF" $d -Force
Copy-Item "$src\_BIANC~2.PDF" $d -Force
Copy-Item "$src\BIANCC~1.HTM" "$d\ProjecaoLeads_2.html" -Force
Copy-Item "$src\Bianca Concierge..pptx.pdf" $d -Force
Copy-Item "$src\Bianca - Concierge..pptx.pdf" $d -Force
Copy-Item "$src\Bianca Concierge.pptx.pdf" $d -Force
Copy-Item "$src\Bianca Concierge.pptx - Google Slides.pdf" $d -Force
Copy-Item "$src\BiancaConcierge_Estrategia_Completa.pptx" $d -Force
Copy-Item "$src\BIANCC~2.PPT" "$d\Estrategia_Digital_2.pptx" -Force
Copy-Item "$src\BiancaConcierge_Premium.pptx" $d -Force
Copy-Item "$src\BIANCC~3.HTM" "$d\ProjecaoLeads_1.html" -Force
Copy-Item "$src\BIANCC~4.HTM" "$d\ProjecaoLeads.html" -Force
Copy-Item "$src\BIANCC~5.PPT" "$d\Digital_v2.pptx" -Force
Copy-Item "$src\BIANCC~6.PPT" "$d\Digital_v2_1.pptx" -Force
Copy-Item "$src\BIANCC~7.PPT" "$d\Digital_v2_2.pptx" -Force
Copy-Item "$src\BIANCC~8.PPT" "$d\Digital_v2_3.pptx" -Force
Copy-Item "$src\BIANCC~9.PPT" "$d\Digital_v2_4.pptx" -Force
Copy-Item "$src\BIANCC~10.PPT" "$d\Estrategia_Digital.pptx" -Force

# Compactar com Shell.Application (nativo, sem Add-Type)
$sh = New-Object -ComObject Shell.Application
$zip = "$d\BiancaConcierge.zip"
New-Item $zip -ItemType File -Force | Out-Null
$zipObj = $sh.NameSpace((Get-Item $zip).FullName)
$zipObj.CopyHere($sh.NameSpace($d).Items(), 16+4+8+256)
Start-Sleep -Seconds 3
Write-Host "ZIP: $zip"
Write-Host "Tam: $((Get-Item $zip).Length/1KB) KB"

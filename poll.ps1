$d="C:\Users\Public\PCR"
if (Test-Path "$d\scan.done") {
  Write-Host "STATUS=FINISHED"
  Get-Content "$d\scan.out"
} else {
  Write-Host "STATUS=RUNNING"
  Get-Content "$d\scan.out" -Tail 8 -ErrorAction SilentlyContinue
}

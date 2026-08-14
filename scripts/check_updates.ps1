$Session = New-Object -ComObject Microsoft.Update.Session
$Searcher = $Session.CreateUpdateSearcher()
try {
    $Result = $Searcher.Search("IsInstalled=0")
    Write-Host "Updates pendentes: $($Result.Updates.Count)"
    if ($Result.Updates.Count -gt 0) {
        $Result.Updates | Select-Object -First 5 Title | ForEach-Object { Write-Host "- $_" }
    }
} catch {
    Write-Host "Erro ao consultar updates: $($_.Exception.Message)"
}

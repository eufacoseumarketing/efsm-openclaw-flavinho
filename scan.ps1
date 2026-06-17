$d="C:\Users\Public\PCR"
$base=(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4Address.IPAddress -replace '\.\d+$',''
Get-NetNeighbor -AddressFamily IPv4 | Where-Object {$_.State -eq "Reachable" -or $_.State -eq "Stale"} | ForEach-Object {
  $ip=$_.IPAddress
  foreach ($p in 9100,631,515) {
    if ((Test-NetConnection $ip -Port $p -WarningAction SilentlyContinue).TcpTestSucceeded) {
      "$ip -> impressora (porta $p)"
      break
    }
  }
} *>&1 | Out-File -Encoding utf8 "C:\Users\Public\PCR\scan.out"
"DONE" | Out-File "C:\Users\Public\PCR\scan.done"

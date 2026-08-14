$d="$env:PUBLIC\PCR"
1..30 | ForEach-Object {
  $ip="192.168.15.$_"
  foreach ($p in 9100,631,515) {
    if ((Test-NetConnection $ip -Port $p -WarningAction SilentlyContinue -InformationLevel Quiet).TcpTestSucceeded) {
      "$ip -> impressora (porta $p)"
      break
    }
  }
} *>&1 | Out-File -Encoding utf8 "$d\scan.out"
"DONE" | Out-File "$d\scan.done"

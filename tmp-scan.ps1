$d="$env:PUBLIC\PCR"
$ips=@("192.168.15.27","192.168.15.50","192.168.15.51","192.168.15.61","192.168.15.65")
foreach ($ip in $ips) {
  foreach ($p in 9100,631,515) {
    $r=Test-NetConnection $ip -Port $p -WarningAction SilentlyContinue -InformationLevel Quiet
    if ($r.TcpTestSucceeded) {
      "$ip -> IMPRESSORA port $p"
      break
    }
  }
}

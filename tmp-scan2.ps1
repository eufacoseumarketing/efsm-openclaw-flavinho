$d="C:\Users\Public\PCR"
"=== INICIO DO SCAN ===" > "$d\scan2.out"
1..254 | ForEach-Object {
  $ip="192.168.15.$_"
  $ping=Test-Connection $ip -Count 1 -Quiet -TimeToLive 64
  if ($ping) {
    "$ip RESPONDEU PING" >> "$d\scan2.out"
    foreach ($p in 631,9100,515) {
      $t=New-Object System.Net.Sockets.TcpClient
      $r=$t.BeginConnect($ip,$p,$null,$null)
      if ($r.AsyncWaitHandle.WaitOne(1500)) {
        try { $t.EndConnect($r); "$ip -> IMPRESSORA porta $p" >> "$d\scan2.out" } catch {}
      }
      $t.Close()
    }
  }
}
"=== FIM DO SCAN ===" >> "$d\scan2.out"

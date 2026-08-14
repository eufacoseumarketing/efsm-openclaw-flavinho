$out="C:\Users\Public\PCR\scan3.out"
"=== SCAN INICIADO $(Get-Date) ===" > $out
$ping=New-Object System.Net.NetworkInformation.Ping
$subnet="192.168.15."
$found=@()
1..254 | ForEach-Object {
  $ip="$subnet$_"
  try {
    $r=$ping.Send($ip, 500)
    if ($r.Status -eq "Success") {
      "$ip RESPONDEU" >> $out
      $found+=$ip
    }
  } catch {}
}
"=== ${found.Count} IPs encontrados, escaneando portas... ===" >> $out
foreach ($ip in $found) {
  foreach ($p in 631,9100,515) {
    try {
      $t=New-Object System.Net.Sockets.TcpClient
      $r=$t.BeginConnect($ip,$p,$null,$null)
      if ($r.AsyncWaitHandle.WaitOne(1500)) {
        try { $t.EndConnect($r); "$ip : $p ABERTO *** IMPRESSORA? ***" >> $out } catch {}
      }
      $t.Close()
    } catch {}
  }
}
"=== SCAN FINALIZADO $(Get-Date) ===" >> $out

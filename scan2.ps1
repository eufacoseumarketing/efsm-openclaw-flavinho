$timeout = 1500
$d = "C:\Users\Public\PCR"
2..15 | ForEach-Object {
    $ip = "192.168.15.$_"
    foreach ($port in @(9100, 631, 515)) {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $ar = $tcp.BeginConnect($ip, $port, $null, $null)
        if ($ar.AsyncWaitHandle.WaitOne($timeout, $false)) {
            try {
                $tcp.EndConnect($ar)
                "$ip -> aberta porta $port" | Out-File -Append -Encoding utf8 "$d\scan2.out"
                $tcp.Close()
                break
            } catch {
                $tcp.Close()
            }
        } else {
            $tcp.Close()
        }
    }
}
"DONE" | Out-File "$d\scan2.done"

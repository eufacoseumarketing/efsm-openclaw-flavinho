Write-Host "=== REDE DO PC ==="
Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway} | Select-Object InterfaceAlias,IPv4Address,IPv4DefaultGateway | Format-List
Write-Host "=== TABELA ARP ==="
Get-NetNeighbor -AddressFamily IPv4 | Where-Object {$_.State -eq "Reachable" -or $_.State -eq "Stale"} | Select-Object IPAddress,LinkLayerAddress,State | Sort-Object IPAddress

Add-Type -Name F -Namespace Y -MemberDefinition '[DllImport("user32.dll")]public static extern bool SetForegroundWindow(IntPtr h);'
$p = Get-Process -Name SystemSettings -ErrorAction SilentlyContinue | Select -First 1
if ($p) {
  [Y.F]::SetForegroundWindow($p.MainWindowHandle)
  Write-Host "Focou SystemSettings"
} else {
  Write-Host "SystemSettings nao encontrado"
}

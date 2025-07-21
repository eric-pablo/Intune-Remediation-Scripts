# Remediation Script for Intune Proactive Remediation

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\DevTunnels"
$desiredDisableAnon = 1
$desiredDisableDevTunnels = 1
$desiredAllowedTenantIds = "e30eae94-02d5-4e2a-b005-8f04dda258d4" # Replace with your actual tenant IDs

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the required values
Set-ItemProperty -Path $regPath -Name "DisableAnonymousTunnelAccess" -Value $desiredDisableAnon -Type DWord
Set-ItemProperty -Path $regPath -Name "DisableDevTunnels" -Value $desiredDisableDevTunnels -Type DWord
Set-ItemProperty -Path $regPath -Name "AllowedTenantIds" -Value $desiredAllowedTenantIds -Type String

Write-Output "Remediation complete: Dev Tunnels policy registry settings configured."
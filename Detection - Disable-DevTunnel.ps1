# Detection Script for Intune Proactive Remediation

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\DevTunnels"
$desiredDisableAnon = 1
$desiredDisableDevTunnels = 1
$desiredAllowedTenantIds = "e30eae94-02d5-4e2a-b005-8f04dda258d4" # Replace with your actual tenant IDs

$compliant = $true

# Check if registry path exists
if (-not (Test-Path $regPath)) {
    $compliant = $false
} else {
    $props = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue

    if ($props.DisableAnonymousTunnelAccess -ne $desiredDisableAnon) { $compliant = $false }
    if ($props.DisableDevTunnels -ne $desiredDisableDevTunnels) { $compliant = $false }
    if ($props.AllowedTenantIds -ne $desiredAllowedTenantIds) { $compliant = $false }
}

if ($compliant) {
    Write-Output "Compliant"
    exit 0
} else {
    Write-Output "Non-compliant"
    exit 1
}

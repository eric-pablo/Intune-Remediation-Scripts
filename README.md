# Intune-Remediation-Scripts
Intune Remediation Script Repository
This repository provides Intune Remediation Scripts to help automate the detection and correction of common configuration, security, and compliance issues on Windows devices managed via Microsoft Intune.

What are Intune Remediation Scripts?
Remediation scripts in Intune are a feature within Device Management that:
1. Detect if a device meets a desired configuration or compliance state
2. Remediate (fix) the problem if it is found
3. Log actions and results in the Intune portal for admin review

This process ensures devices remain compliant and secure without relying only on manual intervention.

Repository Structure
Each remediation comprises two PowerShell scripts:
- Detection Script: Checks if the device is compliant. Exit code 0 for compliance; exit code 1 to trigger remediation.
- Remediation Script: Runs only if the detection script finds an issue (exit code 1). Implements corrective actions, such as starting services, modifying registry values, or deleting unwanted files. Should exit with 0 after remediation.

Example directory layout:
```
Remediations/
  └── ServiceCheck/
      ├── Detect-Service.ps1
      └── Remediate-Service.ps1
```
      
How Remediation Scripts Work
Component - Description
Detection - PowerShell script to test compliance. Exit 0: compliant, exit 1: not compliant.
Remediation - PowerShell script to correct the issue found. Runs only if detection indicates non-compliance.
Assignment - Defines schedule (e.g., every 8 hours, at user login, device reboot) and target groups.
Reporting - Intune logs script results for admin visibility in the portal.

Requirements
Licensing: Windows 10/11 Enterprise E3/E5, or Microsoft 365 E3/E5 licenses required. Not supported on Microsoft Business Premium.

Limitations:
 - Up to 200 remediation script packages per tenant.
 - Scripts must be written in PowerShell.

Deployment & Execution
 - Go to Endpoint Security › Remediations in the Endpoint Manager portal.
 - Upload detection and remediation scripts, assign to device/user groups, and set execution schedule.
 - Scripts run according to the specified interval (e.g., every 8 hours) or can be triggered on-demand for ad-hoc fixes.

Logging & Troubleshooting
Key log files for monitoring and troubleshooting:
 - IntuneManagementExtension.log
 - AgentExecutor.log
 - HealthScripts.log

All are located under:
C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\.

Scripting Best Practices
 - Consistency: Keep detection and remediation scripts structurally similar for maintainability.
 - Idempotency: Ensure remediation only changes items that are out-of-compliance (don’t reapply settings unnecessarily).
 - Clear Output: Use Write-Output for script results, making logs easy to interpret.
 - Use exit codes: Exit 0 for success/compliance, exit 1 for issues/non-compliance.

Example: Registry Value Remediation

Detection Script (Detect-Registry.ps1)

```powershell
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Name = "HiberbootEnabled"
$ExpectedValue = 0

try {
  $Registry = Get-ItemProperty -Path $Path -Name
  $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name

  if ($Registry -eq $ExpectedValue) {
    Write-Output "Compliant"
    exit 0

  } else {
    Write-Output "Not Compliant"
    exit 1
  }
    
  } catch {
    Write-Output "Not Compliant"
    exit 1
  }
```

Remediation Script (Remediate-Registry.ps1)

```powershell
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Name = "HiberbootEnabled"
$DesiredValue = 0

Set-ItemProperty -Path $Path -Name $Name -Value $DesiredValue -Force
Write-Output "Remediated"
exit 0
```

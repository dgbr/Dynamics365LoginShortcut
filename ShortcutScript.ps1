param(
  [Parameter(Mandatory=$true, Position=1)]
	[string]$crmShortcutsDir,
  [Parameter(Mandatory=$true, Position=2)]
	[string]$instanceName
)

Write-Host "Entering ShortcutScript.ps1..."

# Create Credentials folder
$credentialsPath = "$crmShortcutsDir\Credentials"
if (-not (Test-Path $credentialsPath)){
    md $credentialsPath
}

# Store encrypted credentials if they're not already stored in the Credentials folder
if(![System.IO.File]::Exists("$credentialsPath\$instanceName")){
	Get-Credential | Export-CliXml -Path "$credentialsPath\$instanceName"
}

#Retrieve credentials from encrypted xml file
$credentials = Import-Clixml -Path "$credentialsPath\$instanceName"

<DIRECTORY>\CRM_Shortcuts3\SetupTools.ps1 -crmShortcutsDir <DIRECTORY>\CRM_Shortcuts3
<DIRECTORY>\CRM_Shortcuts3\LoginToDynamics.ps1 -url <URL> -username <USERNAME> -password <PASSWORD> -crmShortcutsDir <DIRECTORY>\CRM_Shortcuts3

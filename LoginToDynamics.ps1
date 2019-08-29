
param(
  [Parameter(Mandatory=$true, Position=2)]
	[string]$urlInput,
	[Parameter(Mandatory=$true, Position=2)]
	[string]$usernameInput,
	[Parameter(Mandatory=$true, Position=3)]
	[string]$passwordInput,
	[Parameter(Mandatory=$true, Position=4)]
	[string]$crmShortcutsDir,
    $Browser = "Chrome"
)

$toolsDir = "$crmShortcutsDir\Tools"

function Load-Selenium {
	
	if(!("OpenQA.Selenium.By" -as [type])) {

        $selenumDir ="$toolsDir\Selenium.WebDriver.3.141.0\lib\net40"
        if(!($WebDriverPath = Resolve-Path $selenumDir -ErrorAction SilentlyContinue)) {
            Write-Host "Getting Selenium path"
            $WebDriverPath = Resolve-Path "$selenumDir"
        }
        Add-Type -Path (Join-Path $WebDriverPath WebDriver.dll)
    }

    $Env:Path += ";" + ((Resolve-Path $toolsDir) -join ";")
}


function Get-Selenium {

    param(
        [Parameter(Mandatory)]
        $Browser
    )

    $Driver = switch($Browser) {
        "InternetExplorer" { "IE" }
        default { $_ }
    }

    if(!("OpenQA.Selenium.${Driver}.${Browser}Driver" -as [type])) {
        Load-Selenium
    }

    return ($global:Selenium = New-Object OpenQA.Selenium.${Driver}.${Browser}Driver)
}

Write-Host "Entering LoginToDynamics.ps1..."

$Selenium = Get-Selenium $Browser
$Selenium.Navigate().GoToUrl($urlInput)

Start-Sleep 3
if(($username = $Selenium.FindElementByCssSelector('input[type="email"]')) -and $username.Displayed) {
    $username.SendKeys($usernameInput)
}

Start-Sleep 3
$Selenium.FindElementById("idSIButton9").Click()

Start-Sleep 3
if(($password = $Selenium.FindElementByCssSelector('input[type="password"]')) -and $password.Displayed) {
    $password.SendKeys($passwordInput)
}

Start-Sleep 3
$Selenium.FindElementById("idSIButton9").Click()

Start-Sleep 3
$Selenium.FindElementById("KmsiCheckboxField").Click()

Start-Sleep 3
$Selenium.FindElementById("idSIButton9").Click()

#  Modified version of code retrieved from: https://gist.github.com/Jaykul/d16a390e36ec3ba54cd5e3f760cfb59e

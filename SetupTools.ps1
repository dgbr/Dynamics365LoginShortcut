param(
	[Parameter(Mandatory=$true, Position=1)]
	[string]$crmShortcutsDir,
	[ValidateSet("Chrome", "Firefox", "InternetExplorer", "Edge")] 
    $Browser = "Chrome"
)

# Check for hosted NuGet CLI tool
$toolsDir = "$crmShortcutsDir\Tools"

if (-not (Test-Path $toolsDir)){
    Write-Host "Setting up tools..."
    md "$toolsDir"
}

$nugetExe = "$toolsDir\nuget.exe"

# Download Nuget
if(![System.IO.File]::Exists($nugetExe))
{
	Write-Host "Downloading NuGet CLI..."
	Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "$toolsDir\nuget.exe"
	$nugetExe = "$toolsDir" + "\nuget.exe"
}

# Download Selenium.WebDriver
if(-not (Test-Path "$toolsDir\Selenium.WebDriver.3.141.0")){
    Write-Host "Downloading Selenium.WebDriver... " 
    &$nugetExe install 'Selenium.WebDriver' -Source 'https://api.nuget.org/v3/index.json' -O "$toolsDir"
}

$thisScriptRoot = if ($PSScriptRoot -eq "") { "." } else { $PSScriptRoot }

# Download ChromeDriver
if(![System.IO.File]::Exists("$toolsDir\chromedriver.exe")){
    Write-Host "Downloading Chrome Driver... " 
    $chromeDriverRelativeDir = "Tools"
    $chromeDriverDir = $(Join-Path $thisScriptRoot $chromeDriverRelativeDir)
    $chromeDriverFileLocation = $(Join-Path $chromeDriverDir "chromedriver.exe")
    $chromeVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe").FileVersion
    $chromeMajorVersion = $chromeVersion.split(".")[0]

    if (-Not (Test-Path $chromeDriverDir -PathType Container)) {
      New-Item -ItemType directory -Path $chromeDriverDir
    }

    if (Test-Path $chromeDriverFileLocation -PathType Leaf) {
      $chromeDriverFileVersion = (& $chromeDriverFileLocation --version)
      $chromeDriverFileVersionHasMatch = $chromeDriverFileVersion -match "ChromeDriver (\d+\.\d+\.\d+(\.\d+)?)"
      $chromeDriverCurrentVersion = $matches[1]

      if (-Not $chromeDriverFileVersionHasMatch) {
        Exit
      }
    }
    else {
      $chromeDriverCurrentVersion = ''
    }

    if ($chromeMajorVersion -lt 73) {
      $chromeDriverExpectedVersion = "2.46"
      $chromeDriverVersionUrl = "https://chromedriver.storage.googleapis.com/LATEST_RELEASE"
    }
    else {
      $chromeDriverExpectedVersion = $chromeVersion.split(".")[0..2] -join "."
      $chromeDriverVersionUrl = "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_" + $chromeDriverExpectedVersion
    }

    $chromeDriverLatestVersion = Invoke-RestMethod -Uri $chromeDriverVersionUrl

    Write-Verbose "Update ChromeDriver if patch exists"
    $needUpdateChromeDriver = $chromeDriverCurrentVersion -ne $chromeDriverLatestVersion

    if ($needUpdateChromeDriver) {
      $chromeDriverZipLink = "https://chromedriver.storage.googleapis.com/" + $chromeDriverLatestVersion + "/chromedriver_win32.zip"
      Write-Verbose "Will download $chromeDriverZipLink"
      $chromeDriverZipFileLocation = $(Join-Path $chromeDriverDir "chromedriver_win32.zip")

      Invoke-WebRequest -Uri $chromeDriverZipLink -OutFile $chromeDriverZipFileLocation
      Expand-Archive $chromeDriverZipFileLocation -DestinationPath $chromeDriverDir -Force
      Remove-Item -Path $chromeDriverZipFileLocation -Force
      Write-Verbose "chromedriver updated to version (& $chromeDriverFileLocation --version)"
    }
}

# ChromeDriver Installation is a modified version of code retrieved from: https://codeofclimber.ru/2019/getting-chromedriver-updates/

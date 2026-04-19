param(
  [string]$Runtime = "win-x64"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSCommandPath
$OutputRoot = Join-Path $ProjectRoot "Bin"
$ReleaseRoot = Join-Path $ProjectRoot "Releases"
$ReleaseDirectory = Join-Path $ReleaseRoot $Runtime
$BuildStamp = [Guid]::NewGuid().ToString("N")
$PayloadDirectory = Join-Path $OutputRoot "payload"
$CliPublishDirectory = Join-Path $OutputRoot ("synrix-publish-" + $BuildStamp)
$InstallerPublishDirectory = Join-Path $OutputRoot ("installer-publish-" + $BuildStamp)
$CliExecutablePath = Join-Path $OutputRoot "synrix.exe"
$InstallerExecutablePath = Join-Path $OutputRoot "SynrixInstaller.exe"
$CliReleasePath = Join-Path $ReleaseDirectory "synrix.exe"
$InstallerReleasePath = Join-Path $ReleaseDirectory "SynrixInstaller.exe"
$PayloadPath = Join-Path $PayloadDirectory "synrix.exe"

function Assert-LastExitCode {
  param(
    [string]$Action
  )

  if ($LASTEXITCODE -ne 0) {
    throw "$Action Failed With Exit Code $LASTEXITCODE"
  }
}

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  SYNRIX BUILD SCRIPT" -ForegroundColor Cyan
Write-Host "  VERSION 5.2.4" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "CHECKING .NET INSTALLATION..." -ForegroundColor Yellow

$DotnetVersion = dotnet --version 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERROR: .NET SDK NOT FOUND" -ForegroundColor Red
  Write-Host "PLEASE INSTALL .NET 8.0 OR HIGHER FROM https://dotnet.microsoft.com" -ForegroundColor Red
  exit 1
}

Write-Host "FOUND .NET VERSION: $DotnetVersion" -ForegroundColor Green
Write-Host ""

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
New-Item -ItemType Directory -Force -Path $PayloadDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $ReleaseDirectory | Out-Null

Write-Host "PUBLISHING SYNRIX CLI..." -ForegroundColor Yellow

dotnet publish (Join-Path $ProjectRoot "Synrix.Publish.csproj") `
  --configuration Release `
  --runtime $Runtime `
  --self-contained true `
  --output $CliPublishDirectory `
  /p:PublishSingleFile=true `
  /p:EnableCompressionInSingleFile=true `
  /p:IncludeNativeLibrariesForSelfExtract=true
Assert-LastExitCode "Publishing SYNRIX CLI"

$PublishedCliExecutable = Join-Path $CliPublishDirectory "synrix.exe"
if (!(Test-Path $PublishedCliExecutable)) {
  throw "PUBLISHED CLI EXECUTABLE NOT FOUND AT $PublishedCliExecutable"
}

Copy-Item $PublishedCliExecutable $CliExecutablePath -Force
Copy-Item $PublishedCliExecutable $PayloadPath -Force
Copy-Item $PublishedCliExecutable $CliReleasePath -Force

Write-Host "PUBLISHING WINDOWS INSTALLER..." -ForegroundColor Yellow

dotnet publish (Join-Path $ProjectRoot "Installer\SynrixInstaller.csproj") `
  --configuration Release `
  --runtime $Runtime `
  --self-contained true `
  --output $InstallerPublishDirectory `
  /p:PublishSingleFile=true `
  /p:EnableCompressionInSingleFile=true `
  /p:SynrixPayloadPath="$PayloadPath"
Assert-LastExitCode "Publishing Windows installer"

$PublishedInstallerExecutable = Join-Path $InstallerPublishDirectory "SynrixInstaller.exe"
if (!(Test-Path $PublishedInstallerExecutable)) {
  throw "PUBLISHED INSTALLER NOT FOUND AT $PublishedInstallerExecutable"
}

Copy-Item $PublishedInstallerExecutable $InstallerExecutablePath -Force
Copy-Item $PublishedInstallerExecutable $InstallerReleasePath -Force

Write-Host ""
Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "CLI EXECUTABLE: $CliExecutablePath" -ForegroundColor Green
Write-Host "INSTALLER EXE: $InstallerExecutablePath" -ForegroundColor Green
Write-Host "DOWNLOADABLE CLI: $CliReleasePath" -ForegroundColor Green
Write-Host "DOWNLOADABLE INSTALLER: $InstallerReleasePath" -ForegroundColor Green
Write-Host ""

$CliInfo = Get-Item $CliExecutablePath
$InstallerInfo = Get-Item $InstallerExecutablePath

Write-Host "CLI SIZE: $([math]::Round($CliInfo.Length / 1MB, 2)) MB" -ForegroundColor Cyan
Write-Host "INSTALLER SIZE: $([math]::Round($InstallerInfo.Length / 1MB, 2)) MB" -ForegroundColor Cyan
Write-Host ""

Write-Host "TESTING SYNRIX CLI..." -ForegroundColor Yellow
& $CliExecutablePath --version
Assert-LastExitCode "Testing SYNRIX CLI"
Write-Host ""

Write-Host "TESTING INSTALLER USAGE OUTPUT..." -ForegroundColor Yellow
& $InstallerExecutablePath --help
Assert-LastExitCode "Testing Installer Usage Output"
Write-Host ""

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  BUILD COMPLETE!" -ForegroundColor Green
Write-Host "  RUN: .\Bin\SynrixInstaller.exe" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

param(
  [string]$Runtime = "win-x64"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSCommandPath
$OutputRoot = Join-Path $ProjectRoot "Bin"
$PayloadDirectory = Join-Path $OutputRoot "payload"
$CliPublishDirectory = Join-Path $OutputRoot "synrix-publish"
$InstallerPublishDirectory = Join-Path $OutputRoot "installer-publish"
$CliExecutablePath = Join-Path $OutputRoot "synrix.exe"
$InstallerExecutablePath = Join-Path $OutputRoot "SynrixInstaller.exe"
$PayloadPath = Join-Path $PayloadDirectory "synrix.exe"

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  SYNRIX BUILD SCRIPT" -ForegroundColor Cyan
Write-Host "  VERSION 2.0.0" -ForegroundColor Cyan
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

if (Test-Path $CliPublishDirectory) {
  Remove-Item $CliPublishDirectory -Recurse -Force
}

if (Test-Path $InstallerPublishDirectory) {
  Remove-Item $InstallerPublishDirectory -Recurse -Force
}

Write-Host "PUBLISHING SYNRIX CLI..." -ForegroundColor Yellow

dotnet publish (Join-Path $ProjectRoot "Synrix.Publish.csproj") `
  --configuration Release `
  --runtime $Runtime `
  --self-contained true `
  --output $CliPublishDirectory `
  /p:PublishSingleFile=true `
  /p:EnableCompressionInSingleFile=true `
  /p:IncludeNativeLibrariesForSelfExtract=true

$PublishedCliExecutable = Join-Path $CliPublishDirectory "synrix.exe"
if (!(Test-Path $PublishedCliExecutable)) {
  throw "PUBLISHED CLI EXECUTABLE NOT FOUND AT $PublishedCliExecutable"
}

Copy-Item $PublishedCliExecutable $CliExecutablePath -Force
Copy-Item $PublishedCliExecutable $PayloadPath -Force

Write-Host "PUBLISHING WINDOWS INSTALLER..." -ForegroundColor Yellow

dotnet publish (Join-Path $ProjectRoot "Installer\SynrixInstaller.csproj") `
  --configuration Release `
  --runtime $Runtime `
  --self-contained true `
  --output $InstallerPublishDirectory `
  /p:PublishSingleFile=true `
  /p:EnableCompressionInSingleFile=true `
  /p:SynrixPayloadPath="$PayloadPath"

$PublishedInstallerExecutable = Join-Path $InstallerPublishDirectory "SynrixInstaller.exe"
if (!(Test-Path $PublishedInstallerExecutable)) {
  throw "PUBLISHED INSTALLER NOT FOUND AT $PublishedInstallerExecutable"
}

Copy-Item $PublishedInstallerExecutable $InstallerExecutablePath -Force

Write-Host ""
Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "CLI EXECUTABLE: $CliExecutablePath" -ForegroundColor Green
Write-Host "INSTALLER EXE: $InstallerExecutablePath" -ForegroundColor Green
Write-Host ""

$CliInfo = Get-Item $CliExecutablePath
$InstallerInfo = Get-Item $InstallerExecutablePath

Write-Host "CLI SIZE: $([math]::Round($CliInfo.Length / 1MB, 2)) MB" -ForegroundColor Cyan
Write-Host "INSTALLER SIZE: $([math]::Round($InstallerInfo.Length / 1MB, 2)) MB" -ForegroundColor Cyan
Write-Host ""

Write-Host "TESTING SYNRIX CLI..." -ForegroundColor Yellow
& $CliExecutablePath --version
Write-Host ""

Write-Host "TESTING INSTALLER USAGE OUTPUT..." -ForegroundColor Yellow
& $InstallerExecutablePath --help
Write-Host ""

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  BUILD COMPLETE!" -ForegroundColor Green
Write-Host "  RUN: .\Bin\SynrixInstaller.exe" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# SYNRIX BUILD SCRIPT
# BUILDS THE SYNRIX EXECUTABLE

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  SYNRIX BUILD SCRIPT" -ForegroundColor Cyan
Write-Host "  VERSION 1.0.0" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# CHECK IF .NET IS INSTALLED
Write-Host "CHECKING .NET INSTALLATION..." -ForegroundColor Yellow

$DotnetVersion = dotnet --version 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: .NET SDK NOT FOUND" -ForegroundColor Red
    Write-Host "PLEASE INSTALL .NET 6.0 OR HIGHER FROM https://dotnet.microsoft.com" -ForegroundColor Red
    exit 1
}

Write-Host "FOUND .NET VERSION: $DotnetVersion" -ForegroundColor Green
Write-Host ""

# BUILD PROJECT
Write-Host "BUILDING SYNRIX..." -ForegroundColor Yellow

# METHOD 1: USING DOTNET PUBLISH (CREATES SELF-CONTAINED EXECUTABLE)
Write-Host "METHOD 1: PUBLISHING WITH DOTNET..." -ForegroundColor Cyan

$OutputPath = "Bin\Synrix.exe"

# CREATE OUTPUT DIRECTORY
New-Item -ItemType Directory -Force -Path "Bin" | Out-Null

# CREATE TEMPORARY CSPROJ FILE
$CsprojContent = @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <PublishSingleFile>true</PublishSingleFile>
    <SelfContained>true</SelfContained>
    <RuntimeIdentifier>win-x64</RuntimeIdentifier>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="Synrix.srx" />
    <Compile Include="Core\ObjectStorage.srx" />
    <Compile Include="Core\RepositoryManager.srx" />
    <Compile Include="Core\StagingArea.srx" />
    <Compile Include="Core\CommitManager.srx" />
    <Compile Include="Core\BranchManager.srx" />
    <Compile Include="Core\MergeManager.srx" />
    <Compile Include="Core\RemoteManager.srx" />
    <Compile Include="Core\ReflogManager.srx" />
    <Compile Include="Core\StashManager.srx" />
    <Compile Include="Core\TagManager.srx" />
    <Compile Include="Core\RebaseManager.srx" />
    <Compile Include="Core\UndoManager.srx" />
    <Compile Include="Utils\FileUtil.srx" />
    <Compile Include="Utils\HashUtil.srx" />
    <Compile Include="Utils\DiffUtil.srx" />
    <Compile Include="Utils\ConfigUtil.srx" />
  </ItemGroup>
</Project>
"@

$CsprojContent | Out-File -FilePath "Temp.csproj" -Encoding UTF8

# COMPILE USING DOTNET PUBLISH
dotnet publish Temp.csproj --output Bin --configuration Release --runtime win-x64 --self-contained true /p:PublishSingleFile=true

# MOVE EXECUTABLE TO CORRECT LOCATION
$PublishedExe = "Bin\Temp.exe"
$TargetExe = "Bin\Synrix.exe"

if (Test-Path $PublishedExe) {
    Move-Item -Path $PublishedExe -Destination $TargetExe -Force
}

# CLEAN UP TEMP FILE
Remove-Item "Temp.csproj" -ErrorAction SilentlyContinue

if ($LASTEXITCODE -eq 0) {
    Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "EXECUTABLE CREATED AT: $OutputPath" -ForegroundColor Green
    Write-Host ""
    
    # DISPLAY FILE INFO
    $FileInfo = Get-Item $OutputPath
    Write-Host "FILE SIZE: $([math]::Round($FileInfo.Length / 1KB, 2)) KB" -ForegroundColor Cyan
    Write-Host ""
    
    # TEST COMMAND
    Write-Host "TESTING SYNRIX..." -ForegroundColor Yellow
    & ".\$OutputPath" --version
    Write-Host ""
    
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "  BUILD COMPLETE!" -ForegroundColor Green
    Write-Host "  RUN: .\Bin\Synrix.exe help" -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
} else {
    Write-Host "BUILD FAILED!" -ForegroundColor Red
    Write-Host "CHECK ERROR MESSAGES ABOVE" -ForegroundColor Red
    exit 1
}

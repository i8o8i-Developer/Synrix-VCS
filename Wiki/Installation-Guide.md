# INSTALLATION GUIDE

This Guide Will Walk You Through Installing SYNRIX On Your System.

---

## 📋 PREREQUISITES

### REQUIRED SOFTWARE

#### .NET 8.0 SDK Or Higher
SYNRIX Is Built On .NET 8.0. You Must Have The SDK Installed.

**Check If You Have .NET:**
```bash
dotnet --version
```

**Install .NET 8.0:**
- **Windows**: [Download .NET SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- **Linux**: Follow [Linux Installation Guide](https://docs.microsoft.com/dotnet/core/install/linux)
- **MacOS**: [Download .NET SDK](https://dotnet.microsoft.com/download/dotnet/8.0)

#### SHELL
- **Windows**: PowerShell 5.1+ Or PowerShell Core 7+
- **Linux/MacOS**: Bash 4.0+

### SYSTEM REQUIREMENTS

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **OS** | Windows 10, Linux (Kernel 4.0+), MacOS 10.15+ | Latest Stable |
| **.NET** | 8.0 | 8.0+ |
| **RAM** | 512 MB | 1 GB+ |
| **Disk Space** | 100 MB | 500 MB+ |
| **CPU** | 1 GHz | 2 GHz+ |

---

## 🚀 INSTALLATION METHODS

### METHOD 1: BUILD FROM SOURCE (RECOMMENDED)

#### STEP 1: CLONE THE REPOSITORY

```bash
# Using Git
git clone https://github.com/i8o8i-Developer/Synrix-VCS.git
cd Synrix-VCS

# Using SYNRIX (If You Already Have It)
synrix clone https://github.com/i8o8i-Developer/Synrix-VCS.git
cd Synrix-VCS
```

#### STEP 2: BUILD THE PROJECT

**On Windows (PowerShell):**
```powershell
.\Build.ps1
```

**On Linux/MacOS (Bash):**
```bash
chmod +x Build.sh
./Build.sh
```

#### STEP 3: VERIFY BUILD

The Build Script Will:
1. Check For .NET Installation
2. Compile The Project
3. Create Executable In `Bin/` Directory
4. Run Test Command

Expected Output:
```
===============================================
  BUILD COMPLETE!
  RUN: .\Bin\Synrix.exe help
===============================================
```

#### STEP 4: ADD TO PATH

**Windows:**
```powershell
# Option 1: Add To User PATH (Recommended)
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Path\To\Synrix-VCS\Bin",
    "User"
)

# Option 2: Add To System PATH (Requires Admin)
# Right-Click "This PC" → Properties → Advanced System Settings
# → Environment Variables → System Variables → Path → Edit
# → Add: C:\Path\To\Synrix-VCS\Bin
```

**Linux/MacOS:**
```bash
# Add To ~/.bashrc Or ~/.zshrc
echo 'export PATH="$PATH:/path/to/Synrix-VCS/Bin"' >> ~/.bashrc
source ~/.bashrc

# Or For Zsh
echo 'export PATH="$PATH:/path/to/Synrix-VCS/Bin"' >> ~/.zshrc
source ~/.zshrc
```

#### STEP 5: VERIFY INSTALLATION

```bash
synrix --version
```

Expected Output:
```
╔══════════════════════════════════════════════════════════════╗
║  SYNRIX VERSION 2.0.0 - PRODUCTION RELEASE                   ║
╚══════════════════════════════════════════════════════════════╝
```

---

### METHOD 2: DOWNLOAD PRE-BUILT BINARY (COMING SOON)

Pre-Built Binaries Will Be Available On The [Releases Page](https://github.com/i8o8i-Developer/Synrix-VCS/releases).

1. Download The Binary For Your Platform
2. Extract The Archive
3. Add To PATH (See Step 4 Above)
4. Verify Installation

---

## 🔧 POST-INSTALLATION SETUP

### CONFIGURE USER INFORMATION

```bash
# Set Your Name (Used In Commits)
synrix config --global user.name "Your Name"

# Set Your Email (Used In Commits)
synrix config --global user.email "your.email@example.com"

# Verify Configuration
synrix config --list
```

### OPTIONAL: SET DEFAULT EDITOR

```bash
# Windows (Notepad)
synrix config --global core.editor "notepad"

# Linux/MacOS (Vim)
synrix config --global core.editor "vim"

# Or Use VS Code
synrix config --global core.editor "code --wait"
```

### OPTIONAL: CONFIGURE ALIASES

```bash
# Create Short Aliases For Common Commands
synrix config --global alias.co "checkout"
synrix config --global alias.br "branch"
synrix config --global alias.ci "commit"
synrix config --global alias.st "status"
```

---

## ✅ VERIFY INSTALLATION

### RUN TEST COMMANDS

```bash
# Check Version
synrix --version

# Check Help
synrix help

# Create Test Repository
mkdir test-repo
cd test-repo
synrix init
synrix status

# Clean Up
cd ..
rm -rf test-repo
```

If All Commands Work, Installation Is Complete! 🎉

---

## 🐛 TROUBLESHOOTING

### COMMAND NOT FOUND

**Problem**: `synrix: command not found`

**Solution**:
1. Verify SYNRIX Is In Your PATH
2. Restart Your Terminal
3. Check The Executable Exists In `Bin/` Directory

**Windows:**
```powershell
$env:Path -split ';' | Select-String "Synrix"
```

**Linux/MacOS:**
```bash
echo $PATH | grep -o "[^:]*Synrix[^:]*"
```

### .NET NOT INSTALLED

**Problem**: `dotnet: command not found`

**Solution**:
1. Install .NET 8.0 SDK From [dotnet.microsoft.com](https://dotnet.microsoft.com/download)
2. Verify Installation: `dotnet --version`
3. Restart Terminal And Try Again

### BUILD FAILED

**Problem**: Build Script Shows Errors

**Solution**:
1. Check .NET Version: `dotnet --version` (Must Be 8.0+)
2. Clean Build Directory:
   ```bash
   rm -rf Bin/
   rm -rf obj/
   ```
3. Run Build Again
4. Check [Issues](https://github.com/i8o8i-Developer/Synrix-VCS/issues) For Known Problems

### PERMISSION DENIED

**Problem**: `Permission denied` When Running Build Script

**Solution**:

**Linux/MacOS:**
```bash
chmod +x Build.sh
./Build.sh
```

**Windows**: Run PowerShell As Administrator

---

## 🔄 UPDATING SYNRIX

### UPDATE FROM SOURCE

```bash
# Navigate To SYNRIX Directory
cd /path/to/Synrix-VCS

# Pull Latest Changes
git pull origin main

# Rebuild
.\Build.ps1         # Windows
./Build.sh          # Linux/MacOS
```

### CHECK FOR UPDATES

```bash
# Check Current Version
synrix --version

# Visit GitHub For Latest Release
# https://github.com/i8o8i-Developer/Synrix-VCS/releases
```

---

## 🗑️ UNINSTALLING SYNRIX

### REMOVE EXECUTABLE

```bash
# Simply Delete The Synrix-VCS Directory
rm -rf /path/to/Synrix-VCS
```

### REMOVE FROM PATH

**Windows:**
- Remove The Path Entry From Environment Variables

**Linux/MacOS:**
```bash
# Remove The Line From ~/.bashrc Or ~/.zshrc
# That Contains: export PATH="$PATH:/path/to/Synrix-VCS/Bin"
```

### REMOVE CONFIGURATION (OPTIONAL)

```bash
# Remove Global Config
rm ~/.synrixconfig

# Remove Repository Data (If You Want To Delete Repositories)
# This Will Delete ALL SYNRIX Repositories!
rm -rf ~/Path/To/Your/Repositories
```

---

## 📞 GET HELP

If You Encounter Issues:

1. **Check [Troubleshooting Guide](Troubleshooting.md)**
2. **Search [GitHub Issues](https://github.com/i8o8i-Developer/Synrix-VCS/issues)**
3. **Ask In [Discussions](https://github.com/i8o8i-Developer/Synrix-VCS/discussions)**
4. **Open A [New Issue](https://github.com/i8o8i-Developer/Synrix-VCS/issues/new)**

---

## ⏭️ NEXT STEPS

Installation Complete! Now What?

1. **[Quick Start Tutorial](Quick-Start-Tutorial.md)** - Create Your First Repository
2. **[Basic Concepts](Basic-Concepts.md)** - Understand SYNRIX Fundamentals
3. **[Command Overview](Command-Overview.md)** - Learn Available Commands

---

<div align="center">

**Ready To Start Using SYNRIX?**

[Quick Start Guide](Quick-Start-Tutorial.md) →

</div>

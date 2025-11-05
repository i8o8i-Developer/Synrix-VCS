# Overview

**SynrixSynchronizedRepositoryIndexingExtension** Is A ModernIndustryGradeVersionControlSystem Designed To Address The Pain Points Of Traditional Vcs Tools Like Git. Built From The Ground Up In C# With .NET 8.0, Synrix Combines The Power Of Distributed Version Control With An IntuitiveUserFriendlyInterface And Emphasizes SafetySimplicityAndSpeed.

## Key Features

### Safety First
- **Complete Reflog Protection** : Every Operation Is Logged And Recoverable
- **Simple Undo/Redo** : `synrix undo` And `synrix redo` Commands
- **Lost Commit Recovery** : Find And Recover Orphaned Commits
- **Confirmation Prompts** : Destructive Operations Require Explicit Confirmation

### Advanced Capabilities
- **Sha256 Content Addressing** : Cryptographically Secure Object Storage
- **Gzip Compression** : Efficient Storage With Up To 70% Space Savings
- **Three Way Merge Algorithm** : Intelligent Conflict Resolution
- **Interactive Rebase** : Full Control Over Commit History
- **Pack File Support** : Optimized Storage For Large Repositories

### Distributed Workflow
- **Local Http Remotes** : Work Offline Or Collaborate Online
- **Smart Push Pull Fetch** : Efficient Network Operations
- **Branch Management** : Lightweight Branches With Full History
- **Tag Support** : Annotated And Lightweight Tags

### Developer Experience
- **Clear Command Names** : No Ambiguous Multi Purpose Commands
- **Colorized Output** : Visual Feedback For All Operations
- **Detailed Status** : Know Exactly What's Happening In Your Repository
- **Comprehensive Help** : BuiltIn Documentation For Every Command

## Design Philosophy

Synrix Operates On One Core Principle: **"Do What You Mean Not What You Say"**

We Believe Version Control Should Be:
- ✅ **Intuitive** - Commands That Make Sense
- ✅ **Safe** - Data Protection By Default
- ✅ **Powerful** - Advanced Features When You Need Them
- ✅ **Fast** - Optimized For Performance

## Why Choose Synrix Over Git

### Intuitive Commands
Unlike Git's Confusing MultiPurpose Commands (E.g., `git checkout` Does Three Different Things), Synrix Uses Clear Purpose Built Commands:
- `synrix switch <branch>` - Obviously Switches Branches
- `synrix restore <file>` - Obviously Restores A File
- `synrix undo` - Obviously Undoes Last Action

### Safety By Default
Git Makes It Easy To Lose Data Permanently. Synrix Protects Data With:
- Confirmation Prompts For Destructive Operations
- Complete Operation Logging Via Reflog
- Simple Recovery Mechanisms

### Better Conflict Handling
Synrix Provides Clear Conflict Resolution With Commands Like `synrix conflicts` To List Conflicts With Line Numbers And `synrix resolve <file>` To Mark Files As Resolved.

## Technical Details

- **Language** : C# With .NET 8.0
- **PlatformSupport** : Windows , Linux , Macos
- **Architecture** : Clean Separation Of Concerns With Manager Pattern
- **Storage** : Sha256 Content Addressing With Gzip Compression
- **License** : Mit License

## Installation

### Prerequisites
- .NET 8.0 SDK Or Higher
- WindowsLinuxOrMacos

### DownloadPreBuiltPackage
If You Prefer Not To Build From Source, You Can Download The PreBuilt .ZIP Package Created By The `BuildAndRelease.yml` Workflow:

1. Visit The [Releases Page](https://github.com/i8o8i-Developer/Synrix-VCS/releases) On GitHub.
2. Download The Latest Release ZIP File (E.g., `SynrixVcsV2.0.0.Zip`).
3. Extract The Contents Of The ZIP File To A Directory Of Your Choice (E.G., `C:\Synrix` On Windows Or `/Usr/Local/Synrix` On Linux/MacOS).
4. Add The Extracted Directory To Your System PATH:
   - **Windows**: Edit Environment Variables And Add The Path To The `Path` Variable.
   - **Linux/MacOS**: Add `Export PATH="$PATH:/Path/To/Synrix"` To Your `~/.Bashrc` Or `~/.Zshrc` File, Then Run `Source ~/.Bashrc`.

### BuildFromSource
If You Want To Build From Source Instead:
```bash
# CloneTheRepository
git clone https://github.com/i8o8i-Developer/Synrix-VCS.git
cd Synrix-VCS

# BuildTheProject
.\Build.ps1                   # Windows PowerShell
./Build.sh                    # Linux/MacOS Bash

# AddToPath
# Windows: Add Bin\ Directory To System Path
# Linux/MacOS: Add Bin/ Directory To ~/.bashrc Or ~/.zshrc
```

### VerifyInstallation
```bash
synrix --version
# Output: SYNRIX VERSION 2.0.0 - PRODUCTION RELEASE
```

## QuickStart

```bash
# InitializeANewRepository
mkdir MyProject
cd MyProject
synrix init

# ConfigureUserInformation
synrix config user.name "Your Name"
synrix config user.email "your.email@example.com"

# BasicWorkflow
echo "Hello Synrix" > README.md
synrix add README.md
synrix commit -m "Initial commit"
synrix log
```

## Contributing

We Welcome Contributions! Please See The [Contributing Guidelines](https://github.com/i8o8i-Developer/Synrix-VCS/blob/main/CONTRIBUTING.md) For Details.

## Links

- **GithubRepository**: https://github.com/i8o8i-Developer/Synrix-VCS
- **Issues**: https://github.com/i8o8i-Developer/Synrix-VCS/issues
- **Discussions**: https://github.com/i8o8i-Developer/Synrix-VCS/discussions

---

**MadeWith ❤️ By The Synrix Community**
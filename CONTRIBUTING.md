# CONTRIBUTING TO SYNRIX

First Off, Thank You For Considering Contributing To SYNRIX! It's People Like You That Make SYNRIX Such A Great Tool.

Following These Guidelines Helps To Communicate That You Respect The Time Of The Developers Managing And Developing This Open Source Project. In Return, They Should Reciprocate That Respect In Addressing Your Issue, Assessing Changes, And Helping You Finalize Your Pull Requests.

---

## CODE OF CONDUCT

This Project And Everyone Participating In It Is Governed By The [SYNRIX Code Of Conduct](CODE_OF_CONDUCT.md). By Participating, You Are Expected To Uphold This Code. Please Report Unacceptable Behavior To [i8o8i.workstation@outlook.com](mailto:i8o8i.workstation@outlook.com).

---

## WHAT WE'RE LOOKING FOR

SYNRIX Is An Open Source Project And We Love To Receive Contributions From Our Community! There Are Many Ways To Contribute:

### 🐛 BUG REPORTS
- Found A Bug? Report It!
- Check If The Bug Has Already Been Reported
- Include Steps To Reproduce The Issue
- Include Expected Vs Actual Behavior
- Include System Information (OS, .NET Version, Etc.)

### ✨ FEATURE REQUESTS
- Have An Idea For A New Feature? Share It!
- Explain Why This Feature Would Be Useful
- Provide Examples Of How It Would Work
- Consider Whether It Fits SYNRIX's Design Philosophy

### 📝 DOCUMENTATION
- Improve Existing Documentation
- Write Tutorials Or How-To Guides
- Create Examples And Code Snippets
- Fix Typos Or Clarify Confusing Sections

### 💻 CODE CONTRIBUTIONS
- Implement New Features
- Fix Bugs
- Improve Performance
- Refactor Code For Better Maintainability

---

## HOW TO CONTRIBUTE

### REPORTING BUGS

Before Creating Bug Reports, Please Check The [Issue List](https://github.com/i8o8i-Developer/Synrix-VCS/issues) As You Might Find Out That You Don't Need To Create One. When You Are Creating A Bug Report, Please Include As Many Details As Possible:

#### BUG REPORT TEMPLATE

```markdown
**Description**
A Clear And Concise Description Of What The Bug Is.

**To Reproduce**
Steps To Reproduce The Behavior:
1. Run Command '...'
2. Perform Action '...'
3. See Error

**Expected Behavior**
A Clear And Concise Description Of What You Expected To Happen.

**Actual Behavior**
What Actually Happened.

**Screenshots**
If Applicable, Add Screenshots To Help Explain Your Problem.

**Environment**
- OS: [e.g. Windows 11, Ubuntu 22.04]
- .NET Version: [e.g. 8.0.0]
- SYNRIX Version: [e.g. 2.0.0]

**Additional Context**
Add Any Other Context About The Problem Here.
```

### SUGGESTING ENHANCEMENTS

Enhancement Suggestions Are Tracked As GitHub Issues. When Creating An Enhancement Suggestion, Please Include:

#### FEATURE REQUEST TEMPLATE

```markdown
**Is Your Feature Request Related To A Problem?**
A Clear And Concise Description Of What The Problem Is.

**Describe The Solution You'd Like**
A Clear And Concise Description Of What You Want To Happen.

**Describe Alternatives You've Considered**
A Clear And Concise Description Of Any Alternative Solutions Or Features You've Considered.

**Additional Context**
Add Any Other Context Or Screenshots About The Feature Request Here.

**Would You Like To Implement This?**
Let Us Know If You're Interested In Implementing This Feature Yourself.
```

---

## DEVELOPMENT SETUP

### PREREQUISITES

- .NET 8.0 SDK Or Higher
- Git For Version Control
- A Code Editor (Visual Studio, VS Code, Rider, Etc.)
- Basic Knowledge Of C# And Version Control Concepts

### SETTING UP YOUR DEVELOPMENT ENVIRONMENT

1. **Fork The Repository**
   ```bash
   # Click "Fork" On GitHub, Then Clone Your Fork
   git clone https://github.com/YOUR-USERNAME/Synrix-VCS.git
   cd Synrix-VCS
   ```

2. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/i8o8i-Developer/Synrix-VCS.git
   ```

3. **Build The Project**
   ```bash
   # Windows
   .\Build.ps1
   
   # Linux/MacOS
   ./Build.sh
   ```

4. **Run Tests** (When Available)
   ```bash
   dotnet test
   ```

5. **Create A Branch**
   ```bash
   git checkout -b feature/YourFeatureName
   ```

---

## CODING STANDARDS

### C# STYLE GUIDE

SYNRIX Follows Standard C# Coding Conventions With Some Project-Specific Guidelines:

#### NAMING CONVENTIONS
- **PascalCase** For Classes, Methods, Properties, Public Fields
  ```csharp
  public class RepositoryManager
  public void CreateCommit()
  public string CommitHash { get; set; }
  ```

- **camelCase** For Local Variables And Private Fields
  ```csharp
  private string repositoryPath;
  var commitMessage = "Initial Commit";
  ```

- **_camelCase** For Private Fields (Underscore Prefix)
  ```csharp
  private readonly ObjectStorage _storage;
  private BranchManager _branchManager;
  ```

- **UPPERCASE** For Constants
  ```csharp
  private const int MAX_COMMIT_SIZE = 1024;
  ```

#### CODE ORGANIZATION
- One Class Per File
- Group Related Methods Together
- Keep Methods Short And Focused (< 50 Lines Ideally)
- Add XML Documentation Comments For Public APIs

#### EXAMPLE
```csharp
/// <summary>
/// Manages Repository Operations And Metadata.
/// </summary>
public class RepositoryManager
{
    private readonly string _repositoryPath;
    private readonly ObjectStorage _storage;

    /// <summary>
    /// Initializes A New Instance Of The RepositoryManager Class.
    /// </summary>
    /// <param name="repositoryPath">The Path To The Repository.</param>
    public RepositoryManager(string repositoryPath)
    {
        _repositoryPath = repositoryPath ?? throw new ArgumentNullException(nameof(repositoryPath));
        _storage = new ObjectStorage(repositoryPath);
    }

    /// <summary>
    /// Creates A New Commit With The Specified Message.
    /// </summary>
    /// <param name="message">The Commit Message.</param>
    /// <returns>The Commit Hash.</returns>
    public string CreateCommit(string message)
    {
        // Implementation
    }
}
```

### FILE NAMING
- Use **PascalCase** For All File Names
- Core Managers: `RepositoryManager.srx`
- Utilities: `FileUtil.srx`, `DiffUtil.srx`
- Documentation: `README.md`, `CONTRIBUTING.md`

---

## COMMIT MESSAGE GUIDELINES

### COMMIT MESSAGE FORMAT

```
<Type>: <Subject>

<Body>

<Footer>
```

### TYPES
- **Feature**: A New Feature
- **Fix**: A Bug Fix
- **Docs**: Documentation Changes
- **Style**: Code Style Changes (Formatting, Missing Semicolons, Etc.)
- **Refactor**: Code Refactoring
- **Test**: Adding Or Updating Tests
- **Chore**: Maintenance Tasks

### EXAMPLES

```
Feature: Add Interactive Rebase Support

Implemented Interactive Rebase Functionality Allowing Users To
Reorder, Squash, And Edit Commits In Their History.

Closes #42
```

```
Fix: Resolve Merge Conflict Detection Issue

Fixed Bug Where Merge Conflicts Were Not Being Properly Detected
In Binary Files.

Fixes #127
```

---

## PULL REQUEST PROCESS

### BEFORE SUBMITTING

1. ✅ Ensure Your Code Follows The Coding Standards
2. ✅ Update Documentation If You Changed APIs
3. ✅ Add Tests For New Features
4. ✅ Ensure All Tests Pass
5. ✅ Update CHANGELOG.md If Applicable
6. ✅ Sync With Upstream Main Branch

### PULL REQUEST TEMPLATE

```markdown
## Description
Brief Description Of What This PR Does.

## Type Of Change
- [ ] Bug Fix
- [ ] New Feature
- [ ] Documentation Update
- [ ] Code Refactoring
- [ ] Performance Improvement

## How Has This Been Tested?
Describe The Tests You Ran And How To Reproduce Them.

## Checklist
- [ ] My Code Follows The Project's Style Guidelines
- [ ] I Have Performed A Self-Review Of My Code
- [ ] I Have Commented My Code, Particularly In Hard-To-Understand Areas
- [ ] I Have Made Corresponding Changes To The Documentation
- [ ] My Changes Generate No New Warnings
- [ ] I Have Added Tests That Prove My Fix/Feature Works
- [ ] New And Existing Tests Pass Locally

## Related Issues
Closes #(Issue Number)
```

### REVIEW PROCESS

1. A Maintainer Will Review Your PR Within 7 Days
2. Address Any Requested Changes
3. Once Approved, Your PR Will Be Merged
4. Your Contribution Will Be Included In The Next Release

---

## COMMUNITY

### GET INVOLVED

- **GitHub Discussions**: Ask Questions, Share Ideas
- **Issue Tracker**: Report Bugs, Request Features
- **Wiki**: Read And Contribute To Documentation

### RECOGNITION

Contributors Will Be:
- Added To The CONTRIBUTORS.md File
- Mentioned In Release Notes
- Given Credit In Documentation

---

## QUESTIONS?

If You Have Questions, Feel Free To:
- Open An Issue With The "Question" Label
- Start A Discussion On GitHub Discussions
- Email The Maintainer At i8o8i.workstation@gmail.com

---

<div align="center">

**Thank You For Contributing To SYNRIX! 🚀**

*Every Contribution, Big Or Small, Makes A Difference!*

</div>

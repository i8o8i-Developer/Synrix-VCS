using System.Diagnostics;
using System.Reflection;
using System.Runtime.InteropServices;

namespace Synrix.Installer;

internal sealed record InstallerOptions(string InstallDirectory, bool NoPath, bool Force, bool ShowHelp);

internal static class Program
{
    private const string PayloadResourceName = "Synrix.Payload.synrix.exe";
    private const string InstalledExecutableName = "synrix.exe";
    private const uint WmSettingChange = 0x001A;
    private const uint SmtoAbortIfHung = 0x0002;
    private static readonly IntPtr HwndBroadcast = new(0xffff);

    private static int Main(string[] args)
    {
        try
        {
            var options = ParseArguments(args);
            if (options.ShowHelp)
            {
                ShowUsage();
                return 0;
            }

            var installDirectory = string.IsNullOrWhiteSpace(options.InstallDirectory)
                ? GetDefaultInstallDirectory()
                : Path.GetFullPath(options.InstallDirectory);

            var targetExecutable = Path.Combine(installDirectory, InstalledExecutableName);

            Console.WriteLine("SYNRIX INSTALLER");
            Console.WriteLine($"TARGET DIRECTORY: {installDirectory}");

            Directory.CreateDirectory(installDirectory);
            InstallPayload(targetExecutable, options.Force);

            if (!options.NoPath)
            {
                EnsureUserPathContains(installDirectory);
                EnsureCurrentProcessPathContains(installDirectory);
                BroadcastEnvironmentChange();
            }

            var versionOutput = RunAndCapture(targetExecutable, "--version");

            Console.WriteLine();
            Console.WriteLine(versionOutput.Trim());
            Console.WriteLine();
            Console.WriteLine("INSTALLATION COMPLETE");
            Console.WriteLine($"INSTALLED EXECUTABLE: {targetExecutable}");

            ReportConflictingInstalls(targetExecutable);

            if (!options.NoPath)
            {
                Console.WriteLine("NEW TERMINALS CAN RUN: synrix --version");
                Console.WriteLine("CLOSE AND REOPEN ANY TERMINALS THAT WERE OPEN BEFORE THIS INSTALL.");
            }

            return 0;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"INSTALL FAILED: {ex.Message}");
            return 1;
        }
    }

    private static InstallerOptions ParseArguments(IReadOnlyList<string> args)
    {
        var installDirectory = string.Empty;
        var noPath = false;
        var force = false;
        var showHelp = false;

        for (var index = 0; index < args.Count; index++)
        {
            var arg = args[index];

            switch (arg.ToLowerInvariant())
            {
                case "--install-dir":
                    if (index + 1 >= args.Count)
                    {
                        throw new ArgumentException("--install-dir REQUIRES A VALUE");
                    }

                    installDirectory = args[++index];
                    break;

                case "--no-path":
                    noPath = true;
                    break;

                case "--force":
                    force = true;
                    break;

                case "--help":
                case "-h":
                case "/?":
                    showHelp = true;
                    break;

                default:
                    throw new ArgumentException($"UNKNOWN ARGUMENT: {arg}");
            }
        }

        return new InstallerOptions(installDirectory, noPath, force, showHelp);
    }

    private static void ShowUsage()
    {
        Console.WriteLine("SYNRIX INSTALLER");
        Console.WriteLine();
        Console.WriteLine("USAGE:");
        Console.WriteLine("  SynrixInstaller.exe [--install-dir <path>] [--no-path] [--force]");
        Console.WriteLine();
        Console.WriteLine("OPTIONS:");
        Console.WriteLine("  --install-dir <path>  INSTALL TO A CUSTOM DIRECTORY");
        Console.WriteLine("  --no-path             SKIP ADDING THE INSTALL DIRECTORY TO USER PATH");
        Console.WriteLine("  --force               OVERWRITE AN EXISTING INSTALLATION");
        Console.WriteLine("  --help                SHOW THIS HELP MESSAGE");
    }

    private static string GetDefaultInstallDirectory()
    {
        return Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "Programs",
            "Synrix");
    }

    private static void InstallPayload(string targetExecutable, bool force)
    {
        if (File.Exists(targetExecutable) && !force)
        {
            throw new InvalidOperationException($"{targetExecutable} ALREADY EXISTS. RUN THE INSTALLER AGAIN WITH --force TO OVERWRITE IT");
        }

        if (File.Exists(targetExecutable))
        {
            File.SetAttributes(targetExecutable, FileAttributes.Normal);
        }

        var tempPath = Path.Combine(Path.GetDirectoryName(targetExecutable)!, $"{InstalledExecutableName}.{Guid.NewGuid():N}.tmp");

        using (var payloadStream = OpenPayloadStream())
        using (var outputStream = File.Create(tempPath))
        {
            payloadStream.CopyTo(outputStream);
        }

        File.Move(tempPath, targetExecutable, true);
    }

    private static Stream OpenPayloadStream()
    {
        var assembly = Assembly.GetExecutingAssembly();
        var stream = assembly.GetManifestResourceStream(PayloadResourceName);

        if (stream == null)
        {
            var availableResources = string.Join(", ", assembly.GetManifestResourceNames());
            throw new InvalidOperationException($"EMBEDDED PAYLOAD NOT FOUND. AVAILABLE RESOURCES: {availableResources}");
        }

        return stream;
    }

    private static void EnsureUserPathContains(string installDirectory)
    {
        var currentUserPath = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.User) ?? string.Empty;
        var pathEntries = SplitPathEntries(currentUserPath);
        MovePathToFront(pathEntries, installDirectory);
        Environment.SetEnvironmentVariable(
            "Path",
            string.Join(Path.PathSeparator, pathEntries),
            EnvironmentVariableTarget.User);

        Console.WriteLine("USER PATH: UPDATED WITH INSTALL DIRECTORY FIRST");
    }

    private static void EnsureCurrentProcessPathContains(string installDirectory)
    {
        var currentProcessPath = Environment.GetEnvironmentVariable("Path") ?? string.Empty;
        var pathEntries = SplitPathEntries(currentProcessPath);
        MovePathToFront(pathEntries, installDirectory);
        Environment.SetEnvironmentVariable("Path", string.Join(Path.PathSeparator, pathEntries));
    }

    private static List<string> SplitPathEntries(string pathValue)
    {
        var results = new List<string>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var entry in pathValue.Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
        {
            var normalized = NormalizePath(entry);
            if (string.IsNullOrWhiteSpace(normalized) || !seen.Add(normalized))
            {
                continue;
            }

            results.Add(entry.Trim());
        }

        return results;
    }

    private static bool ContainsPath(IEnumerable<string> pathEntries, string candidate)
    {
        var normalizedCandidate = NormalizePath(candidate);
        return pathEntries.Any(entry => string.Equals(NormalizePath(entry), normalizedCandidate, StringComparison.OrdinalIgnoreCase));
    }

    private static void ReportConflictingInstalls(string targetExecutable)
    {
        var conflicts = FindSynrixExecutablesOnPath(targetExecutable);
        if (conflicts.Count == 0)
        {
            return;
        }

        Console.WriteLine();
        Console.WriteLine("WARNING: OTHER SYNRIX EXECUTABLES ARE ALSO AVAILABLE ON PATH:");

        foreach (var conflict in conflicts)
        {
            Console.WriteLine($"  {conflict.Path} (FILE VERSION {conflict.Version})");
        }

        Console.WriteLine("EXISTING SHELLS MAY STILL RESOLVE TO AN OLDER COPY UNTIL THEY ARE RESTARTED.");
        Console.WriteLine("VERIFY ACTIVE RESOLUTION WITH: Get-Command synrix -All");
    }

    private static List<(string Path, string Version)> FindSynrixExecutablesOnPath(string targetExecutable)
    {
        var results = new List<(string Path, string Version)>();
        var normalizedTarget = NormalizePath(targetExecutable);

        foreach (var entry in SplitPathEntries(Environment.GetEnvironmentVariable("Path") ?? string.Empty))
        {
            var candidate = Path.Combine(entry, InstalledExecutableName);
            if (!File.Exists(candidate))
            {
                continue;
            }

            var normalizedCandidate = NormalizePath(candidate);
            if (string.Equals(normalizedCandidate, normalizedTarget, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            results.Add((candidate, GetFileVersion(candidate)));
        }

        return results;
    }

    private static string GetFileVersion(string executablePath)
    {
        try
        {
            return FileVersionInfo.GetVersionInfo(executablePath).FileVersion ?? "UNKNOWN";
        }
        catch
        {
            return "UNKNOWN";
        }
    }

    private static void MovePathToFront(List<string> pathEntries, string installDirectory)
    {
        var normalizedInstallDirectory = NormalizePath(installDirectory);
        pathEntries.RemoveAll(entry => string.Equals(NormalizePath(entry), normalizedInstallDirectory, StringComparison.OrdinalIgnoreCase));
        pathEntries.Insert(0, installDirectory);
    }

    private static string NormalizePath(string path)
    {
        if (string.IsNullOrWhiteSpace(path))
        {
            return string.Empty;
        }

        try
        {
            return Path.GetFullPath(path).TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        }
        catch
        {
            return path.Trim().TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        }
    }

    private static string RunAndCapture(string executablePath, string arguments)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = executablePath,
            Arguments = arguments,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(startInfo)
            ?? throw new InvalidOperationException("FAILED TO START THE INSTALLED SYNRIX EXECUTABLE");

        if (!process.WaitForExit(15000))
        {
            process.Kill(true);
            throw new TimeoutException("TIMED OUT WHILE VERIFYING THE INSTALLED SYNRIX EXECUTABLE");
        }

        var standardOutput = process.StandardOutput.ReadToEnd();
        var standardError = process.StandardError.ReadToEnd();

        if (process.ExitCode != 0)
        {
            throw new InvalidOperationException($"POST-INSTALL VERIFICATION FAILED: {standardError.Trim()}");
        }

        return string.IsNullOrWhiteSpace(standardOutput) ? standardError : standardOutput;
    }

    private static void BroadcastEnvironmentChange()
    {
        try
        {
            SendMessageTimeout(
                HwndBroadcast,
                WmSettingChange,
                IntPtr.Zero,
                "Environment",
                SmtoAbortIfHung,
                1000,
                out _);
        }
        catch
        {
        }
    }

    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern IntPtr SendMessageTimeout(
        IntPtr hWnd,
        uint msg,
        IntPtr wParam,
        string lParam,
        uint flags,
        uint timeout,
        out IntPtr result);
}

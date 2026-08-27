# Windows Symlink Automator for 3-Layer Dotfiles Architecture
# Links common, OS-specific, and host-specific dotfiles to $HOME

[CmdletBinding()]
param(
    [string]$DotfilesDir = "$PSScriptRoot\..",
    [switch]$Force
)

$DotfilesDir = (Resolve-Path $DotfilesDir).Path
Write-Host "[INFO] Dotfiles Repository: $DotfilesDir" -ForegroundColor Cyan

function Create-DotfileSymlink {
    param(
        [string]$Source,
        [string]$Target
    )

    if (-not (Test-Path $Source)) {
        Write-Warning "Source path does not exist: $Source"
        return
    }

    $targetDir = Split-Path $Target -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    if (Test-Path $Target) {
        if ($Force) {
            Remove-Item -Path $Target -Force -Recurse
        } else {
            Write-Host "[SKIP] $Target already exists (use -Force to overwrite)" -ForegroundColor Yellow
            return
        }
    }

    $itemType = if (Test-Path $Source -PathType Container) { "SymbolicLink" } else { "SymbolicLink" }
    New-Item -ItemType $itemType -Path $Target -Target $Source -Force | Out-Null
    Write-Host "[LINKED] $Target -> $Source" -ForegroundColor Green
}

# 1. Layer 1 (Common)
Write-Host "`n--- Layer 1: Common Dotfiles ---" -ForegroundColor Magentam
Create-DotfileSymlink -Source "$DotfilesDir\common\.gitconfig" -Target "$HOME\.gitconfig"
Create-DotfileSymlink -Source "$DotfilesDir\common\.ideavimrc" -Target "$HOME\.ideavimrc"
Create-DotfileSymlink -Source "$DotfilesDir\common\.tmux.conf" -Target "$HOME\.tmux.conf"
Create-DotfileSymlink -Source "$DotfilesDir\common\nvim\vscode.lua" -Target "$HOME\.config\nvim\vscode.lua"

# 2. Layer 2 (Windows OS)
Write-Host "`n--- Layer 2: Windows OS ---" -ForegroundColor Magenta
$psProfileDir = Split-Path $PROFILE -Parent
Create-DotfileSymlink -Source "$DotfilesDir\os\windows\Microsoft.PowerShell_profile.ps1" -Target "$psProfileDir\Microsoft.PowerShell_profile.ps1"

# 3. Layer 3 (Host Overrides)
$hostname = $env:COMPUTERNAME
$hostDir = "$DotfilesDir\hosts\$hostname"
if (Test-Path $hostDir) {
    Write-Host "`n--- Layer 3: Host Overrides ($hostname) ---" -ForegroundColor Magenta
    if (Test-Path "$hostDir\terminal-settings.json") {
        $wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Create-DotfileSymlink -Source "$hostDir\terminal-settings.json" -Target $wtSettings
    }
} else {
    Write-Host "`n[NOTE] No host-specific directory found for '$hostname' under hosts/" -ForegroundColor Gray
}

Write-Host "`n[SUCCESS] Symlink installation complete!" -ForegroundColor Green

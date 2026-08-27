# Set backup directories
$backupRootDir = "backups"
$backupDir = Join-Path $backupRootDir $env:COMPUTERNAME

Write-Host "[START] Windows backup for host '$env:COMPUTERNAME'"
Write-Host "[INFO ] Backup root: $backupRootDir"
Write-Host "[INFO ] Host backup directory: $backupDir"

# Create the backup directory for this host if it doesn't exist
Write-Host "[STEP ] Ensuring host backup directory exists..."
if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
    Write-Host "[DONE ] Created directory: $backupDir"
}
else {
    Write-Host "[DONE ] Directory already exists: $backupDir"
}

# Write backup run log for this host
$backupReadmePath = Join-Path $backupDir "README.md"
Write-Host "[STEP ] Updating backup run log..."
if (!(Test-Path $backupReadmePath)) {
    Write-Host "[INFO ] Creating backup log file: $backupReadmePath"
    Set-Content -Path $backupReadmePath -Value "# Backup Log for $env:COMPUTERNAME"
    Add-Content -Path $backupReadmePath -Value ""
}

$backupTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$backupLogLine = "- Backup completed at $backupTimestamp"
Add-Content -Path $backupReadmePath -Value $backupLogLine
Write-Host "[DONE ] Backup run logged in $backupReadmePath"

# Backup Chocolatey packages
$chocoExportPath = Join-Path $backupDir "$env:COMPUTERNAME.packages.config"
Write-Host "[STEP ] Backing up Chocolatey packages..."
Write-Host "[INFO ] Target: $chocoExportPath"
# TODO: Remove or ignore *.backup files during backup runs to prevent committing duplicate .backup files
choco export $chocoExportPath
Write-Host "[DONE ] Chocolatey package export complete"
# choco list --local-only > "$backupDir\choco-packages.txt"

# Backup PowerShell profile
# Test if the profile exists before copying
Write-Host "[STEP ] Backing up PowerShell profile..."
if (Test-Path $PROFILE) {
    Write-Host "[INFO ] Source: $PROFILE"
    Write-Host "[INFO ] Target directory: $backupDir"
    Copy-Item $PROFILE $backupDir
    Write-Host "[DONE ] PowerShell profile backup complete"
}
else {
    Write-Host "[WARN ] PowerShell profile not found at $PROFILE"
}

# Backup Neovim configuration
$neovimSourcePath = "$env:LOCALAPPDATA\nvim"
$neovimBackupPath = Join-Path $backupDir "nvim"
Write-Host "[STEP ] Backing up Neovim configuration..."
Write-Host "[INFO ] Source: $neovimSourcePath"
Write-Host "[INFO ] Target: $neovimBackupPath"
if (!(Test-Path $neovimBackupPath)) {
    New-Item -ItemType Directory -Path $neovimBackupPath | Out-Null
    Write-Host "[DONE ] Created directory: $neovimBackupPath"
}

Copy-Item (Join-Path $neovimSourcePath "*") $neovimBackupPath -Recurse -Force
Write-Host "[DONE ] Neovim backup complete"

# Backup NPM global packages
$npmBackupPath = Join-Path $backupDir "npm-packages.txt"
Write-Host "[STEP ] Backing up npm global packages..."
Write-Host "[INFO ] Target: $npmBackupPath"
npm list -g --depth=0 > $npmBackupPath
Write-Host "[DONE ] npm package list backup complete"

# Terminal settings (Windows Terminal)
$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Write-Host "[STEP ] Backing up Windows Terminal settings..."
if (Test-Path $terminalSettingsPath) {
    $terminalBackupDir = Join-Path $backupDir "Terminal"
    Write-Host "[INFO ] Source: $terminalSettingsPath"
    Write-Host "[INFO ] Target directory: $terminalBackupDir"
    if (!(Test-Path $terminalBackupDir)) {
        New-Item -ItemType Directory -Path $terminalBackupDir | Out-Null
        Write-Host "[DONE ] Created directory: $terminalBackupDir"
    }
    else {
        Write-Host "[DONE ] Directory already exists: $terminalBackupDir"
    }

    $terminalBackupPath = Join-Path $terminalBackupDir "settings.json"
    Copy-Item $terminalSettingsPath $terminalBackupPath
    Write-Host "[DONE ] Windows Terminal settings backup complete"
}
else {
    Write-Host "[WARN ] Windows Terminal settings not found at $terminalSettingsPath"
}

Write-Host "[DONE ] Windows backup complete for host '$env:COMPUTERNAME'"
# Set the backup directory
$backupDir = "backups"

# Create the backup directory if it doesn't exist
if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# Backup Chocolatey packages
choco export $backupDir\"$env:COMPUTERNAME.packages.config"
# choco list --local-only > "$backupDir\choco-packages.txt"

# Backup PowerShell profile
Copy-Item $PROFILE $backupDir

# Backup Neovim configuration
Copy-Item "$env:LOCALAPPDATA\nvim" "$backupDir\nvim" -Recurse

# Backup NPM global packages
npm list -g --depth=0 > "$backupDir\npm-packages.txt"

# Terminal settings (Windows Terminal)
$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $terminalSettingsPath) {
    Copy-Item $terminalSettingsPath "$backupDir\terminal-settings.json"
}
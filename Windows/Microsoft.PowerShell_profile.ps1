function Watch-Command {
  param (
    [string]$Command,
    [int]$Interval = 2,
    [switch]$Clear = $false
  )

  while ($true) {
    if ($Clear) {
      Clear-Host
    }
    Get-Date
    "Command: $Command"
    "Interval: $Interval"
    "Clear: $Clear"
    Invoke-Expression $Command
    Start-Sleep -Seconds $Interval
  }
}

Set-Alias -Name watch -Value Watch-Command

Import-Module git-aliases -DisableNameChecking

fnm env --use-on-cd | Out-String | Invoke-Expression
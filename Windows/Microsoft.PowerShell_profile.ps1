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
Set-Alias -Name w -Value Watch-Command

Import-Module git-aliases -DisableNameChecking

# Custom Aliases
function gst {
	git status $args
}

fnm env --use-on-cd | Out-String | Invoke-Expression

# IPFS Kubo
[System.Environment]::SetEnvironmentVariable('PATH',$Env:PATH+';;C:\Program Files\kubo_v0.24.0\kubo')

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
# Remove CoPilot from Windows 11
# 2024-07-07
# Requires admin rights.
reg add HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f 
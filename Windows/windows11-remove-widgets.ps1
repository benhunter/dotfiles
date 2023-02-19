# Windows 11 Widgets are the extremely annoying sidebar that shows when you swipe from the left or Win+W.
# 2023-02-19
# Remove widgets feature:
Get-AppxPackage *WebExperience* | Remove-AppxPackage

# Remove Cortana from Windows 10
# Run as Administrator.
#
# https://www.pocket-lint.com/laptops/news/microsoft/162303-how-to-disable-cortana-in-windows/

Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
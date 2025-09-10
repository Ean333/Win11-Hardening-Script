# Define menu options
$menuOptions = @(
    "Document the system"
    # Define functions for each option
function Document-System {
    Write-Host "`n--- Starting: Document the system ---`n"
}
    "Enable updates"
    function Enable-Updates {
    Write-Host "`n--- Starting: Enable updates ---`n"
}
    "User Auditing"
    function User-Auditing {
    Write-Host "`n--- Starting: User Auditing ---`n"
}
    "Exit"
)
# Menu loop
:menu do {
    Write-Host "`nSelect an option:`n"
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "`nEnter the number of your choice"

    switch ($selection) {
        "1" { Document-System }
        "2" { Enable-Updates }
        "3" { User-Auditing }
        "4" { Write-Host "`nExiting..."; break menu }  # leave the do{} loop
        default { Write-Host "`nInvalid selection. Please try again." }
    }
} while ($true)
# Display the computer's hostname
Write-Host "Computer Name: $env:COMPUTERNAME"
# Display the Windows version
Write-Host "Windows Version:"
Get-ComputerInfo | Select-Object -Property WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer

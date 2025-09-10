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
    # Enumerate all local user accounts
$localUsers = Get-LocalUser

foreach ($user in $localUsers) {
    # Skip built-in accounts (like Administrator, Guest, etc.)
    if ($user.Name -in @('Administrator', 'Guest', 'DefaultAccount', 'WDAGUtilityAccount')) {
        continue
    }
    $prompt = "Is '$($user.Name)' an Authorized User? [Y/n]: "
    $answer = Read-Host $prompt
    if ($answer -eq '' -or $answer -match '^[Yy]$') {
        Write-Host "'$($user.Name)' kept."
    } elseif ($answer -match '^[Nn]$') {
        Write-Host "Deleting user '$($user.Name)'..."
        Remove-LocalUser -Name $user.Name
    } else {
        Write-Host "Invalid input. '$($user.Name)' kept."
    }
}
    # Check for Administrator privileges and relaunch as Admin if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script is not running as Administrator. Restarting with elevated privileges..."
    $script = $MyInvocation.MyCommand.Definition
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$script`"" -Verb RunAs
    exit
}
# Get all members of the local Administrators group
$adminGroup = [ADSI]"WinNT://$env:COMPUTERNAME/Administrators,group"
$members = @($adminGroup.psbase.Invoke("Members"))

foreach ($member in $members) {
    $memberObj = $member.GetType().InvokeMember("Name", 'GetProperty', $null, $member, $null)
    $prompt = "Is '$memberObj' an Authorized Administrator? [Y/n]: "
    $answer = Read-Host $prompt
    if ($answer -eq '' -or $answer -match '^[Yy]$') {
        Write-Host "'$memberObj' kept in Administrators group."
    } elseif ($answer -match '^[Nn]$') {
        Write-Host "Removing '$memberObj' from Administrators group..."
        $adminGroup.Remove("WinNT://$env:COMPUTERNAME/$memberObj")
    } else {
        Write-Host "Invalid input. '$memberObj' kept in Administrators group."
    }
}
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

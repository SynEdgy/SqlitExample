# SQLitExample

A simple example of using synedgy.PSSqlite with a PowerShell module.

## Installation

```powershell

Install-Module -Name synedgy.PSSqlite -Repository PSGallery -AllowPrerelease -Force
```

## Usage

```powershell
Import-Module .\myModule.psd1 -Force
Initialize-myModuleDB -Force -Debug -Verbose

# Add a car
New-Car -Make "Toyota" -Model "Corolla" -Colour "Blue" -Year 2020
# Get all cars
Get-Car
# Get a specific car
Get-Car -Make "Toyota" -Model "Corolla"
# Update a car
Set-Car -Make "Toyota" -Model "Corolla" -Colour "Red"

$carToUpdate = Get-Car -Make "Toyota" -Model "Corolla"
$cartToUpdate.id.Foreach{
    Set-Car -Id $_ -Colour "Green" -Year 2021
}

# Remove a car
Remove-Car -id $carToUpdate.id

```

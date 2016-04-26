
#Assumption that the Adlex registry key has not changed and is the most reliable way to get the folder across versions.

# Real Search for CAS or ADS
$RegisteredProducts = Get-ChildItem "HKLM:\Software\Adlex\Watchdog" | Where {$(Get-ItemProperty $_.pspath).pschildname.EndsWith("Central Analysis Server") -Or $(Get-ItemProperty $_.pspath).pschildname.EndsWith("Advanced Diagnostics Server")}

# Fake Search for testing multiple products logic
#$RegisteredProducts = Get-ChildItem "HKLM:\Software\Adlex\Watchdog" | Where {$(Get-ItemProperty $_.pspath).pschildname.EndsWith("Server") -Or $(Get-ItemProperty $_.pspath).pschildname.EndsWith("Server")}
$SelectedProduct = $()
if ($RegisteredProducts.Length -gt 1)
{
	do
	{
	Write-Output "Multiple DCRUM components have been detected on this system. Please select one of the following:"
Write-Output ""
	$x = 0
	Write-Output "  0) Exit without making any changes"
	for( $x = 1; $x -le $RegisteredProducts.Length; $x++)
	{	
	
		Write-Output "  $($x)) $((Get-ItemProperty -Path $RegisteredProducts[$x-1].pspath).Name)"
		
	}
	Write-Output ""
	$Selection = Read-Host -Prompt "Select a number from 1 to $($RegisteredProducts.Length)"
	}
	While (($Selection -lt 0) -Or ($Selection -gt $RegisteredProducts.Length))
	if($Selection -le 0)
	{
		exit
	}
	$SelectedProduct = $RegisteredProducts[$Selection - 1]
}
else
{
	$SelectedProduct = $RegisteredProducts
}
$SelectedProductName = (Get-ItemProperty -Path $SelectedProduct.pspath).Name
Write-Output "This script will modify the configuration for the $SelectedProductName"
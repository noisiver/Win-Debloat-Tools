Import-Module -DisableNameChecking $PSScriptRoot\..\"title-templates.psm1"

function Remove-UWPAppx() {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0, Mandatory)]
        [String[]] $AppxPackages
    )

    Begin {
        $Script:TweakType = "UWP"
    }

    Process {
        ForEach ($AppxPackage in $AppxPackages) {
            If ((Get-AppxPackage -AllUsers -Name $AppxPackage) -or (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage)) {
                Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage from ALL users..."
                Get-AppxPackage -AllUsers -Name $AppxPackage | Remove-AppxPackage # App
                Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers # Payload
            } Else {
                Write-Status -Types "?", $TweakType -Status "$AppxPackage was already removed or not found..." -Warning
            }
        }
    }
}

<#
Example:
Remove-UWPAppx -AppxPackages "AppX1"
Remove-UWPAppx -AppxPackages @("AppX1", "AppX2", "AppX3")
#>

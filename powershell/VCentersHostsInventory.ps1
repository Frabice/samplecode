
# ##################################################################
# Exemple d'inventaire des hosts ESXi managés par plusieurs VCenter
# 2022/05/25 - Frabice
# ##################################################################
$VCenterServers = "vcenter1","vcenter2","vcenter3"
$cred = Get-Credential 

# Connexion sur tous les VCenter connus
Connect-VIServer -Server $VCenterServers -Credential $cred | Out-Null

# liste les serveurss ESX avec le Cluster associé.
$ESX = Get-VMHost -Server $VCenterServers | %{ $_ | Select `
  @{N="vCenter";E={$_.ExtensionData.Client.ServiceUrl.Split('/')[2]}},
  Parent,
  Name,
  Version,Build
}

# Déconnexion de tous les VCenter
Disconnect-VIServer * -force -Confirm:$false

# Affichage du résultat
$ESX | Sort-Object -Property vCenter,Parent,Name |Format-Table -AutoSize

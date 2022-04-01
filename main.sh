image="Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"
vmSize="Standard_B1ms"
login="azureuser"
password="Pa$$w0rD-$randomIdentifier"
image="Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"
vmSize="Standard_B1ms"
login="azureuser"
password="Pa$$w0rD-$randomIdentifier"
vNetAddressPrefixes="10.0.0.0/16 fd00:db8:deca::/48"
location="East US"



echo "Using resource group $resourceGroup with login: $login, password: $password..."

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" 

# echo "Creating $vNet"
# az network vnet create --name $vNet --resource-group $resourceGroup --location "$location" --address-prefixes $vNetAddressPrefixes

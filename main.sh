#Variables

let "randomIdentifier=$RANDOM*$RANDOM"
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
resourceGroup="tor-bridge-rg-$randomIdentifier"
vNet="tor-bridge-vnet-$randomIdentifier"
nsg="tor-bridge-nsg-$randomIdentifier"
subnet="tor-bridge-single-dual-stack-subnet-$randomIdentifier"
subnetAddressPrefixes="10.0.0.0/24 fd00:db8:deca:deed::/64"
ipV4PublicIp="tor-ipV4-public-ip-address-$randomIdentifier"
ipV6PublicIp="tor--ipV6-public-ip-address-$randomIdentifier"
sku="BASIC"
allocationMethod="dynamic"
#########################################################################3

echo "Using resource group $resourceGroup with login: $login, password: $password..."

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" 

# echo "Creating $vNet"
az network vnet create --name $vNet --resource-group $resourceGroup --location "$location" --address-prefixes $vNetAddressPrefixes

# Create network security group
echo "Creating $nsg"
az network nsg create --name $nsg --resource-group $resourceGroup --location "$location"

# Create a single dual stack subnet with IPv4 and IPv6 addresses
echo "Creating $subnet"
az network vnet subnet create --name $subnet --resource-group $resourceGroup --vnet-name $vNet --address-prefixes $subnetAddressPrefixes --network-security-group $nsg

# Create an IPV4 IP address
echo "Creating $ipV4PublicIp"
az network public-ip create --name $ipV4PublicIp --resource-group $resourceGroup --location "$location" --sku $sku --allocation-method $allocationMethod --version IPv4

# Create an IPV6 IP address
echo "Creating $ipV6PublicIp"
az network public-ip create --name $ipV6PublicIp --resource-group $resourceGroup --location "$location" --sku $sku --allocation-method $allocationMethod --version IPv6

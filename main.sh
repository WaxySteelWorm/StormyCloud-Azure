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
sku="standard"
allocationMethod="static"
nic0="tor-nic0-$randomIdentifier"
nic0ConfigIpV6="tor-ipV6-config-nic0-$randomIdentifier"
vm0="tor-vm$randomIdentifier"

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

# Create NICs
echo "Creating $nic0"
az network nic create --name $nic0 --resource-group $resourceGroup --network-security-group $nsg --vnet-name $vNet --subnet $subnet --private-ip-address-version IPv4 --public-ip-address $ipV4PublicIp

# Create IPV6 configurations for each NIC
echo "Creating $nic0ConfigIpV6 and $nic1ConfigIpV6"
az network nic ip-config create --name $nic0ConfigIpV6 --nic-name $nic0 --resource-group $resourceGroup --vnet-name $vNet --subnet $subnet --private-ip-address-version IPv6 --public-ip-address $ipV6PublicIp

# Create inbound rules
echo "Creating inbound rule in $nsg for port 22"
az network nsg rule create --name allowSSHin --nsg-name $nsg --resource-group $resourceGroup --priority 100 --description "Allow SSH" --access Allow --protocol "*" --direction Inbound --source-address-prefixes "*" --source-port-ranges 22 --destination-address-prefixes "*" --destination-port-ranges 22
az network nsg rule create --name allowtor --nsg-name $nsg --resource-group $resourceGroup --priority 101 --description "Allow 7000" --access Allow --protocol "*" --direction Inbound --source-address-prefixes "*" --source-port-ranges 7000 --destination-address-prefixes "*" --destination-port-ranges 7000
az network nsg rule create --name allowtor2 --nsg-name $nsg --resource-group $resourceGroup --priority 102 --description "Allow 7001" --access Allow --protocol "*" --direction Inbound --source-address-prefixes "*" --source-port-ranges 7001 --destination-address-prefixes "*" --destination-port-ranges 7001


# Create outbound rule
echo "Creating outbound rule in $nsg to allow all"
az network nsg rule create --name allowAllOut --nsg-name $nsg --resource-group $resourceGroup --priority 100 --description "Allow All Out" --access Allow --protocol "*" --direction Outbound --source-address-prefixes "*" --source-port-ranges "*" --destination-address-prefixes "*" --destination-port-ranges "*"

# Create virtual machines
Creating "$vm0"
az vm create --name $vm0 --resource-group $resourceGroup --nics $nic0 --size $vmSize --image $image --admin-user $login --admin-password $password

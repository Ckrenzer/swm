# MS SQL Drivers
curl https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg    # **
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
# ensure /etc/apt/sources.list.d/mssql-release.list has the signed-by=/usr/share/keyrings/microsoft-prod.gpg in the [],
# like this (note that there isn't a comma before the signed-by):
#    deb [arch=amd64,armhf,arm64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/22.04/prod  jammy main
sudo apt update
ACCEPT_EULA=Y
sudo apt-get install -y --no-install-recommends msodbcsql18

# Azure cli (needs line ** to have already ran)
echo "deb [arch=`dpkg --print-architecture` signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/repos/azure-cli/ jammy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt update
sudo apt-get install azure-cli

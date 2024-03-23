# drivers for external monitors
curl https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb -o synaptics-repository-keyring.deb
sudo apt install ./synaptics-repository-keyring.deb
rm synaptics-repository-keyring.deb
sudo apt update
install_if_not_found "displaylink-driver"

#!/usr/bin/bash

# Installs software I use in debian-based desktop environments (Linux Mint).
function install_if_not_found(){
    if dpkg -l | grep "^ii\ \+$1 "; then
        echo "$1 already installed"
    else
        sudo apt install "$1" -y || echo "ISSUE INSTALLING $1"
    fi
}

sudo apt update

# utilities that are common dependencies or provide easier access to system settings
install_if_not_found "tzdata" && \
    echo "tzdata tzdata/Areas select Your_Timezone_Area" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/Your_Timezone_Area select Your_Timezone" | debconf-set-selections
install_if_not_found "software-properties-common"
install_if_not_found "curl"
install_if_not_found "xdotool"

# languages and compilers
FILES=$(find languages_and_compilers/ -name '*.sh' -not -name 'julia.sh')
for FILE in $FILES; do
    source $FILE
done
source languages_and_compilers/julia.sh # julia installs using pip--have to ensure that python is already installed

# applications, cli-tools, utilities, etc.
FILES=$(find tools/ -name '*.sh')
for FILE in $FILES; do
    source $FILE
done

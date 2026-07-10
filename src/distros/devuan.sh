#!/usr/bin/bash
set -euo pipefail

# assumes config directories are already in place.


sudo apt-get update

# timezone and stuff needed for many applications
sudo apt-get install -y tzdata
echo "tzdata tzdata/Areas select Your_Timezone_Area" | debconf-set-selections
echo "tzdata tzdata/Zones/Your_Timezone_Area select Your_Timezone" | debconf-set-selections
sudo apt-get install -y \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    curl \
    wget \
    git \
    make

# assuming an X-server
sudo apt-get install -y xdotool

# awk
sudo apt-get install -y gawk mawk

# c
sudo apt-get install -y gcc

# java
sudo apt-get install -y openjdk-default-jdk maven jlink

# lisp
sudo apt-get install -y sbcl
## install, configure Quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    sbcl --non-interactive --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" --quit
## I like using CIEL on top of sbcl primarily due to its improved documentation
## ASDF>=3.3.4 needed to support local-nicknames
chmod +x ../scripts/update_asdf.sh && ../scripts/update_asdf.sh
## CIEL build dependencies
sudo apt-get install -y libzstd-dev inotify-tools libreadline-dev
## install CIEL since it isn't on Quicklisp
ciel_dir="$HOME/quicklisp/local-projects/CIEL"
git clone https://github.com/ciel-lang/CIEL "$ciel_dir"
## build CIEL core image, which will also install all dependencies
cd "$ciel_dir" && make image && cd -

# python
sudo add-apt-repository ppa:deadsnakes/ppa
python_version=3.14
sudo apt-get install -y "python${python_version}-pip" \
                        "python${python_version}-venv" \
                        "python${python_version}-dev" \
                        "python${python_version}-tk" \
                        "python${python_version}-distutils" \
                        "python${python_version}-gdbm"

# r
sudo apt-get install -y r-base-core

# various software
sudo apt-get install -y \
    adb \
    scrcpy \
    fdupes \
    ffmpeg \
    libreoffice \
    obs-studio \
    openssh-server \
    parallel \
    texlive-latex-base \
    tmux \
    virtualbox

# poppler
sudo add-apt-repository -y ppa:cran/poppler
sudo apt update
sudo apt install -y libpoppler-cpp-dev

# csvquote
## builds the executable and stores it in /usr/local/bin
beginwd="$PWD" && \
    mkdir ~/repos -p && \
    cd ~/repos && \
    git clone https://github.com/dbro/csvquote.git && \
    cd csvquote && \
    make && \
    sudo make install && \
    cd "$beginwd"

# Azure CLI
## (dependencies already installed)
## signing key
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
## software repository
AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources
## install
sudo apt-get update
sudo apt-get install -y azure-cli

# docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
## add docker's official GPG key:
sudo apt-get update
install_if_not_found "ca-certificates"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
## add the repository to Apt sources ($UBUNTU_CODENAME or $VERSION_CODENAME, whichever is in /etc/os-release)
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
## verify that the installation succeeded
sudo docker run --rm hello-world

# neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt-get install -y neovim
## vim-plug
test -e "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" || \
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## install plugins (assumes configs are already in place)
nvim --headless -u "$HOME/.config/nvim/init.lua" +PlugInstall +qall

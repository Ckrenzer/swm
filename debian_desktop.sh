#!/usr/bin/bash

# Installs software I use in debian-based desktop environments (Linux Mint).


function install_if_not_found(){
    if dpkg -l | grep "^ii\ \+$1 "; then
        echo "$1 already installed"
    else
        sudo apt install "$1" -y || echo "ISSUE INSTALLING $1"
    fi
}
function pip_install_if_not_found(){
    if pip3 list | grep "^$1\ "; then
        echo "$1 already installed"
    else
        sudo pip install "$1" || echo "ISSUE INSTALLING $1"
    fi
}


# PROGRAMMING LANGUAGES, COMPLIERS, ETC.
install_if_not_found "buildapp" # used to create executables (works well with sbcl)
install_if_not_found "gawk"
install_if_not_found "gcc"
install_if_not_found "golang-go"
# <<RStudio dependencies from an installer>>
install_if_not_found "lib32stdc++6"
install_if_not_found "libclang-dev"
install_if_not_found "libc6-i386"
install_if_not_found "lib32gcc-s1"
install_if_not_found "libllvm14"
install_if_not_found "libobjc-11-dev"
install_if_not_found "libclang1-14"
install_if_not_found "libclang-common-14-dev"
install_if_not_found "libobjc4"
install_if_not_found "libclang-14-dev"
# <<End RStudio dependencies from an installer>>
install_if_not_found "lua5.4"
install_if_not_found "mawk"
install_if_not_found "openjdk-19-jdk" # replace the java version with default-jdk if you don't care about the version.
                                      # sudo apt-get purge --autoremove openjdk* removes Java from your system
install_if_not_found "php-cli"
install_if_not_found "python3"
install_if_not_found "python3-pip"
install_if_not_found "python3-venv"
install_if_not_found "r-base-core"
install_if_not_found "ruby"
install_if_not_found "rustc"
install_if_not_found "sbcl"


# APPLICATIONS
install_if_not_found "chromium-browser"
install_if_not_found "firefox"
install_if_not_found "gparted"
install_if_not_found "libreoffice"
install_if_not_found "obs-studio"
install_if_not_found "pgadmin4"
install_if_not_found "slack"
install_if_not_found "tor"
install_if_not_found "virtualbox"
install_if_not_found "vlc-bin"
install_if_not_found "zoom-player"


# TOOLS AND UTILITIES
install_if_not_found "adb"            # Used to connect my android phone to my computer for developer-mode debugging,
                                      # which I primarily use for screencasting
install_if_not_found "cargo"          # rust package manager
install_if_not_found "composer"       # php package manager
install_if_not_found "docker.io"
install_if_not_found "ffmpeg"         # video and audio converter
install_if_not_found "gem"            # ruby package manager
install_if_not_found "git"
# <<R package installation dependencies>>
install_if_not_found "libcurl4-openssl-dev"
install_if_not_found "libudunits2-dev"
install_if_not_found "libgdal-dev"
# <<End R packages installation dependencies>>
install_if_not_found "luarocks"       # lua package manager
install_if_not_found "pass"           # needed for gpg
install_if_not_found "maven"          # maven is required for the java LSP
install_if_not_found "npm"            # mason.nvim requires npm to do the work installing LSPs
install_if_not_found "parallel"
install_if_not_found "poppler-utils"  # contains the pdftotext utility
install_if_not_found "putty"
install_if_not_found "scrcpy"         # I can screencast my phone onto the computer using this once the phone
                                      # is connected to the adb server (preferably using a usb chord)
install_if_not_found "tmux"
install_if_not_found "xdotool"        # used in some vim functions to turn off caps lock


# PIP3 INSTALLS
pip3 list | grep "^jill\ " || \
    sudo pip install jill --user -U
pip_install_if_not_found "numpy"
pip_install_if_not_found "pandas"
# youtube-dl is always out of date on apt.
# YouTube's actions make this tool unstable.
# The pip installation is your best bet.
pip_install_if_not_found "youtube-dl"


# R PACKAGES
sudo Rscript -e "pkgs <- commandArgs(trailingOnly = TRUE)
                 installed <- rownames(installed.packages())
                 pkgs <- pkgs[!pkgs %in% installed]
                 install.packages(pkgs)" \
                     data.table \
                     foreach    \
                     iterators  \
                     parallel   \
                     doParallel \
                     rlang      \
                     stringr    \
                     ggplot2    \
                     openxlsx   \
                     clipr


# SPECIAL HANDLING
# <<ensure npm is up-to-date>>
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
#<<End ensure npm is up-to-date>>

# <<latest stable version of neovim>>
if dpkg -l | grep "^ii\ \+neovim "; then
    echo "neovim already installed"
else
    install_if_not_found "software-properties-common"
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim
fi
# <<End latest stable version of neovim>>

# <<display link driver installation>>
# drivers from repo to use external monitors through docking stations (among other uses)
synaptics_file="$HOME/Downloads/synaptics-repository-keyring.deb" # path to the repository on disk
curl "https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb" -o "$synaptics_file"
install_if_not_found "${synaptics_file}"
install_if_not_found "displaylink-driver"
# <<End display link driver installation>>

# <<vimplug installation script>>
test -e "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" || \
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# <<End vimplug installation script>>

# <<julia installation>>
jill install # requires ${HOME}/.local/bin to be on PATH for this to work
# <<End juliat installation>>

# <<quicklisp installation>>
if test -e ~/quicklisp/setup.lisp; then
    echo "quicklisp already installed"
else
    curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    curl -O https://beta.quicklisp.org/quicklisp.lisp.asc && \
    gpg --verify quicklisp.lisp.asc quicklisp.lisp && \
    sbcl --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" --eval "(quit)" && \
    rm quicklisp.lisp quicklisp.lisp.asc
fi
# <<End quicklisp installation>>

#!/bin/bash
# The purpose of this script is to quickly ready all tools and configurations
# following a fresh manjaro install. It is not a minimal installation,
# nor is it unattended.

# assumes $HOME/local is a directory that already exists.


# STEP 1: REMOVE FILES AND DIRECTORIES, CREATE DIRECTORIES
# remove pointless directories
rmdir ${HOME}/{Music,Templates,Videos,Pictures,Documents}
# remove pre-packaged dotfiles for the shell
rm ${HOME}/.{profile,bash{_profile,rc}}
# create directories for setup below
mkdir -p ${HOME}/repos/active



# STEP 2: INSTALL SOFTWARE
sudo pacman --noconfirm -S archlinux-keyring # update keys to access/verify repos
sudo pacman --noconfirm -Syyu                # force update of all software

# TOOLS
# <<virtualbox modules require a reboot before use>>
sudo pacman --noconfirm -S \
    alacritty \
    android-tools \
    azure-cli \
    base-devel \
    bash-completion \
    ctags \
    docker \
    docker-compose \
    fdupes \
    ffmpeg \
    gcc \
    git \
    gparted \
    jq \
    kanshi \
    libxcrypt-compat \
    make \
    obs-studio \
    openssh \
    parallel \
    poppler \
    postgresql \
    python-pip \
    python-pipx \
    scrcpy \
    tailscale \
    tldr \
    tree-sitter \
    tree-sitter-cli \
    virtualbox linux66-virtualbox-host-modules \
    wine winetricks wine-mono wine_gecko
# <<some manjaro ISO files do not have yay installed by default>>
git clone https://aur.archlinux.org/yay-git.git && \
    cd yay-bin && makepkg -si && cd - && rm -rf yay-bin
# install azure functions core tools
yay -S azure-functions-core-tools-bin
# ensure the tmux installation supports sixel images (for terminal previews)
# use the most recent version of yazi since it will have the best tmux compatibility
yay -S tmux-sixel-git yazi-git
# duckdb cli isn't in the repositories
curl https://install.duckdb.org | sh
# docker buildx is only available on the AUR
yay -S docker-buildx-bin

# NEOVIM
sudo pacman --noconfirm -S neovim
test -e "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" || \
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# LANGUAGES
sudo pacman --noconfirm -S r sbcl

# STEP 3: SET UP SERVICES AND CONFIGURATIONS
# bash + shell-related dotfiles
path_dfm=${HOME}/repos/active/dfm
git clone https://github.com/Ckrenzer/dfm.git $path_dfm
cd $path_dfm && git checkout arch && git pull
# <<using find in this way ensures the links use absolute paths>>
# this fails when symlinking to a directory that already exists
# (like $HOME/.config/ and all its contents) !!!!!!
ln -fs $(find ${path_dfm}/dotfiles -mindepth 1 -maxdepth 1) $HOME

# neovim
path_nvim=${HOME}/repos/active/nvim
git clone https://github.com/Ckrenzer/nvim.git $path_nvim
ln -fs $path_nvim ${HOME}/.config/nvim
nvim --headless -u ${path_nvim}/init.lua +PlugInstall +qall
# <<sbcl setup for neovim's nvlime plugin>>
curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    sbcl --load ./quicklisp.lisp --eval "(quicklisp-quickstart:install)" --eval "(quit)" && \
    rm quicklisp.lisp

# git
git config --global user.name "Ckrenzer"
git config --global user.email "ckrenzer.info@gmail.com"

# services
# <<move system-wide service files>>
ln -fs $(find ${path_dfm}/systemfiles/etc/systemd/system -mindepth 1 -maxdepth 1) /etc/systemd/system
# <<move executable files used by services>>
ln -fs ${PWD}/localbin ${HOME}/local/bin && sudo systemctl daemon-reload
sudo systemctl enable sshd && sudo systemctl start sshd
systemctl --user start docker.service && systemctl --user enable docker.service
sudo systemctl enable --now tailscaled && sudo tailscale up && \
    printf "your IPv4 address in tailscale: %s\n" "$(tailscale ip -4)"
# <<once you have tailscale configured on your machine, you should update these values:
sudo sysctl -w net.ipv4.conf.default.rp_filter=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=1
#  so that the kernel only accepts packets from a source address if there
#  exists a route back to the source address in the routing table, such as
#  the internal interfaces in the machine. >>


# STEP 4: DEAL WITH SENSITIVE INFORMATION
# let's assume that this directory was placed here before running the script
source ${HOME}/local/config_files_with_sensitive_information/make_links.sh

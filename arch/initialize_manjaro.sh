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
    android-tools \
    base-devel \
    ctags \
    docker \
    fdupes \
    ffmpeg \
    gcc \
    git \
    make \
    obs-studio \
    parallel \
    poppler \
    ranger \
    scrcpy \
    tldr \
    tmux \
    virtualbox linux66-virtualbox-host-modules \
    wind winetricks wine-mono wine_gecko \
    xorg-xhost
# <<manjaro does not have yay installed by default>>
git clone https://aur.archlinux.org/yay-git.git && \
    cd yay-bin && makepkg -si && cd - && rm -rf yay-bin

# ENVIRONMENTS
sudo pacman --noconfirm -S i3

# NEOVIM
sudo pacman --noconfirm -S neovim
test -e "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" || \
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# LANGUAGES
sudo pacman --noconfirm -S r sbcl

# LANGUAGE SERVERS
sudo pacman --noconfirm -S \
    bash-language-server \
    lua-language-server \
    pyright
R -e "install.packages('languageserver', repos = 'https://cloud.r-project.org')"
sudo pacman --noconfirm -S npm
npm cache clean -f
npm install -g n
n stable
sudo npm install -g vim-language-server
sudo npm install -g awk-language-server



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
# <<allow root to access the user's x session>>
sudo echo 'xhost +SI:localuser:root > /dev/null 2>&1' >> /etc/profile
# <<move executable files used by services>>
ln -fs ${PWD}/localbin ${HOME}/local/bin && sudo systemctl daemon-reload
sudo systemctl enable set-keyboard-repeat-rate.service && \
    sudo systemctl start set-keyboard-repeat-rate.service
systemctl --user start docker.service && systemctl --user enable docker.service



# STEP 4: DEAL WITH SENSITIVE INFORMATION
# let's assume that this directory was placed here before running the script
source ${HOME}/local/config_files_with_sensitive_information/make_links.sh

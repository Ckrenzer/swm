# dependencies:
# tzdata (non-interactive sessions only)
# r-base
# libxml2-dev
# curl
# software-properties-common
# gcc
# git
# npm
# unzip
# xdotool (required for personal config files)

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim
# install vimplug
test -e "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" || \
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim --headless -u /root/.config/nvim/init.vim +PlugInstall +qall

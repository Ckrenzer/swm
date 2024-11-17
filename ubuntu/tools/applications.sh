# tools that do not require any special handling are lumped into this script
install_if_not_found "adb"                # Used to connect my android phone to my computer for developer-mode debugging,
                                          # which I primarily use for screencasting
install_if_not_found "arp-scan"
install_if_not_found "awscli"
install_if_not_found "chromium-browser"
install_if_not_found "cifs-utils"
install_if_not_found "fdupes"
install_if_not_found "ffmpeg"             # video and audio converter
install_if_not_found "firefox"
install_if_not_found "git"
install_if_not_found "gparted"
install_if_not_found "grip"               # render markdown files the same way as GitHub via: grip -b file.md
install_if_not_found "libfontconfig1-dev" # system fonts
install_if_not_found "libreoffice"
install_if_not_found "luarocks"           # lua package manager
install_if_not_found "lynx"               # useful for viewing markdown documents
install_if_not_found "nmap"               # useful for identifying nas hard drives
install_if_not_found "obs-studio"
install_if_not_found "openssh-server"     # mint comes with the ssh client but not the server
install_if_not_found "parallel"
install_if_not_found "pass"               # needed for gpg
install_if_not_found "poppler-utils"      # contains the pdftotext utility
install_if_not_found "putty"
install_if_not_found "ranger"
install_if_not_found "samba"
install_if_not_found "slack"
install_if_not_found "scrcpy"             # I can screencast my phone onto the computer using this once the phone
                                          # is connected to the adb server (preferably using a usb chord)
install_if_not_found "texlive-latex-base" # LaTex library
install_if_not_found "tmux"
install_if_not_found "tor"
install_if_not_found "unixodbc-dev"
install_if_not_found "unzip"
install_if_not_found "virtualbox"
install_if_not_found "vlc-bin"
install_if_not_found "winbind"
install_if_not_found "zoom-player"




# WINE (the ubuntu repo version is usually quite old)
sudo dpkg --add-architecture i386 # enable 32 bit architecture
sudo mkdir -pm755 /etc/apt/keyrings # download and add the repository key
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources # download sources file for your distro
sudo apt update
sudo apt install --install-recommends winehq-stable

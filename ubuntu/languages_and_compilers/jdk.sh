install_if_not_found "openjdk-19-jdk" # replace the java version with default-jdk if you don't care about the version.
                                      # sudo apt-get purge --autoremove openjdk* removes Java from your system
install_if_not_found "maven" # maven is required for neovim's java LSP
install_if_not_found "jlink"

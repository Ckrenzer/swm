install_if_not_found "gawk"
install_if_not_found "mawk"

# some extensions to awk
repodir="$HOME/repos/forks_and_clones"
mkdir -p "$repodir"

# be sure to set the variable AWKPATH environment variable to point at awk-libs
git clone https://github.com/e36freak/awk-libs.git "${repodir}/awk-libs"

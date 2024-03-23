sudo add-apt-repository ppa:deadsnakes/ppa

# `python#.#-dev`: includes development headers for building C extensions
# `python#.#-venv`: provides the standard library `venv` module
# `python#.#-distutils`: provides the standard library `distutils` module
# `python#.#-lib2to3`: provides the `2to3-#.#` utility as well as the standard library `lib2to3` module
# `python#.#-gdbm`: provides the standard library `dbm.gnu` module
# `python#.#-tk`: provides the standard library `tkinter` module

install_if_not_found "python3.11"
install_if_not_found "python3-pip"
install_if_not_found "python3.11-venv"
install_if_not_found "python3.11-dev"
install_if_not_found "python3.11-tk"
install_if_not_found "python3.11-distutils"
install_if_not_found "python3.11-gdbm"

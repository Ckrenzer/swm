install_if_not_found "sbcl"
install_if_not_found "buildapp"       # used to create executables (works well with sbcl)
# quicklisp
if test -e ~/quicklisp/setup.lisp; then
    echo "quicklisp already installed"
else
    curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    curl -O https://beta.quicklisp.org/quicklisp.lisp.asc && \
    gpg --verify quicklisp.lisp.asc quicklisp.lisp && \
    sbcl --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" --eval "(quit)" && \
    rm quicklisp.lisp quicklisp.lisp.asc
fi

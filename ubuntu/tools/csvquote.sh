#!/usr/bin/bash

# builds the csvquote executable and stores it in /usr/local/bin
beginwd="$PWD" && \
    mkdir ~/repos -p && \
    cd ~/repos && \
    git clone https://github.com/dbro/csvquote.git && \
    cd csvquote && \
    make && \
    sudo make install && \
    cd "$beginwd" || \
    echo "failed to build csvquote"

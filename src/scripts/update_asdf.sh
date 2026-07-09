#!/usr/bin/bash
set -euo pipefail

# create common-lisp directory
mkdir -p "$HOME/common-lisp/"
cd "$HOME/common-lisp/"

# identify newest ASDF version
archive_url=https://asdf.common-lisp.dev/archives/
file_name=$(curl $archive_url | \
    awk 'BEGIN{
        # awk already supplies these values by default, but boy is that a chore
        # to remember
        highest_major = 0
        highest_minor = 0
        highest_bump = 0
        newest_file = ""
    }
    /asdf-[0-9]+.[0-9]+.[0-9]+.tar.gz/ {
        match($0, /asdf-[0-9]+.[0-9]+.[0-9]+.tar.gz/)
        file_name = substr($0, RSTART, RLENGTH)
        split(file_name, components, /\.|\-/)
        major = components[2]
        minor = components[3]
        bump = components[4] # note: awk treats non-numbers as zero
        if(major > highest_major){
            highest_major = major
            highest_minor = minor
            highest_bump = bump
            newest_file = file_name
        } else if(minor > highest_minor){
            highest_minor = minor
            highest_bump = bump
            newest_file = file_name
        } else if(bump > highest_bump){
            highest_bump = bump
            newest_file = file_name
        }
    }
    END{
        print(newest_file)
    }')
# file_name must not be unset or ""
: "${file_name:?An archive version of ASDF could not be identified!}"
newest_archive_file="${archive_url}${file_name}"

# download and unarchive
curl "$newest_archive_file" -o "$file_name"
tar -xvf "$file_name"
mv "$file_name" asdf

# return to starting dir
cd -

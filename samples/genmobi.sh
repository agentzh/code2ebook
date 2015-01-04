#!/bin/bash

# this sample script is to generate three .mobi
# ebooks from the nginx source tree.
# just put this script in the root directory of
# your nginx source tree, and ensure both the src2html.pl
# script (from code2ebook) and the ebook-convert utility
# (from Calibre) are in your PATH.

trap "echo Abort; exit" SIGINT

name=`pwd|perl -e '$d=<>;$d=~s{.*/}{}g;print $d'`

echo "Generating HTMLs from src/ for $name..."
src2html.pl --color --cross-reference src $name

echo "Generating .mobi file for $name..."
rm -rf *.mobi
for dir in core event http; do
    ebook-convert src/$dir/index.html $name-$dir.mobi \
        --output-profile kindle_dx --no-inline-toc \
        --title "$name $dir" --publisher agentzh \
        --language en --authors 'Igor Sysoev'
done


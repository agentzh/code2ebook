#!/bin/bash

# this sample script is to generate a .epub and a .mobi
# ebooks.
# Ensure the ebook-convert utility (from Calibre) are in
# your PATH environment.

trap "echo Abort; exit" SIGINT

name=`pwd|perl -e '$d=<>;$d=~s{.*/}{}g;print $d'`
title="foo program"

export PATH=$PWD/../..:$PATH

echo "Generating HTMLs from ./ for $name..."
src2html.pl --color --cross-reference --line-numbers . $name

echo "Generating $name.epub file..."
rm -rf *.epub
ebook-convert ./index.html $name.epub \
    --output-profile ipad3 \
    --no-default-epub-cover \
    --output-profile kindle_dx \
    --title "$title" --publisher agentzh \
    --language en --authors agentzh

echo "Generating $name.mobi file..."
rm -rf *.mobi
ebook-convert ./index.html $name.mobi \
    --output-profile kindle_dx --no-inline-toc \
    --title "$title" --publisher agentzh \
    --language en --authors agentzh


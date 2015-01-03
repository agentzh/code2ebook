Name
====

code2ebook - Generate ebooks in various formats from source trees in various programming languages

Table of Contents
=================

* [Name](#name)
* [Description](#description)
    * [Generate an HTML site from the source tree](#generate-an-html-site-from-the-source-tree)
    * [Convert the HTML site to ebook files in various formats](#convert-the-html-site-to-ebook-files-in-various-formats)
        * [Generate mobi-formatted ebook for Kindle](#generate-mobi-formatted-ebook-for-kindle)
        * [Generate epub-formatted ebook for iPad/iPhone](#generate-epub-formatted-ebook-for-ipadiphone)
* [Source file types recognized](#source-file-types-recognized)
* [Prerequisites](#prerequisites)
* [Author](#author)
* [Copyright and License](#copyright-and-license)

Description
===========

Want to browse big source code trees in your Kindle or iPad?

This project provides utilities to help generating pretty ebook files in various formats
directly from arbitrary source trees.

Generate an HTML site from the source tree
------------------------------------------

Before you begin, ensure you have installed all the [prerequisites](#prerequisites).

The `src2html.pl` script can generate an HTML tree from the source tree that you specify, for example:

```bash
export PATH=/path/to/src2kindle:$PATH
src2html.pl --color /path/to/my/src/tree/ 'Your Book Title'
```

The resulting HTML site can be viewed in a web browser. And the entry
point is `/path/to/my/src/tree/index.html`.

One sample site for the weighttp source tree can be browsed here:

http://agentzh.org/misc/code/weighttp/

Note that, for ebook readers lacking colors (like Amazon Kindle), then
you should not specify the `--color` option for the `src2html.pl` script.

This is essentially an HTML-formatted "ebook" :)

Convert the HTML site to ebook files in various formats
-------------------------------------------------------

Now that we have the HTML-formatted "ebook", we can generate ebooks in other formats like `.mobi` and `.epub` using Calibre
(http://calibre-ebook.com/).

[Back to TOC](#table-of-contents)

### Generate mobi-formatted ebook for Kindle

For example, to generate a `.mobi` file for Kindle DX:

```bash
ebook-convert /path/to/my/src/tree/index.html my-src.mobi \
    --output-profile kindle_dx --no-inline-toc \
    --title "Your Book Title" --publisher 'Your Name' \
    --language en --authors 'Your Author Name'
```

In this example, the resulting ebook file is named `my-src.mobi` in the
current working directory.

Note: On OS X you have to go to `Preferences->Advanced->Miscellaneous` and click install command line tools to make the command line tools available after you installed the app. On other platforms, just start a terminal and type the command.

Here we use the value "kindle_dx" for the `--output-profile` option
assuming that we want to view the ebook in Kindle DX. You
should use "kindle" for other (smaller) models of Kindle.

The ebook-convert utility is provided by Calibre, see its online
documentation for full usage:

http://calibre-ebook.com/user_manual/cli/ebook-convert.html

Well you need both Perl and Python ;)

[Back to TOC](#table-of-contents)

### Generate epub-formatted ebook for iPad/iPhone

Below is a simple sample command to generate the `.epub` ebook from the
HTML site:

```bash
ebook-convert /path/to/my/src/tree/index.html my-src.epub \
    --output-profile ipad3 \
    --no-default-epub-cover \
    --title "Your Book Title" --publisher 'Your Name' \
    --language en --authors 'Your Author Name'
```

In this example, the resulting ebook file is named `my-src.epub` in the
current working directory, which is readily readable in apps like `iBooks`.

[Back to TOC](#table-of-contents)

Source file types recognized
============================

Currently only the following files will be searched by
src2html.pl according to their file extensions:

    .c .cpp .h
    .tt .js .pl .php .t .pod .xml .conf .pm6
    .lzsql .lzapi .grammar .lua .java .sql
    .go

You can edit the related regex in the Perl source of the src2html.pl
to add or remove extensions that it will recognize.

[Back to TOC](#table-of-contents)

Prerequisites
=============

You need to install the following dependencies of a recent version:

* [Exuberant Ctags](http://ctags.sourceforge.net/)

should be readily available in almost all the Linux
distributions by simply installing the `ctags` package.
* [Vim](http://www.vim.org/)

should be readily available in almost all the Linux distributions
by simply installing the `vim` package.
* [perl](http://www.perl.org/)

should be readily available in almost all the Linux
distributions by simply installing the `perl` package.

All these components are very common programs in the \*NIX world.

[Back to TOC](#table-of-contents)

Author
======

Yichun "agentzh" Zhang (章亦春) <agentzh@gmail.com>, CloudFlare Inc.

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2011-2014, by Yichun "agentzh" Zhang, CloudFlare Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)


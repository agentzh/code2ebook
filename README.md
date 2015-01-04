Name
====

code2ebook - Generate ebooks in various formats from source trees in various programming languages

Table of Contents
=================

* [Name](#name)
* [Description](#description)
    * [Generate static HTML sites from source trees](#generate-static-html-sites-from-source-trees)
        * [src2html.pl](#src2htmlpl)
            * [Usage](#usage)
            * [HTML output features](#html-output-features)
            * [Source file types recognized](#source-file-types-recognized)
    * [Convert the HTML site to ebooks in various formats](#convert-the-html-site-to-ebooks-in-various-formats)
        * [Generate MOBI ebooks for Kindle](#generate-mobi-ebooks-for-kindle)
        * [Generate EPUB ebooks for iPad/iPhone](#generate-epub-ebooks-for-ipadiphone)
* [Prerequisites](#prerequisites)
* [Samples](#samples)
    * [weighttp](#weighttp)
        * [HTML for weighttp source tree](#html-for-weighttp-source-tree)
        * [EPUB for weighttp source tree](#epub-for-weighttp-source-tree)
        * [MOBI for weighttp source tree](#mobi-for-weighttp-source-tree)
    * [LuaJIT](#luajit)
        * [HTML for LuaJIT source tree](#html-for-luajit-source-tree)
        * [EPUB for LuaJIT source tree](#epub-for-luajit-source-tree)
        * [MOBI for LuaJIT source tree](#mobi-for-luajit-source-tree)
    * [Nginx](#nginx)
        * [HTML for Nginx source tree](#html-for-nginx-source-tree)
        * [EPUB for Nginx source tree](#epub-for-nginx-source-tree)
        * [MOBI for Nginx source tree](#mobi-for-nginx-source-tree)
* [Bugs](#bugs)
* [TODO](#todo)
* [Author](#author)
* [Copyright and License](#copyright-and-license)

Description
===========

Want to browse big source code trees in your Kindle or iPad?

This project provides utilities to help generating pretty ebook files in various formats
directly from arbitrary source trees.

Generate static HTML sites from source trees
--------------------------------------------

Before you begin, ensure you have installed all the [prerequisites](#prerequisites).

### src2html.pl

The `src2html.pl` script can generate an HTML tree from the source tree that you specify, for example:

```bash
export PATH=/path/to/code2ebook$PATH
src2html.pl --color /path/to/my/src/tree/ 'Your Book Title'
```

The resulting HTML site can be viewed in a web browser. And the entry
point is `/path/to/my/src/tree/index.html`.

See [Samples](#samples) for real-world sample outputs.
Note that, for ebook readers lacking colors (like Amazon Kindle), then
you should not specify the `--color` option for the `src2html.pl` script.

This is essentially an HTML-formatted "ebook", which is readily browsable in
a web browser on either a PC or a tablet.

[Back to TOC](#table-of-contents)

#### Usage

For the full usage of this script, specify the `-h` or `--help` options. One sample output is

```
src2html.pl [options] dir book-title

Options:
    --charset CHARSET     Specify the charset used by the HTML
                          outputs. Default to UTF-8.

    -c
    --color               Use full colors in the HTMTL outputs.

    -e PATTERN
    --exclude PATTERN     Specify a pattern for the source code files to be
                          excluded.

    -h
    --help                Print this help.

    -i PATTERN
    --include PATTERN     Specify the pattern for extra source code file names
                          to include in the HTML output. Wildcards
                          like * and [] are supported. And multiple occurances
                          of this option are allowed.

    -x
    --cross-reference     Turn on cross referencing links in the HTML output.

Copyright (C) Yichun Zhang (agentzh) <agentzh@gmail.com>.
```

[Back to TOC](#table-of-contents)

#### HTML output features

This `src2html.pl` script generates pretty HTML pages for each source code file
featuring

[Back to TOC](#table-of-contents)

1. Summarized data types, macros, global variables, and functions defined in each
source code file shown as TOC at the beginning of the
corresponding HTML page.
2. Colorful syntax highlighting via the `vim` program. (Enabled by the `--color` option).
3. Cross-reference links to the definition lines of the referenced data types,
macros, global variables, and functions across all the source code lines
(similar to the [LXR Cross Referencer](http://sourceforge.net/projects/lxr/)).

[Back to TOC](#table-of-contents)

#### Source file types recognized

Right now all the file extension names known to your `ctags` program
are supported. But `.html` and `.htm` files are always excluded to avoid
infinite recursion.

You can explicitly include extra source files by specifying as many `--include=PATTERN` options as you like,
as in

```bash
src2html.pl --include='src/*.blah' --include='*foo*' --color . "my project"
```

Similarly, you can also exclude files by specifying one or more `--exclude=PATTERN` options.

[Back to TOC](#table-of-contents)

Convert the HTML site to ebooks in various formats
--------------------------------------------------

Now that we have the HTML-formatted "ebook", we can generate ebooks in other formats like `.mobi` and `.epub` using [Calibre](http://calibre-ebook.com/).

[Back to TOC](#table-of-contents)

### Generate MOBI ebooks for Kindle

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

### Generate EPUB ebooks for iPad/iPhone

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

Prerequisites
=============

You need to install the following dependencies of a recent version:

* [Exuberant Ctags](http://ctags.sourceforge.net/)

should be readily available in almost all the Linux
distributions by simply installing the `ctags` package.
* [Vim](http://www.vim.org/)

should be readily available in almost all the Linux distributions
by simply installing the `vim` package.
* [Perl 5](http://www.perl.org/)

should be readily available in almost all the Linux
distributions by simply installing the `perl` package.

All these components are very common programs in the \*NIX world.

[Back to TOC](#table-of-contents)

Samples
=======

Below provides some sample ebooks generated from real-world opensource projects like [weighttp](#weighttp), [LuaJIT](#luajit), and [Nginx](#nginx).

[Back to TOC](#table-of-contents)

weighttp
--------

[weighttp](http://redmine.lighttpd.net/projects/weighttp/wiki)
is a lightweight and small benchmarking tool for webservers.

[Back to TOC](#table-of-contents)

### HTML for weighttp source tree

The HTML site generated from the weighttp source code can be browsed here:

http://agentzh.org/misc/code/weighttp/

[Back to TOC](#table-of-contents)

### EPUB for weighttp source tree

The corresponding EPUB ebook can be downloaded from below:

http://agentzh.org/misc/code/weighttp/weighttp.epub

[Back to TOC](#table-of-contents)

### MOBI for weighttp source tree

The corresponding MOBI ebook can be downloaded from below:

http://agentzh.org/misc/code/weighttp/weighttp.mobi

[Back to TOC](#table-of-contents)

LuaJIT
------

[LuaJIT](http://luajit.org/luajit.html) is a Just-In-Time Compiler (JIT) for the Lua programming language.
Lua is a powerful, dynamic and light-weight programming language.

[Back to TOC](#table-of-contents)

### HTML for LuaJIT source tree

The HTML site generated from the LuaJIT source code can be browsed here:

http://agentzh.org/misc/code/luajit2/

[Back to TOC](#table-of-contents)

### EPUB for LuaJIT source tree

The corresponding EPUB ebook can be downloaded from below:

http://agentzh.org/misc/code/luajit2/luajit-2.0-src.epub

[Back to TOC](#table-of-contents)

### MOBI for LuaJIT source tree

The corresponding MOBI ebook can be downloaded from below:

http://agentzh.org/misc/code/luajit2/luajit-2.0-src.mobi

[Back to TOC](#table-of-contents)

Nginx
-----

[Nginx](http://nginx.org/) is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3,
and IMAP protocols, as well as a load balancer, HTTP cache, and
a web server (origin server).

[Back to TOC](#table-of-contents)

### HTML for Nginx source tree

The HTML site generated from the Nginx source code can be browsed here:

http://agentzh.org/misc/code/nginx/

[Back to TOC](#table-of-contents)

### EPUB for Nginx source tree

The corresponding EPUB ebook can be downloaded from below:

http://agentzh.org/misc/code/nginx/nginx-1.7.9.epub

[Back to TOC](#table-of-contents)

### MOBI for Nginx source tree

The corresponding MOBI ebook can be downloaded from below:

http://agentzh.org/misc/code/nginx/nginx-1.7.9.mobi

[Back to TOC](#table-of-contents)

Bugs
====

* `vim` is the dominating performance bottleneck when running the `src2html.pl`
tool with the `--color` option.

[Back to TOC](#table-of-contents)

TODO
====

* Add support for the `--exclude=PATTERN` options to the [src2html.pl](#src2htmlpl) tool.

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


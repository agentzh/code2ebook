Name
====

code2ebook - Generate ebooks in various formats from source trees in various programming languages

Table of Contents
=================

* [Name](#name)
* [Description](#description)
    * [Generate static HTML sites from source trees](#generate-static-html-sites-from-source-trees)
        * [src2html.pl](#src2htmlpl)
            * [Change CSS style](#change-css-style)
            * [Usage](#usage)
            * [HTML output features](#html-output-features)
            * [Source file types recognized](#source-file-types-recognized)
    * [Convert the HTML site to ebooks in various formats](#convert-the-html-site-to-ebooks-in-various-formats)
        * [Generate MOBI ebooks for Kindle](#generate-mobi-ebooks-for-kindle)
        * [Generate EPUB ebooks for iPad/iPhone](#generate-epub-ebooks-for-ipadiphone)
* [Prerequisites](#prerequisites)
* [Sample eBooks](#sample-ebooks)
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
* [Known issues](#known-issues)
* [TODO](#todo)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Description
===========

Want to browse big source code trees in your Kindle or iPad?

This project provides utilities to help generating pretty ebook files in
various formats directly from arbitrary source trees.

Generate static HTML sites from source trees
--------------------------------------------

Before you begin, ensure you have installed all the [prerequisites](#prerequisites)
(well, don't be scared, just `vim`, `ctags`, and `perl` ;)).

### src2html.pl

The `src2html.pl` script can generate an HTML tree from the source tree that you
specify, for example:

```bash
export PATH=/path/to/code2ebook:$PATH

cd /path/to/your/project/
src2html.pl --color --cross-reference --line-numbers . 'Your Book Title'
```

The resulting HTML site can be viewed in a web browser. And the entry
point is `./index.html` (according to the command above).

The following image shows what a typical HTML page looks like when rendered by a web browser:

![minimal C source file example](http://agentzh.org/misc/image/src2html-main-c2.png)

See [Samples](#samples) for more complicated real-world sample outputs.
Note that, for ebook readers lacking colors (like Amazon Kindle), then
you should not specify the `--color` option for the `src2html.pl` script.

This is essentially an HTML-formatted "ebook", which is readily browsable in
a web browser on either a PC or a tablet.

[Back to TOC](#table-of-contents)

#### Change CSS style

It is worth mentioning that if you do not like the default colors or have further
style requirements, you can just specify the `--css FILE` option to make
the HTML pages
use your own CSS file. You can start with the default CSS file (named `colorful.css`)
in this project.

[Back to TOC](#table-of-contents)

#### Usage

For the full usage of this script, specify the `-h` or `--help` options. One sample
output is

```
src2html.pl [options] dir book-title

Options:
    --charset CHARSET     Specify the charset used by the HTML
                          outputs. Default to UTF-8.

    -c
    --color               Use full colors in the HTMTL outputs.

    --css FILE            Use FILE as the CSS file to render the HTML
                          pages instead of using the default style.

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

    -l
    --line-numbers        Display source code line numbers in the HTML
                          output.

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
2. Colorful syntax highlighting via the `vim` program (enabled by the `--color`
option, or `-c` for short).
3. Cross-reference links to the definition lines of the referenced data types,
macros, global variables, and functions across all the source code lines
(similar to the [LXR Cross Referencer](http://sourceforge.net/projects/lxr/)
but ours is much more lightweight). This is enabled by the `--cross-reference`
option (or the `-x` option for short).

[Back to TOC](#table-of-contents)

#### Source file types recognized

Right now all the file extension names known to your `ctags` program
are supported. But `.html` and `.htm` files are always excluded to avoid
infinite recursion.

For the full language list supported by this tool, just type the following command:

```bash
ctags --list-maps=all
```

You can explicitly include extra source files by specifying as many
`--include=PATTERN` options as you like, as in

```bash
src2html.pl --include='src/*.blah' --include='*foo*' --color . "my project"
```

Similarly, you can also exclude files by specifying one or more
`--exclude=PATTERN` options.

[Back to TOC](#table-of-contents)

Convert the HTML site to ebooks in various formats
--------------------------------------------------

Now that we have the HTML-formatted "ebook", we can generate ebooks in other formats
like `.mobi` and `.epub` using [Calibre](http://calibre-ebook.com/).

[Back to TOC](#table-of-contents)

### Generate MOBI ebooks for Kindle

For example, to generate a `.mobi` file for Kindle DX:

```bash

cd /path/to/your/project/

# assuming we specified the "." directory while running src2html.pl
ebook-convert ./index.html my-project.mobi \
    --output-profile kindle_dx --no-inline-toc \
    --title "Your Book Title" --publisher 'Your Name' \
    --language en --authors 'Your Author Name'
```

In this example, the resulting ebook file is named `my-project.mobi` in the
current working directory.

Note: On OS X you have to go to `Preferences->Advanced->Miscellaneous` and click
`install command line tools` to make the command line tools available after you
installed the app. On other platforms, just start a terminal and type the command.

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
cd /path/to/your/project/

# assuming we specified the "." directory while running src2html.pl
ebook-convert ./index.html my-project.epub \
    --output-profile ipad3 \
    --no-default-epub-cover \
    --title "Your Book Title" --publisher 'Your Name' \
    --language en --authors 'Your Author Name'
```

In this example, the resulting ebook file is named `my-project.epub` in the
current working directory, which is readily readable in apps like `iBooks` on
iPad or iPhone.

[Back to TOC](#table-of-contents)

Prerequisites
=============

You need to install the following dependencies of a recent version (the newer,
the better):

* [Exuberant ctags](http://ctags.sourceforge.net/)

should be readily available in almost all the Linux
distributions by simply installing the `ctags` package.
* [vim](http://www.vim.org/)

should be readily available in almost all the Linux distributions
by simply installing the `vim` package.
* [perl](http://www.perl.org/)

should be readily available in almost all the Linux
distributions by simply installing the `perl` package. It is worth mentioning
that perl 5.10 or above is highly recommended due to performance boost
in the perl regex engine. But older versions of perl should also work as well,
just much slower (like 30x slower).

All these components are very common programs in the \*NIX world.

[Back to TOC](#table-of-contents)

Sample eBooks
=============

Below provides some sample ebooks generated from real-world opensource
projects like [weighttp](#weighttp), [LuaJIT](#luajit), and [Nginx](#nginx).

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

[LuaJIT](http://luajit.org/luajit.html) is a Just-In-Time Compiler (JIT) for
the Lua programming language.
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

Known issues
============

* `vim` is the dominating performance bottleneck when running the `src2html.pl`
tool with the `--color` option.
* When a tag has multiple targets, only the first one is picked up (in the future,
we may provide a middle page listing all the targets for the user to choose,
just as in the [LXR Cross Referencer](http://sourceforge.net/projects/lxr/)).
* The default `ctags` program on Mac OS X is not
[Exuberant ctags](http://ctags.sourceforge.net/), and thus not supported at all.
You can install the right `ctags` utility via [Homebrew](http://brew.sh/),
for example.

[Back to TOC](#table-of-contents)

TODO
====

* Add support for the `--include-only=PATTERN` options to the
[src2html.pl](#src2htmlpl) tool.

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

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

[Back to TOC](#table-of-contents)

See Also
=========

* [LXR Cross Referencer](http://sourceforge.net/projects/lxr/)
* [Exuberant ctags](http://ctags.sourceforge.net/)
* [vim](http://www.vim.org/)

[Back to TOC](#table-of-contents)


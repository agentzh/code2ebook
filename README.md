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
            * [Speed up on multi-core processors](#speed-up-on-multi-core-processors)
            * [HTML output features](#html-output-features)
            * [Source file types recognized](#source-file-types-recognized)
    * [Convert the HTML site to ebooks in various formats](#convert-the-html-site-to-ebooks-in-various-formats)
        * [Generate MOBI ebooks for Kindle](#generate-mobi-ebooks-for-kindle)
        * [Generate EPUB ebooks for iPad/iPhone](#generate-epub-ebooks-for-ipadiphone)
        * [Generate PDF ebooks for Sony Digital Paper](#generate-pdf-ebooks-for-sony-digital-paper)
* [Prerequisites](#prerequisites)
* [Sample eBooks](#sample-ebooks)
    * [weighttp](#weighttp)
    * [LuaJIT](#luajit)
    * [Nginx](#nginx)
    * [GDB](#gdb)
    * [ktap](#ktap)
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
src2html.pl --tab-width 4 --color --cross-reference \
            --navigator --line-numbers . 'Your Book Title'
```

The resulting HTML site can be viewed in a web browser. And the entry
point is `html_out/index.html` (according to the command above).
The default output directory is `./html_out/`, and you can change that
by specifying the `--out-dir=DIR` option (or `-o DIR` for short).

The following image shows what a typical HTML page looks like when rendered by a web browser:

![minimal C source file example](http://agentzh.org/misc/image/src2html-main-c2.png)

See [Sample eBooks](#sample-ebooks) for more complicated real-world sample outputs.

Note that, for ebook readers lacking colors (like Amazon Kindle), then
you should not specify the `--color` option for the `src2html.pl` script.

The output is essentially an HTML-formatted "ebook", which is readily browsable in
a web browser on either a PC or a tablet.

[Back to TOC](#table-of-contents)

#### Change CSS style

It is worth mentioning that if you do not like the default colors or have further
style requirements, you can just specify the `--css FILE` option to make
the HTML pages
use your own CSS file. You can start with the default CSS file (named `default.css`)
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

    --include-only PATTERN
                          Specify the files to be processed and all other
                          files are excluded. This option takes higher
                          priority than "--include PATTERN".

    -j N
    --jobs N              Specify the number of jobs to execute simultaneously.
                          Default to 1. CPAN module Parallel::ForkManager is
                          required when the number is bigger than 1.

    -l
    --line-numbers        Display source code line numbers in the HTML
                          output.

    -n
    --navigator           Generate a navigator bar containing the "Top Level"
                          and "One Level Up" links in the HTML output pages.

    -o DIR
    --out-dir DIR         Specify DIR as the target directory holding the HTML
                          output. Default to "./html_out".

    -t N
    --tab-width N         Specify the tab width (number of spaces) in the
                          source code. Default to 8.

    -x
    --cross-reference     Turn on cross referencing links in the HTML output.

Copyright (C) Yichun Zhang (agentzh) <agentzh@gmail.com>.
```

[Back to TOC](#table-of-contents)

#### Speed up on multi-core processors

You are recommended to use the option `-j N` to speed up on a multi-core
processor when you have a large code base. Just a quick reminder, CPAN module
[Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager) is
required when the number `N` is bigger than 1.

The following example shows that it takes more than 30 minutes with `-j 1` to
generate an HTML tree from the [ngx_openresty-1.9.3.2]
(https://openresty.org/download/ngx_openresty-1.9.3.2.tar.gz) code base. While
it takes less than 3 minutes with `-j 18` to generate the same HTML tree on my
24-core processor.

```console
$ time src2html.pl --navigator --color --cross-reference --line-numbers \
                   -j 1 ngx_openresty-1.9.3.2/bundle openresty-1.9.3.2
...
real    30m43.686s
user    30m26.818s
sys     0m15.420s

$ time src2html.pl --navigator --color --cross-reference --line-numbers \
                   -j 18 ngx_openresty-1.9.3.2/bundle openresty-1.9.3.2
...
real    2m49.172s
user    35m56.337s
sys     0m28.412s
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
src2html.pl --include='src/*.blah' --include='*foo*' . "my project"
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
ebook-convert html_out/index.html my-project.mobi \
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
ebook-convert html_out/index.html my-project.epub \
    --output-profile ipad3 \
    --no-default-epub-cover \
    --title "Your Book Title" --publisher 'Your Name' \
    --language en --authors 'Your Author Name'
```

In this example, the resulting ebook file is named `my-project.epub` in the
current working directory, which is readily readable in apps like `iBooks` on
iPad or iPhone.

[Back to TOC](#table-of-contents)

### Generate PDF ebooks for Sony Digital Paper

For example, to generate a `.pdf` file for Sony Digital Paper:

```bash

cd /path/to/your/project/

# assuming we specified the "." directory while running src2html.pl
ebook-convert html_out/index.html my-project.pdf \
	--override-profile-size \
	--paper-size a4 \
	--pdf-default-font-size 12 \
	--pdf-mono-font-size 12 \
	--margin-left 10 --margin-right 10 \
	--margin-top 10 --margin-bottom 10 \
	--page-breaks-before='/'
```

In this example, the resulting ebook file is named `my-project.pdf` in the
current working directory, which is readily readable in Sony Digital Paper or other e-reader devices supporting PDF ebooks (but you may need to adjust the `--paper-size a4` option if your device screen is too small for A4 pages).

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

* [HTML](http://agentzh.org/misc/code/weighttp/)
* [EPUB](http://agentzh.org/misc/code/weighttp/weighttp.epub)
* [MOBI](http://agentzh.org/misc/code/weighttp/weighttp.mobi)
* [PDF](http://agentzh.org/misc/code/weighttp/weighttp.pdf)

[Back to TOC](#table-of-contents)

LuaJIT
------

[LuaJIT](http://luajit.org/luajit.html) is a Just-In-Time Compiler (JIT) for
the Lua programming language.
Lua is a powerful, dynamic and light-weight programming language.

* [HTML](http://agentzh.org/misc/code/luajit2/)
* [EPUB](http://agentzh.org/misc/code/luajit2/luajit-2.0-src.epub)
* [MOBI](http://agentzh.org/misc/code/luajit2/luajit-2.0-src.mobi)
* [PDF](http://agentzh.org/misc/code/luajit2/luajit-2.0-src.pdf)

[Back to TOC](#table-of-contents)

Nginx
-----

[Nginx](http://nginx.org/) is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3,
and IMAP protocols, as well as a load balancer, HTTP cache, and
a web server (origin server).

* [HTML](http://agentzh.org/misc/code/nginx/)
* [EPUB](http://agentzh.org/misc/code/nginx/nginx-1.7.10.epub)
* [MOBI](http://agentzh.org/misc/code/nginx/nginx-1.7.10.mobi)
* [PDF](http://agentzh.org/misc/code/nginx/nginx-1.7.10.pdf)

[Back to TOC](#table-of-contents)

GDB
---

The GNU Project Debugger.

* [HTML](http://agentzh.org/misc/code/gdb/)
* [EPUB](http://agentzh.org/misc/code/gdb/gdb.epub)

[Back to TOC](#table-of-contents)

ktap
----

ktap is a lightweight script-based dynamic tracing tool for Linux.

* [HTML](http://agentzh.org/misc/code/ktap/)
* [EPUB](http://agentzh.org/misc/code/ktap/ktap.epub)
* [MOBI](http://agentzh.org/misc/code/ktap/ktap.mobi)
* [PDF](http://agentzh.org/misc/code/ktap/ktap.pdf)

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

* Better support for languages like Java.

[Back to TOC](#table-of-contents)

Author
======

Yichun "agentzh" Zhang (章亦春) <agentzh@gmail.com>, CloudFlare Inc.

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2015-2016, by Yichun "agentzh" Zhang, CloudFlare Inc.

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


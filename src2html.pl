#!/usr/bin/env perl

#use Smart::Comments::JSON '##';
use strict;
use warnings;

sub process_dir ($);
sub write_src_html ($$);
sub write_index ($$);
sub shell ($);
sub process_tags ($);
sub add_elem_to_hash ($$$);
sub is_tag_array ($);
sub gen_tag_link_list ($$$$);
sub gen_tag_link ($$$$);
sub extract_line_by_lineno ($$$$);

#my %tag_by_files;
#my %tag_by_names;
my %func_by_files;
my %global_by_files;

my $dir = shift or die "No source directory specified.\n";
my $pkg_name = shift or die "No book title specified.\n";
shell "ctags -n -u --fields=+l --c-kinds=+l -R '$dir'";
process_tags("./tags");
process_dir($dir);

sub shell ($) {
    my $cmd = shift;
    system($cmd) == 0
        or die qq{failed to run command "$cmd": $!\n};
}

sub process_tags ($) {
    my $tagfile = shift;
    open my $in, $tagfile
        or die "cannot open $tagfile for reading: $!\n";
    while (<$in>) {
        next if /^!/;
        if (/^([^\t]+)\s*\t([^\t]+)\t(\d+);"\t(\S+)\tlanguage:(\S+)/) {
            my ($name, $file, $lineno, $kind, $lang) = ($1, $2, $3, $4, $5);
            if ($lang eq 'C++') {
                $lang = 'C';
            }
            #warn "name=$name, file=$file, lineno=$lineno, kind=$kind, lang=$lang\n";
            $name =~ s/^\s+|\s+$//g;
            my $rec = [$name, $file, $lineno, $kind, $lang];
            #add_elem_to_hash(\%tag_by_files, $file, $rec);
            #add_elem_to_hash(\%tag_by_names, $name, $rec);
            if ($kind eq 'f') {
                add_elem_to_hash(\%func_by_files, $file, $rec);

            } elsif ($kind eq 'v') {
                warn "adding global variable $name at $file:$lineno ...\n";
                add_elem_to_hash(\%global_by_files, $file, $rec);
            }

        } else {
            die "Unknown tags file line: ", quotemeta($_);
        }
    }
    close $in;
}

sub add_elem_to_hash ($$$) {
    my ($hash, $key, $val) = @_;
    my $old = $hash->{$key};
    if (!defined $old) {
        $hash->{$key} = $val;

    } elsif (ref $old && ref $old eq 'ARRAY' && !ref $old->[0]) {
        $hash->{$key} = [$old, $val];

    } else {
        push @$old, $val;
    }
}

sub process_dir ($) {
    my $dir = shift;
    opendir my $dh, $dir or die "Can't open $dir for reading: $!\n";
    my @items;
    while (my $entity = readdir($dh)) {
        # entity: $entity
        if (-f "$dir/$entity" && !-l "$dir/$entity"
            && ($entity =~ /^gdbinit|^rx_|\.(?:c(?:pp)?|h|tt|js|pl|php|[ty]|pod|xml|conf|pm6?|lzsql|lzapi|grammar|lua|java|sql|nqp|erl|mq4|rl|xs|go|py|cc|s|dasc|hpp|patch|txt)$/
                || $entity eq 'README'
                || $entity eq 'Makefile'))
        {
            ## file: $entity
            write_src_html($dir, $entity);
            push @items, [file => $entity];

        } elsif (-d "$dir/$entity" && $entity !~ /^\./) {
            ## dir: $entity
            my $count = process_dir("$dir/$entity");
            if ($count) {
                push @items, [dir => $entity];
            }
        }
    }
    close $dh;
    if (@items) {
        write_index($dir, \@items);
    }
    return scalar @items;
}

sub write_src_html ($$) {
    my ($dir, $entity) = @_;

    my $infile = "$dir/$entity";
    #warn "Reading source file $infile\n";

    open my $in, $infile or
        die "Can't open $infile for reading: $!\n";
    my @lineno_index;
    my $src = '';
    my $pos = 0;
    while (<$in>) {
        $lineno_index[$.] = $pos;
        $src .= $_;
        $pos += length;
    }
    close $in;

    my $preamble = '';

    my $tag = $global_by_files{$infile};
    if (defined $tag) {
        $preamble .= <<_EOC_;
 <h4>Global variables defined</h4>
_EOC_
        gen_tag_link_list(\$preamble, $tag, \$src, \@lineno_index);
    }

    $tag = $func_by_files{$infile};
    if (defined $tag) {
        $preamble .= <<_EOC_;
 <h4>Functions defined</h4>
_EOC_
        gen_tag_link_list(\$preamble, $tag, \$src, \@lineno_index);
    }

    if ($preamble) {
        $preamble .= <<_EOC_;
 <h4>Source code</h4>
_EOC_
    }

    if ($src =~ /PRETEND TO BE IN Parse::RecDescent NAMESPACE/s) {
        $src = 'Omitted parser file generated automatically by Parse::RecDescent';
    } else {
        for ($src) {
            s/\n\n\n+/\n\n/gs;
            s/[ \t]+\n/\n/gs;
            s/\t/    /gs;
            s/\&/\&amp;/g;
            s/ /&nbsp;/gs;
            s/</\&lt;/g;
            s/>/\&gt;/g;
            s/"/\&quot;/g;
            s{_SRC2KINDLE_L(\d+)_}{<a id="_L$1"></a>}smg;
            s/\n/<br\/>/g;
        }
    }

    my $outfile = "$dir/$entity.html";
    open my $out, ">$outfile" or
        die "Can't open $outfile for writing: $!\n";
    print $out <<_EOC_;
<html>
 <head>
  <title>$infile - $pkg_name</title>
 </head>
 <body>
  <h3>$infile - $pkg_name</h3>
$preamble
  <code>$src</code>
 </body>
</html>
_EOC_
    close $out;
    warn "Wrote $outfile\n";
}

sub gen_tag_link_list ($$$$) {
    my ($preamble_ref, $tag, $src_ref, $lineno_index) = @_;

    $$preamble_ref .= <<_EOC_;
 <ul>
_EOC_

    if (is_tag_array($tag)) {
        my $tags = $tag;
        @$tags = sort { $a->[0] cmp $b->[0] } @$tags;
        for my $t (@$tags) {
            my $rc = gen_tag_link($preamble_ref, $t, $src_ref, $lineno_index);
            if (!$rc) {
                undef $t;
            }
        }

        for my $t (@$tags) {
            next unless defined $t;
            tag_line_by_lineno($src_ref, $t->[1], $t->[2], $lineno_index);
        }

    } else {
        gen_tag_link($preamble_ref, $tag, $src_ref, $lineno_index);
        tag_line_by_lineno($src_ref, $tag->[1], $tag->[2], $lineno_index);
    }

    $$preamble_ref .= <<_EOC_;
</ul>
_EOC_
}

sub gen_tag_link ($$$$) {
    my ($preamble_ref, $tag, $src_ref, $lineno_index) = @_;
    my $name = $tag->[0];
    my $file = $tag->[1];
    my $lineno = $tag->[2];
    my $lang = $tag->[4];
    if ($lang eq 'C' && $name =~ /^[_A-Z]+$/) {
        # possibly a macro-sugared C function; use the whole line
        $name = extract_line_by_lineno($src_ref, $file, $lineno,
                                       $lineno_index);
        #die "Found line at line $lineno: [$name]";
        if ($name =~ /^\s*case\b.*?:/) {
            return undef;
        }
    }
    $$preamble_ref .= <<_EOC_;
<li><a href="#_L$lineno">$name</a></li>
_EOC_
    return 1;
}

sub extract_line_by_lineno ($$$$) {
    my ($src_ref, $file, $lineno, $lineno_index) = @_;
    my $pos = $lineno_index->[$lineno];
    if (!defined $pos) {
        die "Line $lineno not found in file $file (only seen ",
            scalar(@$lineno), " lines)\n";
    }
    #warn "setting pos to $pos...\n";
    pos $$src_ref = $pos;
    if ($$src_ref =~ /\G[^\n]*/m) {
        my $line = $&;
        #if ($file eq 'src/lib_ffi.c') {
        #warn "$file:$lineno:$pos: [$line]\n";
        #}
        return $line;
    }
}

sub tag_line_by_lineno ($$$$) {
    my ($src_ref, $file, $lineno, $lineno_index) = @_;
    my $pos = $lineno_index->[$lineno];
    if (!defined $pos) {
        die "Line $lineno not found in file $file (only seen ",
            scalar(@$lineno), " lines)\n";
    }
    pos $$src_ref = $pos;
    my $replace = "_SRC2KINDLE_L${lineno}_";
    if ($$src_ref =~ s/\G/$replace/sm) {
        my $offset = length $replace;
        for (my $i = $lineno + 1; 1; $i++) {
            my $pos = $lineno_index->[$i];
            last if !defined $pos;
            $lineno_index->[$i] += $offset;
        }
    }
}

sub is_tag_array ($) {
    my ($t) = @_;
    ref $t && ref $t eq 'ARRAY' && ref $t->[0];
}

sub write_index ($$) {
    my ($dir, $ritems) = @_;
    my $outfile = "$dir/index.html";
    open my $out, ">$outfile" or
        die "Can't open $outfile for writing: $!\n";

    print $out <<_EOC_;
<html>
<head>
 <title>$dir/ - $pkg_name</title>
</head>
<body>
 <h3>$dir/ - $pkg_name</h3>
 <ul>
_EOC_
    for my $item (sort { $a->[1] cmp $b->[1] } @$ritems) {
        my ($type, $entity) = @$item;
        if ($type eq 'file') {
            print $out qq{  <li><a href="$entity.html">$entity</a></li>\n};
        } else {
            print $out qq{  <li><a href="$entity/index.html">$entity/</a></li>\n};
        }
    }
    print $out <<_EOC_;
 </ul>
</body>
</html>
_EOC_
    close $out;
    warn "Wrote $outfile\n";
}


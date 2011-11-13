#!/usr/bin/env perl

#use Smart::Comments::JSON '##';
use strict;
use warnings;

sub process_dir ($);
sub write_src_html ($$);
sub write_index ($$);

my $dir = shift or die "No source directory specified.\n";
my $pkg_name = shift or die "No book title specified.\n";
process_dir($dir);

sub process_dir ($) {
    my $dir = shift;
    opendir my $dh, $dir or die "Can't open $dir for reading: $!\n";
    my @items;
    while (my $entity = readdir($dh)) {
        # entity: $entity
        if (-f "$dir/$entity" && !-l "$dir/$entity"
            && ($entity =~ /^rx_|\.(?:c(?:pp)?|h|tt|js|pl|php|t|pod|xml|conf|pm6?|lzsql|lzapi|grammar|lua|java|sql|nqp|erl|mq4|rl|xs|go)$/
                || $entity eq 'README'))
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
    #my $src;
    open my $in, $infile or
        die "Can't open $infile for reading: $!\n";
    local $/;
    my $src = <$in>;
    close $in;

    if ($src =~ /PRETEND TO BE IN Parse::RecDescent NAMESPACE/s) {
        $src = 'Omitted parser file generated automatically by Parse::RecDescent';
    } else {
        $src =~ s/\n\n\n+/\n\n/gs;
        $src =~ s/[ \t]+\n/\n/gs;
        $src =~ s/\t/    /gs;
        $src =~ s/\&/\&amp;/g;
        $src =~ s/ /&nbsp;/gs;
        $src =~ s/</\&lt;/g;
        $src =~ s/>/\&gt;/g;
        $src =~ s/"/\&quot;/g;
        $src =~ s/\n/<br\/>/g;
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
  <code>$src</code>
 </body>
</html>
_EOC_
    close $out;
    warn "Wrote $outfile\n";
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


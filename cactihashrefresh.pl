#!/usr/bin/perl
###############################################################################
# The MIT License (MIT)
# 
# Copyright (c) 2014 Michael Thorsager
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
###############################################################################
use strict;
use warnings FATAL=> 'all';
use FindBin::Real qw/Script/;
use Digest::MD5 qw/md5_hex/;
use Time::HiRes qw/gettimeofday/;

my $file = shift;
my $nver = shift;

my %hs;
my $hpat = qr/hash_(\d{2})(\d{4})([a-fA-F0-9]{32})/;

if ( !$file ) {
	print STDERR "USAGE: ".Script()." <template-file> [version]\n";
	exit 1;
}

open( FILE, $file ) || die ("Unable to open '$file':$!");
my @c = <FILE>;
close( FILE );
chomp(@c);

foreach my $line ( @c ) {
	my ($type,$version,$hash) = ( $line =~ m/$hpat/ );
	if ( $hash ) {
		if ( !defined($hs{$hash}) ) {
			$hs{$hash} = md5_hex( Script() . gettimeofday() . rand());
			print STDERR "FoundNew: t:$type, v:$version, h:$hash => $hs{$hash}\n";
		}
		my $nv = defined($nver) ? $nver : $version;
		$line =~ s/$type$version$hash/$type$nv$hs{$hash}/g;
	} 
	print $line."\n";
}

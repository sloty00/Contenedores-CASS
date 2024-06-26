#!/usr/bin/perl -w
# nagios: -epn
## pnp4nagios–0.6.26
#
# Copyright (c) 2006-2015 PNP4Nagios Developer Team (http://www.pnp4nagios.org)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#

# There are several Perl modules out there on www.cpan.org which allow adding
# columns to an RRD file, so if this one doesn't fit your needs please have
# a look there.
# Please report any errors nevertheless.
# See http://docs.pnp4nagios.org/pnp-0.6/about#support for details.

use strict;
use warnings;

# you may have to adapt the path to your environment
my $rrdtool = "/usr/bin/rrdtool";
# set to 1 if using PNP4Nagios where data source names are numerical 
my $PNP = 1;

### ---------------------------------------- ###
### no user servicable parts below this line ###

my $pgm     = "rrd_modify.pl";
my $version = "0.01";
my $legal   = "Copyright (c) 2012 PNP4Nagios Developer Team (http://www.pnp4nagios.org)";

my ($rrd,$action,$columns,$type) = @ARGV;
# valid actions
my %action = (insert => 1, delete => 2);
# valid data types
my %type   = (GAUGE => 1, COUNTER => 2, DERIVE => 3, ABSOLUTE => 4, COMPUTE => 5);
# xml tags within cdp_prep
my @cdp    = ('primary_value','secondary_value','value',
              'unknown_datapoints','seasonal','last_seasonal',
              'init_flag','intercept','last_intercept',
              'slope','last_slope','nan_count','last_nan_count');

my @ds     = ();   # number of data sources within the rrd file
my $out    = 1;    # output lines to file
my $sign   = ".";  # decimal sign (locale dependent)
my %xml    = ();   # lines within ds structure

# <rrd file> <action> <start column> defined?
if ($#ARGV < 2) {
	usage();
	exit 1;
}
 
die "$rrd does not exist\n" unless (-f $rrd);
die "$rrd is not readable\n" unless (-r $rrd);
die "$rrd is not writable\n" unless (-w $rrd);
die "$rrdtool is a directory\n" if (-d $rrdtool);
die "$rrdtool does not exist\n" unless (-f $rrdtool);
die "$rrdtool is not executable\n" unless (-x $rrdtool);

$action = lc($action);
unless (exists($action{$action})) {
	print "ERROR: action $action is not valid\n\n";
	usage();
	exit 1;
}

my ($start,$no) = split(/,/,$columns);
$no = 1 unless (defined $no);
# determine the number of data sources
my $ds = `$rrdtool info $rrd | grep '^ds' | grep 'value' | wc -l`;
# determine the decimal sign
$sign = `$rrdtool info $rrd | grep '^ds' | grep 'value' | tail -1`;
($sign) = $sign =~ /.* -?\d(.)\d+/;
my $end = ($action eq "insert" ? $ds+$no : $ds);
if (($start < 1) or ($start > $ds + 1)) {
	print "ERROR: number ($start) must be within 1..".($ds+1)."\n";
	exit 2;
}

# check / set type of data source to be created
if ($action eq "insert") {
	if (defined $type) {
		$type = uc($type);
		unless (exists($type{$type})) {
			print "ERROR: type $type is not valid\n\n";
			usage();
			exit 3;
		}
	} else {
		$type = "GAUGE";
	}
}

# names of temporary/output files
my $tmp1 = "$rrd.in";
my $tmp2 = "$rrd.out";
my $cmd = "$rrdtool dump $rrd > $tmp1";
my $erg = system("$cmd");
print "$cmd: RC=$erg\n" if ($erg);

processing ("$rrd");

$cmd = "$rrdtool restore $tmp2 $rrd.chg";
$erg = system("$cmd");
print "$cmd: RC=$erg\n" if ($erg);
unlink "$tmp1";
unlink "$tmp2";
exit;

### some sub routines

sub processing {
	open (IFILE, "$tmp1") || die "error during open of $tmp1, RC=$!\n";
	open (OFILE, ">$tmp2") || die "error during create of $tmp2, RC=$!\n";
	while (<IFILE>) {
		my $tmp = $_;
		if (/<ds>/) {
			$out = 0;
			%xml = ();
			next;
		}
		if (/<\/ds>/) {
			my %tmp = %xml;
			push @ds, \%tmp;
			next;
		}
		if ((m|Round Robin Archives|) or (m|</cdp_prep>|)) {
			$out = 1;
			if ($action eq "insert") {
				my @save = splice(@ds,$start-1);
				for (1..$no) {
					my %xml = (@save) ? %{$save[0]} : %{$ds[0]};
					$xml{name} = $start+$_-1;
					# set defaults
					if (m|Round Robin Archives|) {
						$xml{last_ds} = "U";
						$xml{value} = "0${sign}0000000000e+00";
						$xml{unknown_sec} = 0;
					} else {
						$xml{primary_value} = "0${sign}0000000000e+00";
						$xml{secondary_value} = "0${sign}0000000000e+00";
						$xml{value} = "NaN" if (exists $xml{value});
						$xml{unknown_datapoints} = 0 if (exists $xml{unknown_datapoints});
						$xml{init_flag} = 1 if (exists $xml{init_flag});
						$xml{seasonal} = "NaN" if (exists $xml{seasonal});
						$xml{last_seasonal} = "NaN" if (exists $xml{last_seasonal});
						$xml{intercept} = "NaN" if (exists $xml{intercept});
						$xml{last_intercept} = "NaN" if (exists $xml{last_intercept});
						$xml{slope} = "NaN" if (exists $xml{slope});
						$xml{last_slope} = "NaN" if (exists $xml{last_slope});
						$xml{nan_count} = 1 if (exists $xml{nan_count});
						$xml{last_nan_count} = 1 if (exists $xml{last_nan_count});
					}
					push @ds,\%xml;
				}
				push @ds,@save;
			} else {
				my @save = splice(@ds,$start-1,$no);
				if ($PNP) { # renumber data source names
					for my $idx ($start..$end-$no) {
						$ds[$idx-1]->{name} = $idx;
					}
				}
			}
			if (m|Round Robin Archives|) {
				out_ds1();
			} else {
				out_ds2();
			}
			print OFILE $tmp;
			@ds = ();
			next;
		}
		if (/<row>/) {
			row($_);
			next;
		}
		# value enclosed in XML tags
		if (/<(\S+)>\s*(\S+)\s*</) {
			$xml{$1} = $2;
		}
		next unless ($out);
		print OFILE $tmp;
	}
	close (IFILE);
	close (OFILE);
}

sub row {
	my $in = shift;
	my ($line,$r) = $in =~ /(.*<row>)(.*)<\/row>/;
	for (1..$start-1) {
		if ($r =~ s#^(<v>.*?</v>)##) {
			$line .= $1;
		}	
	}
	for ($start..$start+$no-1) {
		if ($action eq "insert") {
			$line .= "<v> NaN </v>";
		} else {
			$r =~ s#^(<v>.*?</v>)##;
		}
	}
	for ($start+$no..$end) {
		if ($r =~ s#^(<v>.*?</v>)##) {
			$line .= $1;
		}	
	}	
	$line .= "</row>\n";
	print OFILE $line;
}

sub out_ds1 {
	for (0..$#ds) {
		print OFILE <<EOD;
\t<ds>
\t\t<name> $ds[$_]->{name} </name>
\t\t<type> $ds[$_]->{type} </type>
\t\t<minimal_heartbeat> $ds[$_]->{minimal_heartbeat} </minimal_heartbeat>
\t\t<min> $ds[$_]->{min} </min>
\t\t<max> $ds[$_]->{max} </max>

\t\t<!-- PDP Status -->
\t\t<last_ds> $ds[$_]->{last_ds} </last_ds>
\t\t<value> $ds[$_]->{value} </value>
\t\t<unknown_sec> $ds[$_]->{unknown_sec} </unknown_sec>
\t</ds>

EOD
	}
}

sub out_ds2 {
	for my $ds_no (0..$#ds) {
		print OFILE "\t\t\t<ds>\n";
		for my $tag (0..$#cdp) {
			print OFILE "\t\t\t<$cdp[$tag]> $ds[$ds_no]->{$cdp[$tag]} </$cdp[$tag]>\n" if (exists($ds[$ds_no]->{$cdp[$tag]}));
		}
		print OFILE "\t\t\t</ds>\n";
	}
}

sub usage {
print <<EOD;

   === $pgm $version ===
   $legal

   This script can be used to alter the number of data sources of an RRD file.

   Usage:
   $pgm RRD_file insert|delete start_ds[,no_of_cols] [type] 

   Arguments:
   RRD_file
      the location of the RRD file. It will NOT be overwritten but appended
      by ".chg"
   insert or delete
      the operation to be executed
   start_ds
      the position at which the operation starts (1..no of data sources+1)
   no_of_cols
      (an optional) number of columns which will be added/deleted 
   type
      the data type (one of GAUGE, COUNTER)
		Defaults to GAUGE if not specified for insert operations
        (DERIVE, ABSOLUTE, COMPUTE have not been tested and might result in
		 errors during creation of a new RRD file)
EOD
}

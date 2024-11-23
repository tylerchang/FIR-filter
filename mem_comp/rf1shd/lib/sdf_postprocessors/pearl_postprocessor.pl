#!/usr/bin/perl
# -*- perl -*- Forces EMacs to use perl-mode 

use Getopt::Std; 

&getopts('s:o:');
if(!$opt_s || !$opt_o) {
    die "
pearl_postprocessor.pl  -s <input SDF file>
                        -o <output SFD file>

This perl script modifes an SDF file created by Cadence Pearl.  The script
creates a valid SDF that can be read by Artisan simulation models.


"
}

$IN_FILE = $opt_s;
$OUT_FILE = $opt_o;

open(INPUT, $IN_FILE) || 
    die printf("Sorry, Could not open file %s\n",$IN_FILE);

open(OUTPUT, ">" . $OUT_FILE) ||
    die printf("Sorry, Could not open file %s\n",$OUT_FILE);

#
# This script cuts the posedge statement out of the PERIOD construct
#

while (<INPUT>) {
    chop;
    @var = split;
    if (($_ =~ /PERIOD/) && ($_ =~ /posedge/i)){
	$_ =~ s/\)//i;
	$_ =~ s/\(POSEDGE //i;
        printf OUTPUT "%s\n",$_;
    }elsif(($_ =~ /PERIOD/) && ($_ =~ /negedge/i)){
        #negedge statements are pruned out
        next;
    }else{
	printf OUTPUT "%s\n",$_;
    }
}

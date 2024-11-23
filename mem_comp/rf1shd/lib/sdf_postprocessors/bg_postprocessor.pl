#!/usr/bin/perl
# -*- perl -*- Forces EMacs to use perl-mode 

use Getopt::Std; 

&getopts('s:o:');
if(!$opt_s || !$opt_o) {
    die "
bg_postprocessor.pl  -s <input SDF file>
                     -o <output SFD file>

This perl script modifes an SDF file created by Cadence BuildGates.  The script
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
# and removes the negedge PERIOD statment completely.  It also takes
# care of the case when there are SDTC's.  In this case the "posedge"
# is contained in var[3] instead of var[1].
#

while (<INPUT>) {
    chop;
    @var = split;
    if (@var[0] eq "(PERIOD"){ 
	if ((@var[1] eq "(posedge") || (@var[3] eq "(posedge")){
	    $_ =~ s/\)//i;
	    $_ =~ s/\(POSEDGE //i;
	    printf OUTPUT "%s\n",$_;
	}
	elsif ((@var[1] eq "(negedge") || (@var[3] eq "(negedge")){
	}
	else{
	    printf OUTPUT "%s\n",$_;
	}
    }
#
# The following code removes the posedge statemnts from the
# IOPATH description of memories.
#
    elsif ( ($_ =~ /IOPATH/) && ($_ =~ /posedge/) ){
        $_ =~ s/\(POSEDGE CLK\)/CLK/g;
        $_ =~ s/\(POSEDGE clk\)/clk/g;
        $_ =~ s/\(POSEDGE CLKA\)/CLKA/g;
        $_ =~ s/\(POSEDGE clka\)/clka/g;
        $_ =~ s/\(POSEDGE CLKB\)/CLKB/g;
        $_ =~ s/\(POSEDGE clkb\)/clkb/g;
        $_ =~ s/\(posedge CLK\)/CLK/g;
        $_ =~ s/\(posedge clk\)/clk/g;
        $_ =~ s/\(posedge CLKA\)/CLKA/g;
        $_ =~ s/\(posedge clka\)/clka/g;
        $_ =~ s/\(posedge CLKB\)/CLKB/g;
        $_ =~ s/\(posedge clkb\)/clkb/g;
	printf OUTPUT "%s\n",$_;
    }
#
# The following code removes the first COND statement from SETUP constraints
# which are used for contention checking in dual-port memories and 2 port
# register files.
#
    elsif ( (@var[0] eq "(SETUP") &&
	    (@var[1] eq "(COND") &&
	    ((@var[4] eq "CLKA))") || (@var[4] eq "CLKB))") || (@var[4] eq "clka))") || (@var[4] eq "clkb))"))){
	@var[4] =~ s/\)\)/\)/g;
	printf OUTPUT "    %s %s %s %s %s %s %s %s\n",@var[0],@var[3],@var[4],@var[5],@var[6],@var[7],@var[8],@var[9];
    }
    else{
	printf OUTPUT "%s\n",$_;
    }
}

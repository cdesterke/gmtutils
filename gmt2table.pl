#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# Variables for input and output file names
my $input_file;
my $output_file;

# Parse command line arguments
GetOptions(
    'input=s'  => \$input_file,   # Option for input GMT file
    'output=s' => \$output_file   # Option for output table file (CSV)
) or die "Usage: perl script.pl --input <input_file.gmt> --output <output_file.csv>\n";

# Check if both input and output files are specified
unless ($input_file && $output_file) {
    die "Usage: perl script.pl --input <input_file.gmt> --output <output_file.csv>\n";
}

# Open the input GMT file
open my $in, '<', $input_file or die "Cannot open input file '$input_file': $!";

# Open the output table file
open my $out, '>', $output_file or die "Cannot open output file '$output_file': $!";

# Print column names to the output CSV file
print $out "GeneSet,Description,Gene\n";

# Read the input GMT file line by line
while (my $line = <$in>) {
    chomp $line;
    
    # Skip empty lines
    next if $line =~ /^\s*$/;
    
    # Split the line by tab (tab-separated format of GMT file)
    my @fields = split("\t", $line);
    
    # Get the GeneSet name and description (first two fields)
    my $geneset_name = $fields[0];
    my $description = $fields[1];
    
    # Get the list of genes (remaining fields)
    my @genes = @fields[2..$#fields];
    
    # Write each gene to the output table
    foreach my $gene (@genes) {
        print $out "$geneset_name,$description,$gene\n";
    }
}

# Close the files
close $in;
close $out;

print "Conversion completed. Table file saved as '$output_file'.\n";

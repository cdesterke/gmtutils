#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# Variables for input and output file names
my $input_file;
my $output_file;

# Parse command line arguments
GetOptions(
    'input=s'  => \$input_file,   # Option for input CSV file
    'output=s' => \$output_file   # Option for output GMT file
) or die "Usage: perl script.pl --input <input_file.csv> --output <output_file.gmt>\n";

# Check if both input and output files are specified
unless ($input_file && $output_file) {
    die "Usage: perl script.pl --input <input_file.csv> --output <output_file.gmt>\n";
}

# Open the input CSV file
open my $in, '<', $input_file or die "Cannot open input file '$input_file': $!";

# Open the output GMT file
open my $out, '>', $output_file or die "Cannot open output file '$output_file': $!";

# Initialize a structure to store genes by GeneSet
my %gensets;

# Read the input CSV file line by line
while (my $line = <$in>) {
    chomp $line;
    
    # Skip the header line
    next if $. == 1;
    
    # Split the line by comma (CSV format)
    my ($geneset_name, $description, $gene) = split(",", $line);
    
    # Add the gene to the list of genes for this GeneSet
    push @{ $gensets{$geneset_name}->{genes} }, $gene;
    
    # Add the description if it's not already present for this GeneSet
    if (!exists $gensets{$geneset_name}->{description}) {
        $gensets{$geneset_name}->{description} = $description;
    }
}

# For each GeneSet, write the result to the GMT file
foreach my $geneset (keys %gensets) {
    # Get the description and associated genes
    my $description = $gensets{$geneset}->{description};
    my @genes = @{ $gensets{$geneset}->{genes} };
    
    # Write the line to the GMT file
    print $out "$geneset\t$description\t" . join("\t", @genes) . "\n";
}

# Close the files
close $in;
close $out;

print "Conversion completed. GMT file saved as '$output_file'.\n";

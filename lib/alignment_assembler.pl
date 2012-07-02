#! /usr/bin/perl -w
use DBI;

sub formatted_sequence ( @);

# da li da hardcodiramo path do databaze?

( @ARGV >= 2 )  || die "Usage: $0  <db_name> <protein id> <species> <outfile>.\n"; 

($dbname, $protid, $qry_species, $outname) =   @ARGV; 



($dbh = DBI->connect("DBI:mysql:$dbname", "marioot", "tooiram")) ||
    die "Cannot connect to $dbname.\n";


#####################################################################
# the reference human sequence
$query = "SELECT sequence  FROM protein ".
    "WHERE ensembl_id='$protid'";
$sequence = "";
$sth= prepare_and_exec( $query);
($sequence) = $sth->fetchrow_array;
$rc=$sth->finish;

if (! defined $sequence || ! $sequence ) {

    die "NOTE no human sequence found for $protid\n";
}


$orig_human_seq_lenth = length($sequence);
$all_gaps = "-"x $orig_human_seq_lenth;

#####################################################################
# all species for which we have some (pieces of)  exon  to report
@species_w_exons_found = ();
$query = "SELECT species FROM ortholog WHERE ref_protein_id = '$protid'";
$sth= prepare_and_exec( $query);
%seen = ();
while( ($species) = $sth->fetchrow_array) {

    next if ($species eq "Homo_sapiens");
    if ( ! defined $seen{$species} ) {
	push @species_w_exons_found, $species;
	$seen{$species} = 1;
    }
}
if (!@species_w_exons_found) {
    die  "NOTE no species found for $protid\n";
   
}



@some_info = ();
@some_info = grep { /$qry_species/ } @species_w_exons_found;
	
if  ( ! @some_info ) {
   die "NOTE no matching exons found for $protid in $qry_species.\n";
   
}
    

#####################################################################
# the reference  exon ids
$query = "SELECT ensembl_id FROM exon ".
    "WHERE ref_protein_id='$protid' ".
    "AND species='Homo_sapiens' ".
    "AND source='ensembl'";

$sth= prepare_and_exec( $query);
@ref_exon_ids = ();
while(@row = $sth->fetchrow_array) {
    push @ref_exon_ids, @row;
}
$rc=$sth->finish;

if (!@ref_exon_ids) {
    print "NOTE no ref_exon_ids found for $protid\n";
    next;
}

=pod
    #####################################################################
    # ensembl exons for the remaining species
    foreach $species (  @species ) {
	$query = "SELECT ensembl_id FROM exon ".
	    "WHERE ref_protein_id='$protid' ".
	    "AND species='$qry_species' ".
	    "AND source='ensembl'";

	$sth= prepare_and_exec( $query);
	@ref_exon_ids = ();
	while(@row = $sth->fetchrow_array) {
	    push @ref_exon_ids, @row;
	}
	$rc=$sth->finish;
	foreach $ref_exon_id ( @ref_exon_ids ) {
	    print "$ref_exon_id \n";
	}
    }
=cut



#####################################################################
# the pieces that we have assembled using SW#
%outseq = ();
foreach $species ( 'Homo_sapiens', $qry_species ) {

    @name = split "_", $species;
    $initials = uc ( (substr $name[0], 0, 3).( substr $name[1], 0, 3) );

    #the exons from the queried species
    ($refseq, $specseq, $from, $to)  = ();
    foreach $ref_exon_id ( @ref_exon_ids ) {

	$query = " SELECT ref_protein_seq, spec_protein_seq, ref_prot_start, ref_prot_stop".
	    " FROM exon_alignment_piece   ".
	    " WHERE ref_exon_id='$ref_exon_id' ".
	    " AND species='$species' ";
	$sth= prepare_and_exec( $query);
 
	while( ($refseq, $specseq, $from, $to) = $sth->fetchrow_array) {

	    $length = $to - $from + 1;
	    ( $length < 4 ) && next;

	    $new_seq = $all_gaps;
	    (substr $new_seq, $from, $length) = $specseq;
	    $outseq{$species}{$from}  = ">$initials\_$from\n";
	    $outseq{$species}{$from} .= formatted_sequence($new_seq);
	    $outseq{$species}{$from} .= "\n";

	}
	$rc=$sth->finish;
    }
}

#####################################################################
# finally, output the whole thing;
open (OUT, ">$outname") || die "Cno $outname: $!.\n";

print  OUT ">HS_full\n";
print  OUT formatted_sequence($sequence);
print  OUT  "\n";


foreach $from (0 .. $orig_human_seq_lenth-1) {

    foreach $species ( 'Homo_sapiens', $qry_species ) {

	if ( defined $outseq{$species}{$from}) {
	    print  OUT  $outseq{$species}{$from};
	}
	
    }
}

close OUT;




#untie the databse
$rc=$dbh->disconnect;

############################################################################3


sub prepare_and_exec
{
        my $query=shift;
        my $sth;
        my $rv;
        my $rc;
        $sth=$dbh->prepare($query);
        if (!$sth)
        {
               print "Can't prepare $query\n";
               $rc=$dbh->disconnect;
               die;
        }
        #$sth->trace(2);
        $rv=$sth->execute;
        if (!$rv)
        {
               print "Can't execute $query\n";
               $rc=$dbh->disconnect;
               die;;
        }
        return $sth;
}



sub one_line_query {


    my $sth;

    print "\n*******************************************\n";
    print "QUERY:         $query\n";
    print "RESULTS:             \n";
    $sth= prepare_and_exec( $query);
    while(@row = $sth->fetchrow_array)
    {
        foreach $row (@row)
        {
            print "\t\t $row\n";
        }
    }
}
#############################################################
#############################################################
#############################################################
sub formatted_sequence ( @) {

    my $ctr, 
    my $sequence = $_[0];
    ( defined $sequence) || die "Error: Undefined sequence in formatted_sequence()";
    $ctr = 50;
    while ( $ctr < length $sequence ) { 
	substr ($sequence, $ctr, 0) = "\n";
	$ctr += 51; 
    } 
    
    return $sequence; 
} 

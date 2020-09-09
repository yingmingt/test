#!/usr/bin/perl
die"perl $0 <in> <out>"unless(@ARGV==2);
use Bio::SeqIO;
use Bio::Seq;
use Bio::Tools::SeqStats;
use Bio::Tools::pICalculator;
use Data::Dumper;
#��������
my $in = Bio::SeqIO->new(
-file =>"$ARGV[0]",
-format =>'Fasta'
);

open OUT,">$ARGV[1]"  or die "$!";
print OUT "#ID\tlength\tMV(Da)\tpI\n";
my $calc = Bio::Tools::pICalculator->new(-places =>2,-pKset =>'EMBOSS');
#������ȡ����
while(my $seq = $in->next_seq()) {
my( $id, $sequence, $desc ) = ( $seq->id, $seq->seq, $seq->desc );
my $weight = Bio::Tools::SeqStats ->get_mol_wt($seq);
$calc->seq($seq);
my $iep = $calc->iep;
print OUT sprintf("%s\t%s\t%s\t%s\n",
$seq->id,
$seq->length,
"$weight->[0]",
$iep);
}
$in->close();
close(OUT);

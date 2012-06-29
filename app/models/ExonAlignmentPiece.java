package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="exon_alignment_piece")
public class ExonAlignmentPiece extends Model{
	public String 	ref_exon_id;
	public String 	species;
	public String 	type;
	public String 	ref_protein_seq;
	public String 	spec_protein_seq;
	public String 	ref_dna_seq;
	public String 	spec_dna_seq;
	public int 		ref_prot_start;
	public int 		ref_prot_stop;
	public int 		genome_start;
	public int 		genome_stop;
	public int 		frame;
	public String 	location_id;
}
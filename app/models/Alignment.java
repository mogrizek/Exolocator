package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="alignment")
public class Alignment extends Model{
	public String 	ref_protein_id;
	public int 		ref_ordinal;
	public int 		alignment_ordinal;
	public int 		final_protein_build;
	public String 	species;
	public String 	source;
	public int 		identities;
	public int 		positives;
	public int 		gaps;
	public int 		sbjct_start;
	public int 		sbjct_end;
	public int 		query_start;
	public int 		query_end;
	public int 		length;
	public String 	sbjct_seq;
	public String 	query_seq;
}
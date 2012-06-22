package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="exon")
public class Exon extends Model{
	public String ref_protein_id;
	public int 	  ref_ordinal;
	public int 	  alignment_ordinal;
	public int 	  final_protein_build;
	public String species;
	public String source;
	public String ensembl_id;
	public long   start;
	public long   stop;
	public String sequence;
}

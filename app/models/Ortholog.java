package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="ortholog")
public class Ortholog extends Model{
	public String ref_protein_id;
	public String species;
	public String protein_id;
	public String transcript_id;
	public String gene_id;
}

package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="gene")
public class Gene extends Model{
	public String gene_id;
	public String ref_protein_id;
	public String species;
	public String location_type;
	public String location_id;
	public String strand;
	public long   start;
	public long   stop;
	public long   exp_start;
	public int	  ab_initio;
}

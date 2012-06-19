package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="exon")
public class Exon extends Model{
	public String ensembl_id;
	public int 	  exon_num;
	public String species;
	public String location_on_protein;
	public String location_on_gene;
	public String source;
}

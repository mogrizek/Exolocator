package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="ortholog")
public class Ortholog extends Model{
	public String ensembl_id;
	public String species;
	public String target_ensembl_id;
}

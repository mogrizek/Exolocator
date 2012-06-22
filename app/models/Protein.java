package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="protein")
public class Protein extends Model{
	public String ensembl_id;
	public String sequence;
	public String assembled_sequence;
	public String info;
}
package models;

import java.util.*;

import javax.persistence.*;

import play.db.jpa.*;

@Entity
@Table(name="species")
public class Species extends Model{
	public String latin_name;
	public String english_name;
}
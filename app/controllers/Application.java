package controllers;

import play.*;
import play.data.validation.Required;
import play.libs.Codec;
import play.mvc.*;

import java.io.Console;
import java.util.*;

import models.*;

public class Application extends Controller {

    public static void index() {
    	//List<Protein> proteins = Protein.findAll();
    	//List<Ortholog> proteins = Ortholog.findAll();
    	List<Exon> proteins = Exon.findAll();
        render(proteins);
    }

    @Before
    static void addDefaults() {
        renderArgs.put("applicationTitle", Play.configuration.getProperty("application.title"));
        renderArgs.put("applicationBaseline", Play.configuration.getProperty("application.baseline"));
    }
    
    public static void basicSearch(
    		@Required(message="Ensembl_id is required") String ensembl_id, 
    		@Required(message="Species is required")String species){
    	System.out.println(species);
    	if (species.equalsIgnoreCase("all")) {
        	multipleSpeciesSearch(ensembl_id, findSpeciesWithOrthologs(ensembl_id));
		} else {
			singleSpeciesSearch(ensembl_id, species);
		}
    }
    
    public static void singleSpeciesSearch(String ensembl_id, String species){
    	Ortholog ortholog = Ortholog.find("byEnsembl_idAndSpecies", ensembl_id, species).first();
    	List<Exon> exons = Exon.find("byEnsembl_idAndSpecies", ortholog.target_ensembl_id, species).fetch();
    	render(exons);
    }
    
    public static void multipleSpeciesSearch(String ensembl_id, List<String> species_list){
    	List<List<Exon>> species_exons = new ArrayList<List<Exon>>();
    	for (String species : species_list) {
    		Ortholog ortholog = Ortholog.find("byEnsembl_idAndSpecies", ensembl_id, species).first();
        	List<Exon> exons = Exon.find("byEnsembl_idAndSpecies", ortholog.target_ensembl_id, species).fetch();
        	species_exons.add(exons);
		}
    	render(species_exons);
    }
    
    public static void getSpeciesForProtein(String ensembl_id){
    	System.out.println("USAO!");
    	renderJSON(findSpeciesWithOrthologs(ensembl_id));
    }
    
    public static List<String> findSpeciesWithOrthologs(String ensembl_id){
    	List<Ortholog> orthologs = Ortholog.find("byEnsembl_id", ensembl_id).fetch();
		List<String> species_with_ortholog   = new ArrayList<String>();
    	for (Ortholog ortholog : orthologs) {
    		System.out.println(ortholog.species);
    		species_with_ortholog.add(ortholog.species);
    	}
    	return species_with_ortholog;
    }
}
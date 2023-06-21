package com.fepoc.solr;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class SolrAnalysis {

	private static final String folder = "C:\\Users\\cw22is2\\Workspaces\\FEPDirect\\RestSecurity\\";
	private static final String file_one = folder+"solrfld.prop";
	private static final String file_two = folder+"solr.prop";
	public static void main(String [] args) {
		File one = new File(file_one);
		File two = new File(file_two);
		if(one.exists() && two.exists()) {
			List<String> onel = getString(one);
			List<String> twol = extractString(two);
			List<String> notMatch =compareNotMatch(onel, twol);
			System.out.println("Solr server has the field but application does not use it:-");
			notMatch.stream().forEach(System.out::println);
			List<String> notMatch2 =compareNotMatch(twol, onel);
			System.out.println("Solr server does not have the field but application uses it:-");
			notMatch2.stream().forEach(System.out::println);
		}
		else {
			System.out.println("Files are not found...");
		}
	}
	private static List<String> compareNotMatch(List<String> onel, List<String> twol) {
		return onel.stream().filter(a->!twol.contains(a)).collect(Collectors.toList());
	}
	private static List<String> extractString(File two) {
		List<String> list = new ArrayList<>();
		try(BufferedReader br = new BufferedReader(new FileReader(two))){
			String line;
			while((line=br.readLine())!=null) {
				if(line.contains("=") && line.split("=").length>1) {
					list.add(line.split("=")[1].trim());
				}
			}
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	private static List<String> getString(File one) {
		List<String> list = new ArrayList<>();
		try(BufferedReader br = new BufferedReader(new FileReader(one))){
			String line;
			while((line=br.readLine())!=null) {
				list.add(line.trim());
			}
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
}

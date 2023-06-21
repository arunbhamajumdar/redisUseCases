package com.fepoc.vf.jsr303;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
@Service
public class PatternCache {
	private ConcurrentHashMap<String, Pattern> patternMap = new ConcurrentHashMap<>();
		
//	@Value("${edit.validity.patternCode.fileName}")
	private String patternCodeFileName="C:/Users/cw22is2/Workspaces/FEPDirect/ValidationFramework/src/main/resources/edits/patternedit1.csv";


	
	public PatternCache() {
		init();
	}
	public void init() {
		File file; 
		if(patternCodeFileName!=null && (file=new File(patternCodeFileName)).exists()) {
			try(BufferedReader br = new BufferedReader(new FileReader(file))){
				String line;
				while((line=br.readLine())!=null) {
					String [] cds =line.split(",");
					if(cds.length>1) {
						patternMap.put(cds[0], Pattern.compile(cds[1]));
					}
				}
			} catch (IOException e) {
			}
		}
	}
	public ConcurrentHashMap<String, Pattern> getPatternMap() {
		if(patternMap==null) {
			init();
		}
		return patternMap;
	}
	public void setPatternMap(ConcurrentHashMap<String, Pattern> patternMap) {
		this.patternMap = patternMap;
	}
	
	
}

package com.fepoc.ca;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

public class CobolAnalysis {
	
	private  ExecutorService es = Executors.newFixedThreadPool(10);
	
	public static void main(String [] aergs) {
		CobolAnalysis ca = new CobolAnalysis();
		try(FileWriter sw = new FileWriter(BlockConstant.OUTPUT_FILE)){
			ca.getPrimaryInfo(BlockConstant.FDIR_FOLDER, sw);
			System.out.println("Done...");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void getPrimaryInfo(String inputFolder, Writer descriptionWriter) {
		FilenameFilter filter = new FilenameFilter() {

			@Override
			public boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".cbl");
			}
			
		};
		List<File> list = Arrays.asList(new File(inputFolder).listFiles(filter ));
        Function<File, COBOLFile> f = (a)->{
			try {
				return getCOBOLFile(a);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return null;
		};
        List<COBOLFile> s = populate(list, f);
        //display(s);
        description(descriptionWriter, s);
        findCallModules(s, "FCR");
	}
	
	private void findCallModules(List<COBOLFile> lst, String moduleName) {
		String rlist = lst.stream().filter(a->{
			boolean rslt = false;
			if(a.getBlocks().containsKey(BlockConstant.COBOLConstant.DIV_PROCEDURE)) {
				rslt = a.getBlocks().get(BlockConstant.COBOLConstant.DIV_PROCEDURE).getBlockString().contains(moduleName);
			}
			else if(a.getBlocks().containsKey(BlockConstant.COBOLConstant.DIV_PROCEDURE1)) {
				String s1 =a.getBlocks().get(BlockConstant.COBOLConstant.DIV_PROCEDURE1).getBlockString(); 
				rslt = s1.contains(moduleName);
			}
			return rslt;
		}).map(a->a.getFilename())
		.collect(Collectors.joining("\n"));
		System.out.println(rlist);
	}

	private void description(Writer sw, List<COBOLFile> s) {
        s.stream().forEach(a->{
			try {
				sw.write(a.getFilename()+","+a.WhatIsTheFunction()+", "+a.WhatIsProcessingStep()+","+a.WhatAreCallStatements()+"\n");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		});
	}

	private void display(List<COBOLFile> s) {
        s.stream().forEach(a->a.show());
	}

	public <E,R> List<R> populate(List<E> values, Function<E,R> function) {
        //long t = System.currentTimeMillis();
        List<CompletableFuture<R>> rlist = new CopyOnWriteArrayList<>();
        populate(rlist, es, values, function);
        List<R> slist = rlist.stream().map(CompletableFuture::join).collect(Collectors.toList());
        //System.out.println("Time taken: "+ (System.currentTimeMillis()-t) + " ms");
        //rlist.forEach(System.out::println);
        es.shutdown();
        return slist;
    }
	
	private <E,R> void populate(List<CompletableFuture<R>> rlist, 
            ExecutorService es, List<E> values, Function<E,R> function) {
        List<CompletableFuture<R>> list = values
        .stream()
        .map(a->
        {
            return CompletableFuture.supplyAsync(()->{
                return function.apply(a);
            }, es);
        }).collect(Collectors.toList());
        rlist.addAll(list);
    }
	
	private COBOLFile getCOBOLFile(File input) throws IOException {
		COBOLFile cbfile = new COBOLFile();
		cbfile.process(input);
		return cbfile;
	}
	private String getPrimaryInfo(File input) throws IOException {
		Writer sw = new StringWriter();
		try(BufferedReader br = new BufferedReader(new FileReader(input))){
			boolean calledModules = false;
			StringWriter calledModuless = new StringWriter();
			boolean blocka = false;
			StringWriter blockas = new StringWriter();
			boolean blockb = false;
			StringWriter blockbs = new StringWriter();
			boolean blockc = false;
			StringWriter blockcs = new StringWriter();
			boolean fn = false;
			boolean md = false;
			String line;
			sw.write("\n");
			sw.write(input.getName());
			sw.write(", ");
			while((line=br.readLine())!=null) {
				if(line.contains("WS-TIME")) {
					//System.out.println("");
				}
				if(line.contains("PROGRAM-ID.")) {
					blocka = false;
					blockb = false;
					blockc = false;
					fn = false;
					write(sw, "PROGRAM-ID.",".");
				}
				else if(line.contains("DATA DIVISION.") ||
						line.contains("WS-WORK-AREA.")) {
					blocka = false;
					blockb = false;
					blockc = false;
					fn = false;
				}
				else if(!calledModules & line.contains("CALLED-MODULES.")) {
					calledModules = true;
					continue;
				}
				else if(calledModules & !line.contains("MODULE")) {
					calledModules = false;
					write(sw, calledModuless);
					calledModuless = new StringWriter();
					continue;
				}
				else if(!blocka & line.contains("*========")) {
					blocka = true;
					continue;
				}
				else if(blocka & (line.contains("*========") || line.contains("PROCESSING STEPS:"))) {
					blocka = false;
					if(fn && !"".equals(blockas.toString().trim())) {
						fn=false;
						write(sw, blockas);
						sw.write(", ");
					}
					if(md) {
						write(sw, calledModuless);
						sw.write(", ");
						calledModuless = new StringWriter();
					}
					blockas = new StringWriter();
					continue;
				}
				else if(!blockb & line.contains("*****************")) {
					blockb = true;
					continue;
				}
				else if(blockb & (line.contains("*****************") || line.contains("PROCESSING STEPS:"))) {
					blockb = false;
					if(fn && !"".equals(blockbs.toString().trim())) {
						fn=false;
						write(sw, blockbs);
						sw.write(", ");
					}
					if(md) {
						write(sw, calledModuless);
						sw.write(", ");
						calledModuless = new StringWriter();
					}
					blockbs = new StringWriter();
					continue;
				}
				else if(!blockc & line.contains("PROGRAM:")) {
					sw.write(replace(line));sw.write("; ");
					blockc = true;
					continue;
				}
				else if(blockc & (line.contains("*-*-*-*-*-")
						|| line.contains("*************")  || line.contains("PROCESSING STEPS:"))) {
					blockc = false;
					if(fn && !"".equals(blockcs.toString().trim())) {
						fn=false;
						write(sw, blockcs);
						sw.write(", ");
					}
					if(md) {
						write(sw, calledModuless);
						sw.write(", ");
						calledModuless = new StringWriter();
					}
					blockcs = new StringWriter();
					continue;
				}
				else if(blocka) {
					blockas.write(replace(line));
					blockas.write("\n");
					if(line.contains(" FUNCTION") && !line.contains("= FUNCTION")) {
						fn = true;
					}					
					else if(line.contains(" MOVE") && line.contains("P0M0'")) {
						calledModuless.write(replace(line));
						calledModuless.write(";");
						md = true;
					}					
				}
				else if(blockb) {
					blockbs.write(replace(line));
					blockbs.write("\n");
					if(line.contains(" FUNCTION") && !line.contains("= FUNCTION")) {
						fn = true;
					}					
					else if(line.contains(" MOVE") && line.contains("P0M0'")) {
						calledModuless.write(replace(line));
						calledModuless.write(";");
						md = true;
					}					
				}
				else if(blockc) {
					blockcs.write(replace(line));
					blockcs.write("\n");
					if(line.contains(" FUNCTION") && !line.contains("= FUNCTION")) {
						fn = true;
					}					
					else if(line.contains(" MOVE") && line.contains("P0M0'")) {
						calledModuless.write(replace(line));
						calledModuless.write(";");
						md = true;
					}					
				}
				else if(calledModules) {
					calledModuless.write(replace(line));
					calledModuless.write(";");
				}
			}
		}
		return sw.toString();
	}

	private void write(Writer sw, StringWriter blockas) throws IOException {
		String s = blockas.toString().replace("  ", " ").trim();
		if(!"".equals(s)) {
			sw.write(s.replace("\n", "; "));
		}
	}

	private String replace(String block) { 
		return Arrays.asList(block.split(";")).stream()
		.map(a->{
			int l1 = a.indexOf("*");
			if(l1>-1) {
				a = a.substring(l1+1);
			}
			l1 = a.indexOf("*", l1);
			if(l1>0) {
				a = a.substring(0, l1-1);
			}
			l1 = a.indexOf("000");
			if(l1>0) {
				a = a.substring(0, l1-1);
			}
			return a.trim();
		})
		.collect(Collectors.joining(";"));
	}

	private void write(Writer sw, String string, String string2) {
		// TODO Auto-generated method stub
		
	}	
}

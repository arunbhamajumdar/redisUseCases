package com.fepoc.sec;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class FileSplitter {

	private static final String folder = "C:\\Users\\cw22is2\\OneDrive - FEPOC\\Documents\\hdrive\\archtecture\\pam\\test\\";
	private static final String ifolder = folder.concat("input").concat("\\");
	private static final String ofolder = folder.concat("output").concat("\\");
	private ConcurrentMap<String, BufferedWriter> bwMap = new ConcurrentHashMap<>();
	private static String filename="t1.txt";
    private  ExecutorService es = Executors.newFixedThreadPool(10);
    
	public static void main(String [] args) throws IOException {
		FileSplitter fs = new FileSplitter();
		long tm = System.currentTimeMillis();
		//fs.split(new File(ifolder.concat(filename)));
		fs.splitAll(ifolder);
		//fs.copy(500);
		System.out.println("Time taken: "+(System.currentTimeMillis()-tm));
	}
	
	public void copy(int n) {
		Path opath = Paths.get(ifolder.concat(filename));
		IntStream.range(0, n).forEach(i->
	    {
			try {
				Path cpath = Paths.get(ifolder.concat(String.valueOf(i)).concat("-").concat(filename));
				Files.copy(opath, cpath, StandardCopyOption.REPLACE_EXISTING);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		});		
	}
	public void splitAll(String inputFolder) {
		List<File> list = Arrays.asList(new File(inputFolder).listFiles());
        Function<File, Integer> f = (a)->{
			try {
				return split(a);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return null;
		};
        populate(list, f);
		
	}
	
	public <E,R> void populate(List<E> values, Function<E,R> function) {
        //long t = System.currentTimeMillis();
        List<CompletableFuture<R>> rlist = new CopyOnWriteArrayList<>();
        populate(rlist, es, values, function);
        rlist.stream().map(CompletableFuture::join).collect(Collectors.toList());
        //System.out.println("Time taken: "+ (System.currentTimeMillis()-t) + " ms");
        //slist.forEach(System.out::println);
        es.shutdown();
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
	
	public Integer split(File input) throws IOException {
		try(BufferedReader br = new BufferedReader(new FileReader(input))){
			String line;
			while((line=br.readLine())!=null) {
				if(line.startsWith("+=")) {
					try {
						closeAndOpen(line, input.getName());
					} catch (IOException e) {
					}
				}
				else if(bwMap.containsKey(input.getName())) {
					try {
						bwMap.get(input.getName()).write(line);
						bwMap.get(input.getName()).write("\n");
					} catch (IOException e) {
					}
				}
			}
		}
		if(bwMap.containsKey(input.getName())) {
			bwMap.get(input.getName()).close();
			bwMap.remove(input.getName());
		}
		return 0;
	}
	public Integer split1(File input) throws IOException {
		Files.lines(Paths.get(input.toURI()))
		.forEach(line->{
			if(line.startsWith("+=")) {
				try {
					closeAndOpen(line, input.getName());
				} catch (IOException e) {
				}
			}
			else if(bwMap.containsKey(input.getName())) {
				try {
					bwMap.get(input.getName()).write(line);
					bwMap.get(input.getName()).write("\n");
				} catch (IOException e) {
				}
			}
		});
		if(bwMap.containsKey(input.getName())) {
			bwMap.get(input.getName()).close();
			bwMap.remove(input.getName());
		}
		return 0;
	}
	private void closeAndOpen(String line, String fnm) throws IOException {
		if(bwMap.containsKey(fnm)) {
			try {
				bwMap.get(fnm).close();
			} catch (IOException e) {
			}
		}
		String accountCode = line.substring(5, 8);
		String stationCode = line.substring(11, 15);
		BufferedWriter bw = new BufferedWriter(new FileWriter(ofolder
				.concat(accountCode).concat("-")
				.concat(stationCode).concat("-")
				.concat(fnm)));
		bwMap.put(fnm, bw);
	}
}

package com.fepoc.sec;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.ref.SoftReference;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ColumnerTextFile {

	public static void main(String [] args) throws IOException {
		System.out.println(UUID.randomUUID().toString().length());
//		String folder = "C:\\Users\\cw22is2\\Documents\\tmp\\";
//		File file1 = new File(folder+"tmp1.txt");
//		File ofile = new File(folder+"otmp1.txt");
//		ColumnerTextFile ctf = new ColumnerTextFile();
//		ctf.createFile(file1, "aaaaaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddeeeeeeefffffffffggg33344", 10000);
//		long tm =  System.currentTimeMillis();
//		File file2 = new File(folder+"tmp1.txt");
//		List<Integer> start= Arrays.asList(new Integer[] {50, 13});
//		List<Integer> length= Arrays.asList(new Integer[] {7, 17});;
//		try(FileWriter fw1=new FileWriter(ofile)){
//			ctf.processTextFile(file2 , start, length, fw1);
//		}
//		System.out.println("Time taken: "+(System.currentTimeMillis()-tm));
	}
	public void processTextFile(File file, List<Integer> start, List<Integer> length, FileWriter fw) throws IOException {
		
		Files.lines(Paths.get(file.getCanonicalPath()))
		.map(line->p(line, start, length, 0))
		.map(pline->pline.apply(null))
		.forEach(line->{
			try {
				//String line = pline.apply(null);
				SoftReference<String> sr = new SoftReference<>(line);
				fw.write(line);
				fw.write("\n");
				sr.enqueue();
			} catch (IOException e) {
			}
		});
	}
	
	public Function<?,String> p(String line, List<Integer> start, List<Integer> length, int index) {
		return (a)->removeColumns(line, start, length, index);
	}
	public String removeColumns(String line, List<Integer> start, List<Integer> length, int index) {
		if(index>= start.size()) {
			return line;
		}
		line = line.substring(0, start.get(index)).concat(line.substring(start.get(index)+length.get(index)));
		return removeColumns(line, start, length, index+1);
	}
	
	public void createFile(File file, String line, int repeat) {
		try(FileWriter fw = new FileWriter(file)){
			IntStream.range(0, repeat).forEach(str->
			{
				try {
					fw.write(line);
					fw.write("\n");
				} catch (IOException e) {
				}
			});
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

package com.fepoc.sec;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

public class PrintBinary {
 public static void main(String [] args) {
	 PrintBinary pb = new PrintBinary();
	 pb.print(new File("C:\\tmp\\fcr.mdb"));
 }

private void print(File file) {
	if(file.exists()) {
		try(InputStream is  = new FileInputStream(file)){
			byte [] bytes = readBytes(is);
			System.out.write(bytes);
		} catch (IOException e) {
		}
	}
	else {
		System.out.println("File does not exist.");
	}
}

private byte[] readBytes(InputStream is) throws IOException {
	ByteArrayOutputStream buffer = new ByteArrayOutputStream();

	int nRead;
	byte[] data = new byte[16384];

	while ((nRead = is.read(data, 0, data.length)) != -1) {
	  buffer.write(data, 0, nRead);
	}

	return buffer.toByteArray();	
}
}

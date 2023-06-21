package com.fepoc.ca;

public class BlockUtil {
	public static String removeLineNumber(String line, int slnl, int elnl) {
		if(line.length()>slnl) {
			line = line.substring(slnl);
			if(line.length()>=elnl) {
				line = line.substring(0, line.length()-elnl);
			}
		}
		return line;
	}
}

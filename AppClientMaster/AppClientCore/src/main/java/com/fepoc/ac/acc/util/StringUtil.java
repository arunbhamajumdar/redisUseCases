package com.fepoc.ac.acc.util;

public class StringUtil {

	public static String name(String nm) {
		char c = nm.charAt(0);
		if(c>='a' && c<='z') {
			c = (char)(c - 'a' + 'A');
		}
		return c+nm.substring(1);
	}
}

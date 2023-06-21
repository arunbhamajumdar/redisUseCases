package com.fepoc.ca;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class BlockConstant {
	public static final String LineFeed = String.valueOf("; ");
	public static final String ROOT_FOLDER2 = "C:\\Users\\cw22is2\\Workspaces\\FEPDirect\\RestSecurity\\cbl\\";
	public static final String ROOT_FOLDER1 = "\\\\mfanalyzerp1\\EA Workspaces\\FEPOC_SOURCE\\";
	public static final String ROOT_FOLDER = ROOT_FOLDER1;
	public static final String FDIR_FOLDER1 = ROOT_FOLDER1+ "FDIR\\CMANPR.SERP.MFAX.FDIR.CBL\\";
	public static final String FDIR_FOLDER2 = ROOT_FOLDER2;
	public static final String FDIR_FOLDER = FDIR_FOLDER1;
	public static final String OUTPUT_FILE = "cout1.csv";

	public static class COBOLConstant {
		public static List<String> COMMENT_CHAR = Arrays.asList(new String [] {"*"});
		public static List<String> BLOCK_START_CHAR = Arrays.asList(new String [] {
				"*****************", "*========", "*-*-*-*-*-", "*--------"
		});
		public static List<String> BLOCK_END_CHAR = Arrays.asList(new String [] {
				"*****************", "*========", "*-*-*-*-*-", "*--------"
		});
		public static final String DIV_IDENTIFICATION = "IDENTIFICATION DIVISION.";
		public static final String DIV_ENVIRONMENT = "ENVIRONMENT DIVISION.";
		public static final String DIV_DATA = "DATA DIVISION.";
		public static final String DIV_PROCEDURE1 = "PROCEDURE DIVISION USING";
		public static final String DIV_PROCEDURE = "PROCEDURE DIVISION.";
		
		public static List<String> DIVISION_NAME = Arrays.asList(new String [] {
				DIV_IDENTIFICATION, DIV_ENVIRONMENT, DIV_DATA, DIV_PROCEDURE1, DIV_PROCEDURE
		});
		
		
		public static final String SEC_CONFIG = "CONFIGURATION SECTION.";
		public static final String SEC_IO = "INPUT-OUTPUT SECTION.";
		public static final String SEC_WS = "WORKING-STORAGE SECTION.";
		public static final String SEC_LS = "LINKAGE SECTION.";
		public static List<List<String>> SECTION_NAME = Arrays.asList(
				null,
				Arrays.asList(new String [] {
						SEC_CONFIG, SEC_IO
				}),
				Arrays.asList(new String [] {
						SEC_WS,  SEC_LS
				}),
				null,
				null
		);
		
		public static List<String> COMMAND_BLOCK = Arrays.asList(new String [] {});
		public static Map<String, String> KW_TAG_MAP = Arrays.asList(new String [] {})
				.stream().map(a->a.split(",")).collect(Collectors.toMap(a->a[0], a->a[1]));
		public static Map<String, Pattern> PATTERN_NAME_MAP = Arrays.asList(new String [] {})
				.stream().map(a->a.split(",")).collect(Collectors.toMap(a->a[0], a->Pattern.compile(a[1])));
		public static Map<String, String> PATTERN_TAG_MAP = Arrays.asList(new String [] {})
				.stream().map(a->a.split(",")).collect(Collectors.toMap(a->a[0], a->a[1]));
		
	}
}

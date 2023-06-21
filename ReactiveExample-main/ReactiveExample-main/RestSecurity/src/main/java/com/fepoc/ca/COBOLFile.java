package com.fepoc.ca;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

public class COBOLFile {
	private String filename;
	private int startLineNumberLength;
	private int endLineNumberLength;
	
	private Map<String, Block> blocks;
	
	public String WhatIsTheFunction() {
		StringWriter sw = new StringWriter();
		if(blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION).getBlockTitle()!=null) {
			sw.write(blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION).getBlockTitle());sw.write(BlockConstant.LineFeed);
		}
		String s = blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION)
				.getBlocks().values().stream().filter(b->b.getParameterMap()!=null && b.getParameterMap().containsKey("PROGRAM"))
				.map(m->m.getParameterMap().get("PROGRAM")).findAny().orElse(null);
		if(s!=null) {
			sw.write(s.trim());
		}
		s = blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION)
				.getBlocks().values().stream().filter(b->b.getParameterMap()!=null && b.getParameterMap().containsKey("FUNCTION"))
				.map(m->m.getParameterMap().get("FUNCTION")).findAny().orElse(null);
		if(s!=null) {
			sw.write(s.trim());
		}
		else {
			s = blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION)
					.getBlocks().values().stream().filter(b->b.getParameterMap()!=null && b.getParameterMap().containsKey("FUNCTIONS"))
					.map(m->m.getParameterMap().get("FUNCTIONS")).findAny().orElse(null);
			if(s!=null) {
				sw.write(s.trim());
			}
			
		}	
		if("".equals(sw.toString().trim()) && (
				blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION).getBlockTitle()==null ||
				"".equals(blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION).getBlockTitle()))) {
			sw.write(
					blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION).getBlocks().get("0")
					.getBlockString().replace("*", "").replace("=", "").replace("-", "").trim());
		}
		return sw.toString().replace("\n", BlockConstant.LineFeed);
	}
	
	public String WhatIsProcessingStep() {
		StringWriter sw = new StringWriter();
		String s = blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION)
				.getBlocks().values().stream().filter(b->b.getParameterMap()!=null && b.getParameterMap().containsKey("PROCESSING STEPS"))
				.map(m->m.getParameterMap().get("PROCESSING STEPS")).findAny().orElse(null);
		if(s!=null) {
			sw.write(s);
		}
		return sw.toString().replace("\n", BlockConstant.LineFeed);
	}	
	public String WhatAreCallStatements() {
		StringWriter sw = new StringWriter();
		String s = blocks.get(BlockConstant.COBOLConstant.DIV_IDENTIFICATION)
				.getBlocks().values().stream().filter(b->b.getParameterMap()!=null && b.getParameterMap().containsKey("CALLED PROGRAMS"))
				.map(m->m.getParameterMap().get("CALLED PROGRAMS")).findAny().orElse(null);
		if(s!=null) {
			sw.write(s);
		}
		Map<String, Block> b = blocks.get(BlockConstant.COBOLConstant.DIV_DATA)
				.getBlocks();
		if(b!=null && b.get(BlockConstant.COBOLConstant.SEC_WS)!=null 
				&& b.get(BlockConstant.COBOLConstant.SEC_WS).getBlocks()!=null 
				&& b.get(BlockConstant.COBOLConstant.SEC_WS).getBlocks().get("CALLED-MODULES.")!=null) {
			sw.write(b.get(BlockConstant.COBOLConstant.SEC_WS)
					.getBlocks().get("CALLED-MODULES.").getBlockString());
		}
		
		
		return sw.toString().replace("\n", BlockConstant.LineFeed);
	}	
	
	public void process(File filename) {
		System.out.println(filename);
		this.filename = filename.getName();
		blocks = new HashMap<>();
		try(BufferedReader br = new BufferedReader(new FileReader(filename))){
			String line;
			boolean firstline = true;
			String targetDivision = null;
			while((line=br.readLine())!=null) {
				if(firstline) {
					setLineNumberLength(line);
					firstline = false;
				} 
				targetDivision = getTargetDivision(line, targetDivision);
				blocks.putIfAbsent(targetDivision, new Block());
				blocks.get(targetDivision).addLine(BlockUtil.removeLineNumber(line, startLineNumberLength, endLineNumberLength));
				blocks.get(targetDivision).setIndex(BlockConstant.COBOLConstant.DIVISION_NAME.indexOf(targetDivision));
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		processDivisions();
	}



	private void processDivisions() {
		blocks.values().stream().forEach(a->a.processDivision(startLineNumberLength, endLineNumberLength));
	}

	private String getTargetDivision(String line, String targetDivision) {
		return BlockConstant.COBOLConstant.DIVISION_NAME.stream().filter(a->line.contains(a)).findAny().orElse(targetDivision);
	}

	private void setLineNumberLength(String line) {
		char zero = '0';
		char nine = '9';
		boolean first = true;
		int firstLen = 0;
		char[] cs = line.toCharArray();
		for(char c: cs) {
			if(first && c>=zero && c<=nine) {
				firstLen++;
			}
			else {
				first = false;
			}
		}
		boolean last = true;
		int lastLen = 0;
		for (int i=cs.length-1; i>0; i--) {
			if(last && cs[i]>=zero && cs[i]<=nine) {
				lastLen++;
			}
			else {
				last = false;
			}
			
		}
		this.setStartLineNumberLength(firstLen);
		this.setEndLineNumberLength(lastLen);
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public int getStartLineNumberLength() {
		return startLineNumberLength;
	}

	public void setStartLineNumberLength(int startLineNumberLength) {
		this.startLineNumberLength = startLineNumberLength;
	}

	public int getEndLineNumberLength() {
		return endLineNumberLength;
	}

	public void setEndLineNumberLength(int endLineNumberLength) {
		this.endLineNumberLength = endLineNumberLength;
	}

	public Map<String, Block> getBlocks() {
		return blocks;
	}

	public void setBlocks(Map<String, Block> blocks) {
		this.blocks = blocks;
	}

	public void show() {
		System.out.println(filename);
		this.blocks.entrySet().stream().forEach(a->{
			System.out.println("....."+a.getKey());
			a.getValue().show();
		});
	}


	
}

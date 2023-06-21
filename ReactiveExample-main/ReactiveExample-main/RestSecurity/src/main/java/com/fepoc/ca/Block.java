package com.fepoc.ca;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Block {
	private StringWriter sw = new StringWriter();
	private String blockString;
	private int index;
	private Map<String,String> parameterMap;
	private Map<String, Block> blocks;
	private String blockTitle;

	public void addLine(String line) {
		sw.write(line.trim());
		sw.write("\n");
	}

	public Block processDivision(int slnl, int elnl) {
		blockString = sw.toString();
		sw = null;
		processSections(slnl, elnl);
		return this;
	}

	private void processSections(int slnl, int elnl) {
		blocks = new HashMap<>();
		try(BufferedReader br = new BufferedReader(new StringReader(blockString))){
			String line;
			String targetSection = null;
			while((line=br.readLine())!=null) {
				targetSection = getTargetSection(line, targetSection);
				if(targetSection!=null) {
					blocks.putIfAbsent(targetSection, new Block());
					blocks.get(targetSection).addLine(BlockUtil.removeLineNumber(line, slnl, elnl));
				}
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		processSection(slnl, elnl);
	}
	private void processSection(int slnl, int elnl) {
		if(blocks==null || blocks.isEmpty()) {
			processCommonBlocks(slnl, elnl);
		}
		else {
			blocks.values().stream().forEach(a->{
				a.blockString = a.sw.toString();
				a.sw = null;
				a.processCommonBlocks(slnl, elnl);
				
			});
		}
	}

	private void processCommonBlocks(int slnl, int elnl) {
		blocks = new HashMap<>();
		try(BufferedReader br = new BufferedReader(new StringReader(blockString))){
			String line;
			int index = -1;
			Block blk;
			boolean st = false;
			int ln = 0;
			String lline=null;
			while((line=br.readLine())!=null) {
				if(!st) {
					index = getCommonStartIndex(line);
				}
				if(!st && index>-1) {
					blk = new Block();
					st = true;
					ln = 0;
					blocks.putIfAbsent(String.valueOf(blocks.size()), blk);
				}
				else if(st && ln==1 && line.contains(BlockConstant.COBOLConstant.BLOCK_START_CHAR.get(index))) {
					continue;
				}
				else if(st && (line.contains(BlockConstant.COBOLConstant.BLOCK_END_CHAR.get(index))||
						(line.contains("REMARKS") && line.contains("DATE")))) {
					if(ln>2) {
						st=false;
					}
					else if(ln==2 && blockTitle == null && !blockString.contains("FUNCTION")) {
						blockTitle = lline.replace("*", "").trim();
					}
				}
				if(st) {
					if(!"".equals(line.replace("*", "").trim())) {
						ln++;
						lline = line;
					}
					blocks.get(String.valueOf(blocks.size()-1)).addLine(line.trim());
				}
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		processBlocks();
	}

	private void processBlocks() {
		if(blocks!=null) {
			blocks.values().stream().forEach(a->{
				a.blockString = a.sw.toString();
				a.sw = null;
				a.splitComments();
			});
		}
	}

	private void splitComments() {
		try(BufferedReader br = new BufferedReader(new StringReader(blockString))){
			parameterMap = new HashMap<>();
			String line;
			StringWriter sw = null;
			String tagName = null;
			while((line=br.readLine())!=null) {
				if(line.trim().startsWith("*")) {
					if(line.contains(":") || (
							((line.contains("REMARKS")||line.contains("PROGRAM")) && line.contains("DATE")))
							) {
						if(sw!=null && tagName!=null) {
							parameterMap.put(tagName, removeLines(sw.toString()));
						}
						sw = new StringWriter();
						int r1 = line.indexOf(":");
						int l1 = line.indexOf("*")+1;
						
						if(l1==-1) {
							l1 = line.lastIndexOf(" ", r1);							
						}
						if(((line.contains("REMARKS")||line.contains("PROGRAM")) && line.contains("DATE"))){
							tagName = "PROGRAM HISTORY";
						}
						else {
							tagName = line.substring(l1, r1).trim().toUpperCase();
						}
						sw.write(line.substring(r1+1).trim());
						sw.write("\n");
					}
					
					else if(sw!=null) {
						sw.write(line.trim());
						sw.write("\n");
					}
				}
			}
			if(sw!=null && tagName!=null) {
				parameterMap.put(tagName, removeLines(sw.toString()));
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private String removeLines(String str) {
		StringWriter sw = new StringWriter();
		try(BufferedReader br = new BufferedReader(new StringReader(str))){
			String line;
			while((line=br.readLine())!=null) {
				if(hasChar(line)) {
					sw.write(line.replace("*", "").trim());
					sw.write("\n");
				}
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sw.toString();
	}

	private boolean hasChar(String line) {
		boolean rslt = false;
		char a = 'a';
		char z = 'z';
		char A = 'A';
		char Z = 'Z';
		for(char c: line.toCharArray()) {
			if((c>=a && c<=z)||(c>=A && c<=Z)) {
				rslt = true;
				break;
			}
		}
		return rslt;
	}

	private int getCommonStartIndex(String line) {
		String s = BlockConstant.COBOLConstant.BLOCK_START_CHAR.stream().filter(a->line.contains(a)).findAny().orElse(null);
		return s==null?-1:BlockConstant.COBOLConstant.BLOCK_START_CHAR.indexOf(s);
	}

	private String getTargetSection(String line, String targetSection) {
		if(index==-1 || BlockConstant.COBOLConstant.SECTION_NAME.get(index)==null) {
			return null;
		}
		return BlockConstant.COBOLConstant.SECTION_NAME.get(index).stream().filter(a->line.contains(a)).findAny().orElse(targetSection);
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
//		if(index==4) {
//			System.out.println();
//		}
		this.index = index;
	}

	public void show() {
		System.out.println("Block Title: "+ blockTitle);
		if(this.blocks==null || this.blocks.isEmpty()) {
			System.out.println(blockString);
		}
		else {
			this.blocks.entrySet().stream().forEach(a->{
				System.out.println("....."+a.getKey());
				a.getValue().show();
			});
		
		}		
		if(this.parameterMap!=null && !this.parameterMap.isEmpty()) {
			parameterMap.entrySet().stream().map(a->a.getKey()+"="+a.getValue()).forEach(System.out::println);
		}
	}

	public Map<String, Block> getBlocks() {
		return blocks;
	}

	public Map<String, String> getParameterMap() {
		return parameterMap;
	}

	public String getBlockString() {
		return blockString;
	}

	public String getBlockTitle() {
		return blockTitle;
	}
	
}

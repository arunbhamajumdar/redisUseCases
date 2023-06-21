package com.fepoc.vf.json.parser;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.Stack;

public class JsonParser {

public void parse(StringReader json) throws SyntaxError {
	boolean quoteStarted = false;
	boolean lastActivityQuote = false;
	Stack<JsonBlock> blocks = new Stack<>();
	Stack<String> blockTracker = new Stack<>();
	
	try(BufferedReader br = new BufferedReader(json)){
	String line;
	while((line=br.readLine())!=null) {
	for(char c: line.toCharArray()) {
	if(!quoteStarted && c=='{') {
	blockTracker.add("BS");
	lastActivityQuote = false;
	blocks.add(new JsonBlock());
	}
	else if(!quoteStarted && c=='}') {
	if(!blockTracker.peek().equals("BS")) {
	throw new SyntaxError();
	}
	blockTracker.pop();
	if(lastActivityQuote) {
	blocks.peek().getValues().add(blocks.peek().getNameValueHolder().toString());
	blocks.peek().setNameValueHolder(null);
	}
	lastActivityQuote = false;
	JsonBlock sb = blocks.pop();
	sb.processBlock();
	if(!blocks.isEmpty()) {
	blocks.peek().getBlocks().add(sb);
	}
	}
	else if(!quoteStarted && c=='[') {
	blockTracker.add("AS");
	lastActivityQuote = false;
	blocks.add(new JsonArrayBlock());
	}
	else if(!quoteStarted && c==']') {
	if(!blockTracker.peek().equals("AS")) {
	throw new SyntaxError();
	}
	blockTracker.pop();
	if(lastActivityQuote) {
	blocks.peek().getValues().add(blocks.peek().getNameValueHolder().toString());
	blocks.peek().setNameValueHolder(null);
	}
	lastActivityQuote = false;
	JsonArrayBlock sb = (JsonArrayBlock) blocks.pop();
	sb.processBlock();
	if(!blocks.isEmpty()) {
	blocks.peek().getBlocks().add(sb);
	}
	}
	else if(!quoteStarted && c=='"') {
	lastActivityQuote = false;
	quoteStarted = true;
	blocks.peek().setNameValueHolder(new StringBuilder());
	}
	else if(quoteStarted && c=='"') {
	quoteStarted = false;
	lastActivityQuote = true;
	}
	else if(quoteStarted) {
	blocks.peek().getNameValueHolder().append(c);
	}
	else if(!quoteStarted && c==':') {
	if(lastActivityQuote) {
	blocks.peek().setName(blocks.peek().getNameValueHolder().toString());
	blocks.peek().setNameValueHolder(null);
	}
	}
	else if(!quoteStarted && c==',') {
	if(lastActivityQuote) {
	blocks.peek().getValues().add(blocks.peek().getNameValueHolder().toString());
	blocks.peek().setNameValueHolder(null);
	}
	}
	else {
	blocks.peek().getSb().append(c);
	}
	}
	}
	} catch (IOException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
	}
	}
	
	private String processBlock(StringBuilder sb) {
		// TODO Auto-generated method stub
		return null;
	}
}

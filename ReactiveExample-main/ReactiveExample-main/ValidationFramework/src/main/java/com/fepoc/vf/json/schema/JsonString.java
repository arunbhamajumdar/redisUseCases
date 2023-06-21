package com.fepoc.vf.json.schema;

import java.util.List;
import java.util.Objects;

public class JsonString extends JsonBaseType{

	public JsonString() {
		super(PropertyType.stringT);
	}
	
	private int minLength;
	private int maxLength;
	private String pattern;
	private String format;
	private List<Object> enums;
	private String constantValue;
	private String contentMediaType;
	private String contentEncoding;
	
	public int getMinLength() {
		return minLength;
	}
	public void setMinLength(int minLength) {
		this.minLength = minLength;
		attributes.put("minLength", minLength);
	}
	public int getMaxLength() {
		return maxLength;
	}
	public void setMaxLength(int maxLength) {
		this.maxLength = maxLength;
		attributes.put("maxLength", maxLength);
	}
	public String getPattern() {
		return pattern;
	}
	public void setPattern(String pattern) {
		this.pattern = pattern;
		attributes.put("pattern", pattern);
	}
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
		attributes.put("format", format);
	}
	public List<Object> getEnums() {
		return enums;
	}
	public void setEnums(List<Object> enums) {
		this.enums = enums;
		attributes.put("enums", Objects.nonNull(enums)?enums.toArray():null);
	}
	
	public String getConstantValue() {
		return constantValue;
	}
	public void setConstantValue(String constantValue) {
		this.constantValue = constantValue;
	}
	@Override
	protected String toSchema() {
		// TODO Auto-generated method stub
		return null;
	}
	
	
}

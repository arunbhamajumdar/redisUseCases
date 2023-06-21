package com.fepoc.vf.json.schema;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public abstract class JsonBaseType {
	protected PropertyType type;
	protected ConcurrentMap<String, Object> attributes = new ConcurrentHashMap<>();
	
	protected JsonBaseType (PropertyType type) {
		this.type = type;
	}
	public ConcurrentMap<String, Object> getAttributes() {
		return attributes;
	}
	public void setAttributes(ConcurrentMap<String, Object> attributes) {
		this.attributes = attributes;
	}
		
	
	protected abstract String toSchema();
}

package com.fepoc.vf.json.schema;
import java.util.List;
import java.util.Arrays;
import java.util.concurrent.*;

public enum PropertyType {
	objectT("object", Arrays.asList(new Class<?>[] {ConcurrentMap.class})), 
	arrayT("array", Arrays.asList(new Class<?>[] {CopyOnWriteArrayList.class})), 
	numberT("number", Arrays.asList(new Class<?>[] {Integer.class, Long.class, Float.class, Double.class})), 
	integerT("integer", Arrays.asList(new Class<?>[] {Integer.class, Long.class})), 
	rangeT("range", Arrays.asList(new Class<?>[] {Integer.class})), 
	stringT("string", Arrays.asList(new Class<?>[] {String.class})), 
	booleanT("boolean", Arrays.asList(new Class<?>[] {Boolean.class})), 
	nullT("null", Arrays.asList(new Class<?>[] {Object.class})),
	referenceT("$ref", Arrays.asList(new Class<?>[] {String.class}));
	
	String name;
	List<Class<?>> types;
	
	PropertyType(String name, List<Class<?>> types) {
		this.name = name;
		this.types = types;
	}
}

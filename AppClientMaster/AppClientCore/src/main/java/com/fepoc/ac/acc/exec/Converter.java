package com.fepoc.ac.acc.exec;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import com.fepoc.ac.acc.annotation.TmpEntry;
import com.fepoc.ac.acc.metadata.ClassMetadata;

public class Converter {

	public static <E> Map<String, Object> objectToMap(E obj){
		if(obj==null) return null;
		return ClassMetadata.getGettersMap(obj.getClass())
		.entrySet().stream().map(e->
		{
			try {
				if(ClassMetadata.isIncluded(e.getValue().getReturnType())) {
					Map<String, Object> v1 = Converter.objectToMap(e.getValue().invoke(obj, new Object[] {}));
					return new TmpEntry<>(e.getKey(), v1==null?"NULL":v1);
				}
				else {
					Object v1 = e.getValue().invoke(obj, new Object[] {});
					return new TmpEntry<>(e.getKey(), v1==null?"NULL":v1);
				}
			} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e1) {
			}
			return null;
		}
		)
		.collect(Collectors.toMap(TmpEntry::getKey, TmpEntry::getValue));
	}

	public static <E> E mapToObject(Map<String, Object> map, Class<E> cls) {
		E e = null;
		try {
			e = cls.newInstance();
			mapToObject(map, e);
		} catch (InstantiationException | IllegalAccessException ex) {
		}
		return e;
	}	
	
	public static <E> void mapToObject(Map<String, Object> map, E e) {
		Map<String, Method> setterMap = ClassMetadata.getSettersMap(e.getClass());
		map.entrySet().forEach(ent->load(e, ent.getKey(), ent.getValue(), setterMap.get(ent.getKey())));
	}
	
	@SuppressWarnings("unchecked")
	public static <E> void load(E obj, String key, Object value, Method mth) {
		try {
			value = "NULL".equals(value)?null:value;
			if(Objects.nonNull(value) 
					&& ClassMetadata.isIncluded(mth.getParameterTypes()[0]) 
					&& (Map.class.isInstance(value) || HashMap.class.isInstance(value))) {
				Object param = mth.getParameterTypes()[0].newInstance();
				mapToObject((Map<String, Object>)value, param);
				mth.invoke(obj, new Object[] {param});			
			}
			else {
				mth.invoke(obj, new Object[] {value});			
			}
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e1) {
		} catch (InstantiationException e) {
		}
		
	}
	
}


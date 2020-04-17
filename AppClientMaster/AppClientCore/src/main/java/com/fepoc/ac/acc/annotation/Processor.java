package com.fepoc.ac.acc.annotation;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

import org.reflections.Reflections;
import org.reflections.scanners.ResourcesScanner;
import org.reflections.scanners.SubTypesScanner;
import org.reflections.scanners.TypeAnnotationsScanner;
import org.reflections.util.ClasspathHelper;
import org.reflections.util.ConfigurationBuilder;
import org.reflections.util.FilterBuilder;

import com.fepoc.ac.acc.util.StringUtil;

public class Processor {
	public final static String METHOD_GET = "get";
	public final static String METHOD_SET = "set";
	private Reflections ref;
	
	public void setRef(Package pkg) {
//		List<ClassLoader> classLoadersList = new LinkedList<ClassLoader>();
//		classLoadersList.add(ClasspathHelper.contextClassLoader());
//		classLoadersList.add(ClasspathHelper.staticClassLoader());
		ref = new Reflections(
				new ConfigurationBuilder()
//				.addClassLoaders(new ClassLoader[] {
//						classLoadersList.get(0),
//						pkg.getClass().getClassLoader(),
//						Cacheable.class.getClassLoader()
//				})
				.setUrls(ClasspathHelper.forPackage(pkg.getName()))
				.setScanners(
		    		new SubTypesScanner(),
		    		new TypeAnnotationsScanner(), 
		    		new ResourcesScanner())
				.setExecutorService(Executors.newFixedThreadPool(2))
		    );	
		//System.out.println("1.................."+pkg.getName());
		//ref.getAllTypes().stream().forEach(System.out::println);
		
	}
	public Set<Class<?>> getClasses(Package pkg){
		
		if(ref==null) {
			setRef(pkg);
		}
		return ref.getTypesAnnotatedWith(Cacheable.class);
	}
	
	public Set<Field> getFields(Class<?> cls){	
		Set<Field> allfields = new HashSet<>(
			Arrays.asList(cls.getDeclaredFields())
			.stream().filter(fld->fld.getAnnotation(DontCache.class)==null)
			.collect(Collectors.toList())
		);
		return allfields;
	}
	
	public Map<String, Method> getGetterMethods(Class<?> cls, Set<Field> fields){
		return fields.stream()
				.map(fld->getterMethod(cls, fld))
				.filter(mth->mth!=null)
				.collect(
						Collectors.toMap(
								ent->((Map.Entry<String, Method>)ent).getKey(), 
								ent->((Map.Entry<String, Method>)ent).getValue()
						)
				);
	}
	public Map<String, Method> getSetterMethods(Class<?> cls, Set<Field> fields){
		return fields.stream()
				.map(fld->setterMethod(cls, fld))
				.filter(mth->mth!=null)
				.collect(
						Collectors.toMap(
								ent->((Map.Entry<String, Method>)ent).getKey(), 
								ent->((Map.Entry<String, Method>)ent).getValue()
						)
				);
	}	
	public Entry<String, Method> getterMethod(Class<?> cls, Field fld) {
		Entry<String, Method> ent=null;
		try {
			ent = new TmpEntry<>(fld.getName(), cls.getDeclaredMethod(METHOD_GET.concat(StringUtil.name(fld.getName())), new Class<?>[] {}));
		} catch (NoSuchMethodException | SecurityException e) {
		}
		return ent;
	}
	public Entry<String, Method> setterMethod(Class<?> cls, Field fld) {
		Entry<String, Method> ent=null;
		try {
			ent = new TmpEntry<>(fld.getName(), cls.getDeclaredMethod(METHOD_SET.concat(StringUtil.name(fld.getName())), new Class<?>[] {fld.getType()}));
		} catch (NoSuchMethodException | SecurityException e) {
		}
		return ent;
	}	

	
}

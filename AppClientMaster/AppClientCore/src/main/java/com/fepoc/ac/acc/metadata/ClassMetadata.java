package com.fepoc.ac.acc.metadata;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

import com.fepoc.ac.acc.annotation.Processor;
import com.fepoc.ac.acc.annotation.TmpEntry;
import com.fepoc.ac.acc.exec.FasterRun;

public final class ClassMetadata {
	//private ClassMetadata() {}
	public Map<Class<?>, Map<String, Method>> metadataGetMap;
	public Map<Class<?>, Map<String, Method>> metadataSetMap;
	public static ClassMetadata instance;
	
	public void load() {
		String packages = System.getProperty("cache.packages");
		if(Objects.nonNull(packages)) {
			List<Package> pkgs = Arrays.asList(packages.split(",")).stream()
			.map(pnm->Package.getPackage(pnm)).collect(Collectors.toList());
			Function<Package,Map<Class<?>, Map<String, Method>>> getter = (pkg)->loadGetter(pkg);
			Function<Package,Map<Class<?>, Map<String, Method>>> setter = (pkg)->loadSetter(pkg);
		    FasterRun<Package,Map<Class<?>, Map<String, Method>>> fr = new FasterRun<>();
		    metadataGetMap = fr.newRun().populate(pkgs, getter).stream()
					.flatMap(e->e.entrySet().stream()).collect(Collectors.toMap(Entry::getKey, Entry::getValue));
		    metadataSetMap = fr.populate(pkgs, setter).stream()
					.flatMap(e->e.entrySet().stream()).collect(Collectors.toMap(Entry::getKey, Entry::getValue));
		    fr.down();
		}
	}
	
	public Map<Class<?>, Map<String, Method>> loadGetter(Package pkg){
		Processor proc = new Processor();
		return proc.getClasses(pkg).stream()
				.map(cls->new TmpEntry<Class<?>, Map<String, Method>>(
						cls, proc.getGetterMethods(cls, proc.getFields(cls))))
				.collect(Collectors.toMap(TmpEntry::getKey, TmpEntry::getValue));
	}
	public Map<Class<?>, Map<String, Method>> loadSetter(Package pkg){
		Processor proc = new Processor();
		return proc.getClasses(pkg).stream()
				.map(cls->new TmpEntry<Class<?>, Map<String, Method>>(
						cls, proc.getSetterMethods(cls, proc.getFields(cls))))
				.collect(Collectors.toMap(TmpEntry::getKey, TmpEntry::getValue));
	}	
	public static ClassMetadata getInstance() {
		if(instance==null) {
			instance = new ClassMetadata();
			instance.load();
		}
		return instance;
	}
	
	public static boolean isIncluded(Class<?> cls) {
		return getGettersMap(cls)!=null;
	}
	
	public static Map<String, Method> getGettersMap(Class<?> cls){
		ClassMetadata cmdt = getInstance();
		return cmdt.metadataGetMap.get(cls);
	}
	public static Map<String, Method> getSettersMap(Class<?> cls){
		ClassMetadata cmdt = getInstance();
		return cmdt.metadataSetMap.get(cls);
	}	
}

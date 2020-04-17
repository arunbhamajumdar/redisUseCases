package com.fepoc.biz.tc;
import java.lang.reflect.Method;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.fepoc.ac.acc.metadata.ClassMetadata;
import com.fepoc.ac.acc.metadata.EnableLoading;
import com.fepoc.biz.tc.domain.Test1;
@Component
public class EnableCacheLoader implements EnableLoading{

	EnableCacheLoader(){
		load();
	}
	
	@Override
	public String getApplicationName() {
		return "Business App Test Cache";
	}

	@Override
	public String getApplicationVersion() {
		return "1.0";
	}

	@Override
	public Map<Class<?>, String> getTags() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void load() {
		System.setProperty("cache.packages", Test1.class.getPackage().getName());
		long tm = System.currentTimeMillis();
		Map<String, Method> x = ClassMetadata.getGettersMap(Test1.class);
		System.out.println("Time taken: "+(System.currentTimeMillis()-tm)+" ms.");
		System.out.println(x.size());
		x.entrySet().stream().map(a->a.getKey()+"..."+a.getValue().getName()).forEach(System.out::println);	
	}

}

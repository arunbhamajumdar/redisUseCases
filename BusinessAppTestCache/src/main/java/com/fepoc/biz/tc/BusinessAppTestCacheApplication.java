package com.fepoc.biz.tc;

import java.util.Map;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.fepoc.ac.acc.exec.Converter;
import com.fepoc.biz.tc.domain.Test1;
import com.fepoc.biz.tc.domain.Test2;

@SpringBootApplication
public class BusinessAppTestCacheApplication {

	public static void main(String[] args) {
		SpringApplication.run(BusinessAppTestCacheApplication.class, args);
		Map<String, Object> map = test();
		test1(map);
	}

	public static Test1 test1(Map<String, Object> map) {
		long tm1 = System.currentTimeMillis();
		Test1 tst1 = Converter.mapToObject(map, Test1.class);
		System.out.println("Populate Time:"+(System.currentTimeMillis()-tm1));
		System.out.println(tst1.getAddress().getStreetAddress());
		return tst1;
	}
	public static Map<String, Object> test() {
		
		Test1 t1 = new Test1();
		Test2 t2 = new Test2();
		t1.setAge(32);
		t1.setName("Shyam");
		t2.setStreetAddress("13604 Northbourne Dr.");
		t1.setAddress(t2);
		long tm = System.currentTimeMillis();
		Map<String, Object> v1 = Converter.objectToMap(t1);
		System.out.println("Convert Time taken: "+(System.currentTimeMillis()-tm)+" ms.");
		v1.entrySet().stream().map(a->a.getKey()+"..."+a.getValue()).forEach(System.out::println);
		return v1;
	}
	
	
}

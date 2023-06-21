package com.fepoc.biz.tc;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import javax.annotation.PostConstruct;

import com.fepoc.ac.acc.exec.Converter;
import com.fepoc.ac.acc.exec.FasterRun;
import com.fepoc.ac.acn.client.ClientConnector;
import com.fepoc.biz.tc.domain.Test1;
import com.fepoc.biz.tc.domain.Test2;

@SpringBootApplication
public class BusinessAppTestCacheApplication {
	@Autowired
	private ClientConnector client;

	public static void main(String[] args) {
		SpringApplication.run(BusinessAppTestCacheApplication.class, args);
	}

	@PostConstruct
	public void test() {
		System.setProperty("cache.packages", Test1.class.getPackage().getName());
		Map<String, Object> map = test2();
		test1(map);		
	}
	
	@Bean
	public ClientConnector getClient() {
		return new ClientConnector();
	}
	public Test1 test1(Map<String, Object> map) {
		long tm1 = System.currentTimeMillis();
		Test1 tst1 = Converter.mapToObject(map, Test1.class);
		System.out.println("Populate Time:"+(System.currentTimeMillis()-tm1));
		System.out.println(tst1.getAddress().getStreetAddress());
		return tst1;
	}
	public Integer connect(Integer i) {
		long tm = System.currentTimeMillis();
		client.connect();
		System.out.println("TT: ["+i+"]: "+ (System.currentTimeMillis()-tm)+" ms");
		return 0;
	}
	public Map<String, Object> test2() {
		FasterRun<Integer, Integer> fr = new FasterRun<>();
		Function<Integer, Integer> fn = (i)->connect(i);
		fr.newRun().populate(IntStream.range(0, 100).mapToObj(i->i).collect(Collectors.toList()), fn );
		fr.down();
		
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

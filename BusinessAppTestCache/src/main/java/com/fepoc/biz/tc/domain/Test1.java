package com.fepoc.biz.tc.domain;

import com.fepoc.ac.acc.annotation.CacheKey;
import com.fepoc.ac.acc.annotation.Cacheable;
import com.fepoc.ac.acc.annotation.Client;
import com.fepoc.ac.acc.annotation.DontCache;

@Cacheable
public class Test1 {
	@CacheKey(order=1)
	private String name;
	@DontCache
	private int age;
	
	@Client
	private String planCode;
	
	private Test2 address;
	
	public Test2 getAddress() {
		return address;
	}
	public void setAddress(Test2 address) {
		this.address = address;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}

}

package com.fepoc.domain;

public class TestCloneing {

	public static void main(String [] args) {
		ClassB b1 = new ClassB("Arun", 53);
		ClassA a1 = new ClassA();
		try {
			a1.setClassB(b1.clone());
			b1.setName("Arunabha");			
		} catch (CloneNotSupportedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(a1.getClassB().getName());
	}
}

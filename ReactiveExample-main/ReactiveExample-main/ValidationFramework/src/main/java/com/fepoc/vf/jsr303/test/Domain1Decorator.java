package com.fepoc.vf.jsr303.test;

import com.fepoc.vf.jsr303.DirectPattern;

public class Domain1Decorator{
	private Domain1 domain1;

	public Domain1Decorator(Domain1 domain1) {
		this.domain1 = domain1;
	}
	
	@DirectPattern(patternCode = "PT01", message="Test1", partial=false)
	public String getS1() {
		return domain1.getS1();
	}

}

package com.fepoc.vf.jsr303.test;

import org.springframework.validation.annotation.Validated;

import com.fepoc.vf.jsr303.DirectPattern;
import com.fepoc.vf.jsr303.FullValidation;
import com.fepoc.vf.jsr303.PartialValidation;
@Validated
public class Domain1 {

	private String s1;

	public Domain1() {
		
	}
	@DirectPattern.List({
		@DirectPattern(patternCode = "PT01", groups=PartialValidation.class, partial=true, message="MSG01"),
		@DirectPattern(patternCode = "PT01", groups=FullValidation.class, partial=false, message="MSG01")
	})
	public String getS1() {
		return s1;
	}
	public void setS1( String s1) {
		this.s1 = s1;
	}
	
	
	
}

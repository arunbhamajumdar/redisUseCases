package com.fepoc.vf.jsr303;

import java.util.regex.Matcher;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import javax.validation.constraintvalidation.SupportedValidationTarget;
import javax.validation.constraintvalidation.ValidationTarget;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.auto.service.AutoService;

//@AutoService(ConstraintValidator.class)
@Component
//@SupportedValidationTarget(ValidationTarget.PARAMETERS)
public class DirectPatternValidator implements
ConstraintValidator<DirectPattern, String>{

	@Autowired
	private PatternCache patternCache;
	
	private java.util.regex.Pattern pattern;

	private DirectPattern directPattern;
	
	@Override
	public void initialize(DirectPattern directPattern) {
		this.directPattern = directPattern;
		pattern = new PatternCache().getPatternMap().get(directPattern.patternCode());
	}

	@Override
	public boolean isValid(String arg0, ConstraintValidatorContext arg1) {
		System.out.println("Is partial? "+directPattern.partial());
		if(arg0==null) {
			return directPattern.partial();
		}
		else {
				Matcher matcher = pattern.matcher(arg0.toString());
		        if(matcher.matches()){
		            return true;
		        }			
		}
		return false;
	}

	public String getMessage() {
		return directPattern.message();
	}

}
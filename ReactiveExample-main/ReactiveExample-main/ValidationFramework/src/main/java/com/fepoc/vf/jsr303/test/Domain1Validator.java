package com.fepoc.vf.jsr303.test;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.ValidatorFactory;
import javax.validation.metadata.BeanDescriptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.CustomValidatorBean;

import com.fepoc.vf.jsr303.DirectPattern;
import com.fepoc.vf.jsr303.DirectPatternValidator;
@Component
public class Domain1Validator extends CustomValidatorBean{

	private static final String ANNOTATION_METHOD = "getDeclaredAnnotationMap";
	@Autowired
	DirectPatternValidator dpValidator;
	
	public Domain1Validator() {
		super.afterPropertiesSet();
	}
	
	@Override
	public boolean supports(Class<?> clazz) {
		return Domain1.class==clazz;
	}


//	@Override
//	public void validate(Object target, Errors errors) {
//		
//        ValidatorFactory validatorFactory = Validation.buildDefaultValidatorFactory();
//        
//        javax.validation.Validator validator = validatorFactory.usingContext().getValidator();
//        //BeanDescriptor x = validator.getConstraintsForClass(DirectPatternValidator.class);
//		//validator.validate(new DirectPatternValidator(), Void.class);
//		Set<ConstraintViolation<Domain1>> constrains = validator.validate((Domain1)target);
//	    for (ConstraintViolation<Domain1> constrain : constrains) {
//
//	       System.out.println(
//	      "[" + constrain.getPropertyPath() + "][" + constrain.getMessage() + "]"
//	      );
//
//	    }	
//	    
//		//super.afterPropertiesSet();
//		//super.validate(target, errors);
//		//ValidationUtils.invokeValidator(this, target, errors);
//		//ValidationUtils.rejectIfEmptyOrWhitespace(errors, "s1", "s1.directPattern");
//		//ValidationUtils.rejectIfEmptyOrWhitespace(errors, "role", "role.required");	
//	}

}

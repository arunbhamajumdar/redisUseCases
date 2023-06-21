package com.fepoc.vf;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;

//import com.fepoc.vf.jsr303.DirectPattern;
//import com.fepoc.vf.jsr303.FullValidation;
//import com.fepoc.vf.jsr303.NoValidation;
//import com.fepoc.vf.jsr303.FullValidation;
//import com.fepoc.vf.jsr303.PartialValidation;
//import com.fepoc.vf.jsr303.test.AnnotationHelper;
//import com.fepoc.vf.jsr303.test.Domain1;
//import com.fepoc.vf.jsr303.test.Domain1Decorator;
//import com.fepoc.vf.jsr303.test.Domain1Validator;

@SpringBootApplication
@ComponentScan(basePackages="com.fepoc.vf") //, com.fepoc.vf.jsr303
public class ValidationFrameworkApplication {

//	@Autowired
//	Domain1Validator validator;
	
	public static void main(String[] args) {
		SpringApplication.run(ValidationFrameworkApplication.class, args);
	}
//	@PostConstruct
//	public void test1() {
//		Domain1 d1 = new Domain1();
//		d1.setS1(null);
//		validate(d1, FullValidation.class);
//		validate(d1, PartialValidation.class);
//	}
//	
//	void validate(Object target, Class<?> cls){
//		DirectPattern dd = target.getClass().getAnnotation(DirectPattern.class);
//		//AnnotationHelper.alterAnnotationOn(Domain1.class, DirectPattern.class, new FullValidator(dd));
//		Errors errors = new BeanPropertyBindingResult(target,"Domain1");
//		validator.validate(target, errors, cls );	
//		System.out.println("...Error Count="+errors.getErrorCount());
//		
//	}
	
//	@Bean 
//	public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
//	return new PropertySourcesPlaceholderConfigurer();
//	}



}

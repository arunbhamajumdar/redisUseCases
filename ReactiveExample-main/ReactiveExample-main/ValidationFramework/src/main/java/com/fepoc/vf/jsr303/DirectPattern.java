package com.fepoc.vf.jsr303;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.constraintvalidation.SupportedValidationTarget;

/**
* Validate a Pattern for a given country
* The only supported type is String
*/
@Documented
@Constraint(validatedBy = DirectPatternValidator.class)
@Target({ ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface DirectPattern {
	String patternCode();
	boolean partial() default true;
	String message() default "{com.fepoc.vf.pattern.message}";
	Class<?>[] groups() default {};
	Class<? extends Payload>[] payload() default {};
	/**
	* Defines several @DirectPattern annotations on the same element
	* @see (@link DirectPattern}
	*/
	@Target({ ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER })
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@interface List {
		DirectPattern[] value();
	}
}
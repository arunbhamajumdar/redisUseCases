package com.fepoc.vf.jsr303.visitor;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;

@Documented
@Inherited
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = BaseValidator.class)
public @interface BaseValidation {
	
    String message () default "";
    Class<?>[] groups () default {};
    Class<? extends Payload>[] payload () default {};
    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.TYPE, ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE})
    public @interface Version {
    	int majorNumber();
    	int minorNumber();
    	String change();
    }
    @interface List {
    	BaseValidation[] value();
    }
}
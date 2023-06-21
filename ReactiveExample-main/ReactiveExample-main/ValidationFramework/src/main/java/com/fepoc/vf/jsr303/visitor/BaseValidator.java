package com.fepoc.vf.jsr303.visitor;
import javax.validation.ConstraintValidator;

public abstract class BaseValidator implements ConstraintValidator<BaseValidation, Object[]> {

	@Override
	public void initialize(BaseValidation validation) {

	}


}
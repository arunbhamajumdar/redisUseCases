package com.fepoc.vf.jsr303;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

public class PartialValidator<E> implements Validator{
	private E e;
	public PartialValidator(E e) {
		this.e = e;
	}
	@Override
	public boolean supports(Class<?> clazz) {
		return clazz==e;
	}

	@Override
	public void validate(Object target, Errors errors) {
		// TODO Auto-generated method stub
		
	}

}

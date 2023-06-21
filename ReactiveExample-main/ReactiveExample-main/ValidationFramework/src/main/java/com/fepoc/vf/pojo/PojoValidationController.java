package com.fepoc.vf.pojo;

import java.util.List;
import java.util.stream.Stream;

import com.fepoc.vf.ValidationInterface;
import com.fepoc.vf.ValidationResponse;
import com.fepoc.vf.metadata.edit.BaseEditFunction;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public class PojoValidationController<T extends BaseEditFunction> implements ValidationInterface<T>{

	@Override
	public <E> Mono<ValidationResponse<T>> validate(List<E> elist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <E> Flux<ValidationResponse<T>> validate(Stream<E> elist) {
		// TODO Auto-generated method stub
		return null;
	}

}

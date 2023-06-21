package com.fepoc.vf;

import java.util.List;
import java.util.stream.Stream;

import com.fepoc.vf.metadata.edit.BaseEditFunction;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ValidationInterface<T extends BaseEditFunction> {
	<E> Mono<ValidationResponse<T>> validate(List<E> elist);
	<E> Flux<ValidationResponse<T>> validate(Stream<E> elist);
}

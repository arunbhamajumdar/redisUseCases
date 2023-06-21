package com.fepoc.cf.user.api;

import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;

import reactor.core.publisher.Mono;
import reactor.util.function.Tuple2;
@RestController
public class UserController {

	@GetMapping(value="/login")
	public void findCurrentUser(ServerWebExchange session) {
		System.out.println("Finding current user - ");
		Mono<Object> x = ReactiveSecurityContextHolder.getContext()
        .map(SecurityContext::getAuthentication)
        .map(Authentication::getPrincipal)
        .zipWith(session.getFormData())
        .doOnNext(tuple -> {    
        	System.out.println(tuple);
        })
        .map(Tuple2::getT1);	
		x.map(a->{System.out.println(a); return a;}).subscribe();
	}
}

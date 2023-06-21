package com.fepoc.cf.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;

import com.fepoc.cf.api.ClaimFormExceptionHandler.ErrorResponse;
import com.fepoc.cf.excp.DuplicateClaimException;
import com.fepoc.cf.form.BaseClaimForm;
import com.fepoc.cf.form.dental.DentalClaimDistributedCache;
import com.fepoc.cf.form.dental.DentalClaimForm;
import com.fepoc.cf.form.dental.DentalClaimValidation;
import com.fepoc.pf.domain.Page;

import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@RestController
@RequestMapping("/claimForm")
public class ClaimFormController {

	@Autowired
	private DentalClaimValidation validator;
	@Autowired
	private DentalClaimDistributedCache cache;
	@Autowired
	private ClaimFormExceptionHandler exceptionHandler;
	
	@GetMapping(value="/claim/{claimId}", produces = MediaType.APPLICATION_JSON_VALUE)
	public <T, E> Mono<ResponseEntity<DentalClaimForm>> reviewDentalClaim(@PathVariable String claimId, ServerWebExchange session){
		return null;
	}
	
	@PutMapping(value="/claim", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	public <T> Mono<Page<?>> newClaim(@RequestBody Mono<ClaimRequestForm> claimRequest, ServerWebExchange session){
		return claimRequest
		.filterWhen(a->Mono.defer(() -> Mono.just(a!=null && a.getFormType()!=null))
		        .subscribeOn(Schedulers.elastic()))
		.switchIfEmpty(Mono.error(new IllegalArgumentException()))
		.filterWhen(a->Mono.defer(() -> Mono.just(!validator.isDuplicate(session, a)))
		        .subscribeOn(Schedulers.elastic()))		
		.switchIfEmpty(Mono.error(new IllegalArgumentException()))
		.flatMap(a->cache.prepareNewClaimForm(a, session));
	}
	
	@PostMapping(value="/claim/{claimId}", produces = MediaType.APPLICATION_JSON_VALUE)
	public <T, E> Mono<ResponseEntity<E>> pendClaim(@PathVariable String claimId, ServerWebExchange session){
		return null;
	}	
	
	//DB
	// page1 -> page_txt
	// clm1 -> clm
	
	//s1 1 p1,p2
	//s2
	//s3 2 get from cache + what ->process
	@PutMapping(value="/claim/{claimId}", produces = MediaType.APPLICATION_JSON_VALUE)
	public <E> Mono<ResponseEntity<E>> submitClaim(@PathVariable String claimId, ServerWebExchange session){
		
		return null;
	}		
		
	@PostMapping(value="/page", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<Page<?>> processPage(@RequestBody Mono<Page<? extends BaseClaimForm>> page, ServerWebExchange session){
		return page				
				.flatMap(p->{
					validator.validateAsync(session, p);
					return cache.getNextPage(p, session);
				});
	}

	@GetMapping(value="/page/{pageId}", produces = MediaType.APPLICATION_JSON_VALUE)
	public <T> Mono<Page<?>> retrievePage(@PathVariable String pageId, ServerWebExchange session){
		return cache.retrievePage(pageId);
	}
	
	@PutMapping(value="/page", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<Page<?>> saveClaim(@RequestBody Mono<Page<? extends BaseClaimForm>> page, ServerWebExchange session){		
		return page				
				.flatMap(p->{
					validator.validateAsync(session, p);
					return cache.saveClaim(p, session);
				});
	}	
	

	@ExceptionHandler(IllegalArgumentException.class)
	ResponseEntity<Mono<ErrorResponse>> handleIllegalArgumentException(ServerWebExchange session) {
	  HttpHeaders headers = new HttpHeaders();
	  headers.setContentType(MediaType.APPLICATION_JSON);
	  return ResponseEntity.badRequest().contentType(MediaType.APPLICATION_JSON)
	  	.body(Mono.just(exceptionHandler.new ErrorResponse("Please Check all arguments and resubmit your request")));
	  
	}
	
	@ExceptionHandler(DuplicateClaimException.class)
	ResponseEntity<Mono<ErrorResponse>> handleDuplicateClaimException(ServerWebExchange session) {
	  HttpHeaders headers = new HttpHeaders();
	  headers.setContentType(MediaType.APPLICATION_JSON);
	  return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON)
	  	.body(Mono.just(exceptionHandler.new ErrorResponse("This claim already exists in the system.")));
	  
	}	
	

}

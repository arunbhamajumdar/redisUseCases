package com.fepoc.ms.claim.cae.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;

import com.fepoc.claim.domain.ClaimHeaderInformation;

import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@RestController
@RequestMapping("/claimsubcae")
public class ClaimSubmissionCAEController {
	@Value("${server.port}")
	public String port;
	
	@PostMapping(value="/createFcr", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<String> createFcr(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo
		.filterWhen(a->Mono.defer(() -> Mono.just(a!=null && a.getBatchInformation()!=null))
		        .subscribeOn(Schedulers.elastic()))
		.switchIfEmpty(Mono.error(new IllegalArgumentException()))
		.flatMap(a->cache.prepareNewClaimForm(a, session));
	}
	
	@PostMapping(value="/submitClaim", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<String> submitClaim(@RequestBody Mono<String> fcr, ServerWebExchange session){
		return fcr				
				.flatMap(p->{				
					System.out.println("Submitting Claim to CAE...."+port);
					//retrieve claim from Cache
					String result = "fcr"; 
					return Mono.just(result);
				});
	}	
}

package com.fepoc.ms.claim.ccae.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;

import com.fepoc.claim.domain.ClaimHeaderInformation;

import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/claimsubccae")
public class ClaimSubmissionCCAEController {
	@Value("${server.port}")
	public String port;
	
	
	@PostMapping(value="/createJson", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<String> createJson(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo				
				.flatMap(p->{				
					System.out.println("Creating JSON...."+port);
					//retrieve claim from Cache
					String result = "fcr"; 
					return Mono.just(result);
				});
	}
	@PostMapping(value="/submitClaim", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<String> submitClaim(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo				
				.flatMap(p->{				
					System.out.println("Submitting Claim to CCAE...."+port);
					//retrieve claim from Cache
					String result = "fcr"; 
					return Mono.just(result);
				});
	}		
}

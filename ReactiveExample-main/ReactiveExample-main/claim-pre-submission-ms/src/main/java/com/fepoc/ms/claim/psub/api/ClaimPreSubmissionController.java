package com.fepoc.ms.claim.psub.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;

import com.fepoc.claim.domain.ClaimHeaderInformation;

import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/claimpsub")
public class ClaimPreSubmissionController {
	@Value("${server.port}")
	public String port;

	@PostMapping(value="/claimUniquenessCheck", produces = MediaType.APPLICATION_JSON_VALUE)
	public Mono<Boolean> claimUniquenessCheck(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo				
				.flatMap(p->{				
					System.out.println("Claim Uniqueness check...."+port);
					//call claim uniqueness check method here
					boolean result = true; //claimRepository.claimuUniquenessCheck(headerInfo)
					return Mono.just(result);
				});
	}	
	@PostMapping(value="/versioingLinkage")
	public Mono<Boolean> versioingLinkage(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo				
				.flatMap(p->{				
					System.out.println("Versioning and Linakge...."+port);
					//call versioning and linkage
					boolean result = true; 
					return Mono.just(result);
				});
	}	
	@PostMapping(value="/lockINPRecord")
	public Mono<Boolean> lockINPRecord(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo				
				.flatMap(p->{				
					System.out.println("Lock INP Record...."+port);
					//call Lock INP record
					boolean result = true; 
					return Mono.just(result);
				});
	}		
	@PostMapping(value="/releaseINPRecord")
	public Mono<Boolean> releaseINPRecord(@RequestBody Mono<ClaimHeaderInformation> headerInfo, ServerWebExchange session){
		return headerInfo				
				.flatMap(p->{				
					System.out.println("Release Locked INP Record...."+port);
					//call Lock INP record
					boolean result = true; 
					return Mono.just(result);
				});
	}
}

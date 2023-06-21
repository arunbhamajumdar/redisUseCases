package com.fepoc.ms.claim.psub;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient
public class ClaimPreSubmissionMsApplication {

	public static void main(String[] args) {
		SpringApplication.run(ClaimPreSubmissionMsApplication.class, args);
	}

}

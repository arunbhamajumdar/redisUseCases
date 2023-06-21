package com.fepoc.domain;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.client.OkHttp3ClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
public class ClaimDomainApplication {

	RestTemplate http2Template = new RestTemplate(new OkHttp3ClientHttpRequestFactory());
	
	public static void main(String[] args) {
		SpringApplication.run(ClaimDomainApplication.class, args);
	}

}

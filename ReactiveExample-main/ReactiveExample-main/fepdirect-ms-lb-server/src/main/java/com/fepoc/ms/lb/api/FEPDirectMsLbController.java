package com.fepoc.ms.lb.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.cloud.netflix.ribbon.RibbonClient;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RibbonClient(name="claimPreSubmission", configuration=FEPDirectMSLBConfiguration.class)
public class FEPDirectMsLbController {
	@Bean
	@LoadBalanced
	public RestTemplate template(){
		return new RestTemplate();
	}
	@Autowired
	private RestTemplate restTemplate;
	
	@RequestMapping("/startClient")
	public String startClient(){
		return restTemplate.getForObject("http://claimPreSubmission/execute", String.class);
	}
}

package com.fepoc.ms.server.edgeregistry;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class FepdirectMsRegistryServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(FepdirectMsRegistryServerApplication.class, args);
	}

}

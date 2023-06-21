package com.fepoc.ms.server.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class FepdirectMsConfigServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(FepdirectMsConfigServerApplication.class, args);
	}

}

package com.fepoc.cf;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages="com.fepoc.cf, com.fepoc.cf.api, com.fepoc.vf, com.fepoc.pf")
public class ClaimFormApplication {

	public static void main(String[] args) {
		SpringApplication.run(ClaimFormApplication.class, args);
	}

}

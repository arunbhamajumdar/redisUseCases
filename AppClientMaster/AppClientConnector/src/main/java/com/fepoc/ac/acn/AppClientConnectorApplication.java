package com.fepoc.ac.acn;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.PostConstruct;
import com.fepoc.ac.acn.client.ClientConnector;

@SpringBootApplication
@ComponentScan(basePackages = "com.fepoc.ac.acn.client")
public class AppClientConnectorApplication {

	public static void main(String[] args) {
		SpringApplication.run(AppClientConnectorApplication.class, args);
	}

}

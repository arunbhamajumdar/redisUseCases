package com.mypoc.redishc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class RedisHibernateL2CacheApplication {

	public static void main(String[] args) {
		SpringApplication.run(RedisHibernateL2CacheApplication.class, args);
	}

}

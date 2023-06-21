package com.fepoc.dc.ccc;

import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;
import org.springframework.data.redis.connection.RedisClusterConfiguration;
import org.springframework.data.redis.connection.RedisClusterConnection;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;

import io.lettuce.core.RedisClient;

@Configuration
@Profile("OpenRedis")
public class RedisClientConfiguration {

	@Value("${cluster.urls}")
	private String clusterUrl;
	
	@Autowired
	RedisClusterConfiguration clientConfig;
	
	@Bean
	public RedisClusterConfiguration config() {
		RedisClusterConfiguration config = new RedisClusterConfiguration(Arrays.asList(clusterUrl.split(",")));
		config.setPassword("Totapuko$4");
		
		return config;
	}
	

	@Bean
	@Primary
	public LettuceConnectionFactory getConnectionFactory() {
		return new LettuceConnectionFactory(clientConfig);
	}

	@Bean public RedisClusterConnection getClusterConnection(LettuceConnectionFactory cf) {
		return cf.getClusterConnection();
	}
}

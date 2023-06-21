package com.fepoc.dc.ccc;

import java.time.Duration;
import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.data.redis.connection.RedisClusterConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceClientConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
@Profile("EnterpriseRedis")
public class RedisTemplateClientConfiguration {
//	redis :// [password@] host [: port] [/ database]
//		  [? [timeout=timeout[d|h|m|s|ms|us|ns]]
//		  [&_database=database_]]
//	redis – a standalone Redis server
//	rediss – a standalone Redis server via an SSL connection
//	redis-socket – a standalone Redis server via a Unix domain socket
//	redis-sentinel – a Redis Sentinel server
	
	@Value("${cluster.urls}")
	private String clusterUrl;
	@Autowired
	RedisClusterConfiguration clientConfig;
	
	@Bean
	public RedisClusterConfiguration config() {
		RedisClusterConfiguration config = new RedisClusterConfiguration(
				Arrays.asList(clusterUrl.split(","))
				);
		return config;
	}	
	@Bean
	public <K,V> RedisTemplate<K,V> getRedisTemplate() {
		RedisTemplate<K,V> template = new RedisTemplate<>();	
		template.setConnectionFactory(getCF());		
		template.setKeySerializer(new StringRedisSerializer());
		template.setValueSerializer(new StringRedisSerializer());
		template.afterPropertiesSet();
		return template;
	}
	@Bean
	public LettuceConnectionFactory getCF() {
		//redis-17542.redislabscluster.mydomain.com:17542
		LettuceConnectionFactory cf = new LettuceConnectionFactory(config());
		
		return cf;
	}
}

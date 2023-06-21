package com.fepoc.dc.ccc;

import java.util.concurrent.ExecutionException;
import java.util.stream.IntStream;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

import com.fepoc.claim.domain.DentalClaim;
import com.fepoc.claim.repository.ClaimRepository;

import io.lettuce.core.RedisClient;
import io.lettuce.core.RedisFuture;
import io.lettuce.core.api.StatefulRedisConnection;


@SpringBootApplication
@ComponentScan("com.fepoc.claim.repository,com.fepoc.dc.ccc")
public class CacheClientCoreApplication {
	@Autowired
	private TestRedisClient client;
	@Autowired
	private ClaimRepository claimRepo;
	
	public static void main(String[] args) {
		SpringApplication.run(CacheClientCoreApplication.class, args);
	}

	@PostConstruct
	public void test() {
		//client.test();
		claimRepo.flush();
		claimRepo.addStream();
		claimRepo.register();

//		claimRepo.autosaveListener();
		IntStream.range(0, 5).forEach(i->{
			claimRepo.saveDentalClaim(client.getDentalClaim());
			sleep(300);
		});
		sleep(500);
//		claimRepo.save(client.getDentalClaim());
//		claimRepo.readMessage();
		claimRepo.stopListener();
		claimRepo.getAllDentalClaim().stream().map(a->"Claim Numner: " +a.getClaimHeaderInformation().getBatchInformation().getClaimNumber()).forEach(System.out::println);
	}

	public void test1() {
		String dburl = "redis://totapuko$4@192.168.1.109:8443/";
		
		RedisClient redisClient = RedisClient
				  .create(dburl);
		StatefulRedisConnection<String, String> connection
				 = redisClient.connect();		
		connection.async().hset("k1", "name", "Arun");
		try {
			String s = connection.async().hget("k1", "name").get();
			System.out.println(s);
		} catch (InterruptedException | ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	private void sleep(long n) {
		try {
			Thread.sleep(n);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
}

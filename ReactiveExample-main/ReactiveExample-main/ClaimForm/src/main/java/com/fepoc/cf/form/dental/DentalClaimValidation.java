package com.fepoc.cf.form.dental;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import com.fepoc.cf.api.ClaimRequestForm;
import com.fepoc.pf.domain.Page;
import com.fepoc.pf.sse.UserChannel;
import com.fepoc.pf.sse.UserChannelManager;
import com.fepoc.vf.ValidationChannelManager;
import com.fepoc.vf.ValidationChannel;

@Component
public class DentalClaimValidation {
	@Autowired
	private ValidationChannelManager vcmanager;
	@Autowired
	private UserChannelManager ucmanager;
	
	ServerWebExchange session;
	private static ExecutorService es = Executors.newFixedThreadPool(2);
	
	public <E> void validateAsync(ServerWebExchange session, Page<E> page) {
		CompletableFuture.runAsync(()-> {
				validate(session, page);				
		}, es);
	}
	
	public <E> void validate(ServerWebExchange session, Page<E> page) {
		getValidator(session).stream().forEach(channel->channel.validate(page));
		//broadcast for now
		getAllSSE(session).stream().forEach(channel->channel.push(page.getEventMessage(session)));
		//eventually the following line should be uncommented
		//getSSE(session).stream().forEach(channel->channel.push(page.getEventMessage(session)));
				
	}

	private List<ValidationChannel> getValidator(ServerWebExchange session) {
		List<ValidationChannel> list = vcmanager.getValidationChannels(session);
		if(list==null || list.isEmpty()) {
			ValidationChannel validationChannel = new ValidationChannel(session);
			addValidationMethods(validationChannel);
			vcmanager.addValidationChannel(validationChannel );
			list = vcmanager.getValidationChannels(session);
		}
		return list;
	}
	private List<UserChannel> getAllSSE(ServerWebExchange swe) {
		List<UserChannel> list = ucmanager.getAllUserChannels();
		if(list==null || list.isEmpty()) {
			UserChannel userChannel = new UserChannel(swe);
			ucmanager.addUserChannel(userChannel );
			list = ucmanager.getAllUserChannels();
		}
		return list;
	}
	
	private List<UserChannel> getSSE(ServerWebExchange swe) {
		List<UserChannel> list = ucmanager.getUserChannels(swe);
		if(list==null || list.isEmpty()) {
			UserChannel userChannel = new UserChannel(swe);
			ucmanager.addUserChannel(userChannel );
			list = ucmanager.getUserChannels(swe);
		}
		return list;
	}
	private void addValidationMethods(ValidationChannel validationChannel) {
		validationChannel.registerValidator((Page<?> e)-> method1(e));
		validationChannel.registerValidator((Page<?> e)-> method2(e));
	}
	
	public void method1(Page<?> page) {
		System.out.println("I am in validation method1:"+page);
		delay(2000);
	}
	public void method2(Page<?> page) {
		System.out.println("I am in validation method2:"+page);
	}	
	
	public void delay(long period) {
		try {
			Thread.sleep(period);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public boolean isDuplicate(ServerWebExchange session, ClaimRequestForm a) {
		// Add Duplicate logic
		return false;
	}
}

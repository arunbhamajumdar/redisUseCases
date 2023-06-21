package com.fepoc.pf.sse;

import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebSession;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
public class ServerSentEventController {
	
	@Autowired
	private UserChannelManager manager;
	
	@GetMapping(value="/serverSentEvent", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	@CrossOrigin
	public Flux<ServerSentEvent<EventMessage>> receiveEvents(ServerWebExchange session){
		UserChannel userChannel = new UserChannel(session);
		manager.addUserChannel(userChannel);
		return userChannel.getSSE();
	}
	
	@DeleteMapping(value="/serverSentEvent")
	@CrossOrigin
	public void terminate(ServerWebExchange session){
		List<UserChannel> userChanneles = manager.getUserChannels(session);
		if(Objects.nonNull(userChanneles)) {
			userChanneles.stream().forEach(ue->ue.close());
		}
		session.getSession().subscribe(a->{
			System.out.println("Invalidating session "+a);
			a.invalidate().subscribe();
		});
		session.getSession().toFuture().join();
	}	
	
	@PutMapping(value="/message")
	@CrossOrigin
	public void pushMessage(ServerWebExchange session, @RequestBody Mono<EventMessage> message){
		List<UserChannel> userChanneles = manager.getUserChannels(session);
		if(Objects.nonNull(userChanneles)) {
			userChanneles.stream().forEach(ue->{
				message.subscribe(msg->{msg.setSession(session); ue.push(msg);});
			});
		}
	}	
	

}

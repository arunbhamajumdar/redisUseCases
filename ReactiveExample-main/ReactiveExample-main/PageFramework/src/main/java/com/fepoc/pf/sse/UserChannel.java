package com.fepoc.pf.sse;

import java.time.Duration;
import java.util.UUID;

import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.server.ServerWebExchange;
import com.fepoc.pf.sse.UserChannelManager.ChannelDisposable;

import reactor.core.publisher.DirectProcessor;
import reactor.core.publisher.Flux;
import reactor.core.publisher.FluxProcessor;
import reactor.core.publisher.FluxSink;

/**
 * User opens a channel to receive events
 * @author cw22is2
 *
 */
public class UserChannel {
	final FluxProcessor<EventMessage, EventMessage> processor;
	final FluxSink<EventMessage> sink;
	private String sessionId;
	
	/**
	 * Please use appropriate processor as needed
	 * @param session
	 * @param userEventDisposable 
	 */
	public UserChannel(ServerWebExchange swe) {
		resolveSessionIds(swe);
		this.processor = DirectProcessor.<EventMessage>create().serialize();
		this.sink = processor.sink();
	}
	
	public void setDisposable(ChannelDisposable userEventDisposable) {
		this.sink.onCancel(userEventDisposable);
		this.sink.onDispose(userEventDisposable);		
	}
	
	public Flux<ServerSentEvent<EventMessage>> getSSE() {
		return processor.map(p->ServerSentEvent.builder(p).build());
	}

	public void push(EventMessage eventMessage) {
		sink.next(eventMessage);
	}

	public FluxProcessor<EventMessage, EventMessage> getProcessor() {
		return processor;
	}

	public FluxSink<EventMessage> getSink() {
		return sink;
	}

	public String getSessionId() {
		return sessionId;
	}
	
	public void resolveSessionIds(ServerWebExchange swe) {
		swe.getSession().subscribe(r->{
			setSessionId(r.getId()==null?UUID.randomUUID().toString():r.getId());
		});
		swe.getSession().toFuture().join();
	}
	private void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public void close() {
		timeoutProcessor(1000);		
		sink.complete();
		processor.onComplete();
	}
	
	public boolean isCompleted() {
		return processor.hasCompleted();
	}
	
	public void timeoutProcessor(long inMillis) {
		Duration duration = Duration.ofMillis(inMillis);
		this.processor.timeout(duration );		
	}
}

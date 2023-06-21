package com.fepoc.vf;

import java.util.UUID;
import java.util.function.Consumer;

import org.springframework.web.server.ServerWebExchange;
import com.fepoc.pf.domain.Page;
import com.fepoc.vf.ValidationChannelManager.ChannelDisposable;

import reactor.core.publisher.DirectProcessor;
import reactor.core.publisher.FluxProcessor;
import reactor.core.publisher.FluxSink;

public class ValidationChannel {
	final FluxProcessor<Page<?>, Page<?>> processor;
	final FluxSink<Page<?>> sink;
	private String sessionId;
	
	/**
	 * Please use appropriate processor as needed
	 * @param session
	 * @param userEventDisposable 
	 */
	public ValidationChannel(ServerWebExchange session) {
		resolveSessionIds(session);
		this.processor = DirectProcessor.<Page<?>>create();
		this.sink = processor.sink();		
	}
	
	public void registerValidator(Consumer<? super Page<?>> consumer) {
		this.processor.subscribe(consumer);
	}
	
	public void setDisposable(ChannelDisposable validationEventDisposable) {
		this.sink.onCancel(validationEventDisposable);
		this.sink.onDispose(validationEventDisposable);		
	}	
	

	public void validate(Page<?> page) {
		sink.next(page);
	}

	public FluxProcessor<Page<?>, Page<?>> getProcessor() {
		return processor;
	}

	public FluxSink<Page<?>> getSink() {
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

	public void complete() {
		this.processor.onComplete();
	}
	

}

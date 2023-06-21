package com.fepoc.vf;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebSession;

import reactor.core.Disposable;
@Component
public class ValidationChannelManager {
	private ConcurrentMap<String, List<ValidationChannel>> map = new ConcurrentHashMap<>();
	private String sessionId;

	public <E> void addValidationChannel(ValidationChannel validationChannel) {
		map.putIfAbsent(validationChannel.getSessionId(), new CopyOnWriteArrayList<>());
		map.get(validationChannel.getSessionId()).add(validationChannel);
		ChannelDisposable disposal = new ChannelDisposable(validationChannel, validationChannel.getSessionId());
		validationChannel.setDisposable(disposal);
	}
	
	public class ChannelDisposable implements Disposable {
		private ValidationChannel channel;
		private String sessionId;
		ChannelDisposable(ValidationChannel event, String sessionId){
			this.channel = event;
			this.sessionId = sessionId;
		}
		@Override
		public void dispose() {
			map.get(sessionId).remove(channel);
		}
		
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
	public List<ValidationChannel> getValidationChannels(ServerWebExchange session) {
		resolveSessionIds(session);
		return map.get(sessionId);
	}

}

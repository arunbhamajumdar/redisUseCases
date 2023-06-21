package com.fepoc.pf.sse;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebSession;

import reactor.core.Disposable;
@Component
public class UserChannelManager extends TimerTask {
	private ConcurrentMap<String, List<UserChannel>> map = new ConcurrentHashMap<>();
	private String sessionId;
	private Timer cleanup = new Timer();
	
	public UserChannelManager() {
		//cleanup.schedule(this, 10, 60000);		
	}
	
	public void addUserChannel(UserChannel userChannel) {
		map.putIfAbsent(userChannel.getSessionId(), new CopyOnWriteArrayList<>());
		map.get(userChannel.getSessionId()).add(userChannel);
		ChannelDisposable disposal = new ChannelDisposable(userChannel, userChannel.getSessionId());
		userChannel.setDisposable(disposal);
	}
	
	public class ChannelDisposable implements Disposable {
		private UserChannel channel;
		private String sessionId;
		ChannelDisposable(UserChannel event, String sessionId){
			this.channel = event;
			this.sessionId = sessionId;
		}
		@Override
		public void dispose() {
			System.out.println("Disposal is called...");
			this.channel.close();
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

	public List<UserChannel> getUserChannels(ServerWebExchange swe) {
		updateChannel();
		resolveSessionIds(swe);
		System.out.println("Map = "+ map);
		System.out.println("session = "+sessionId);
		List<UserChannel> list = map.containsKey(sessionId)?map.get(sessionId):new ArrayList<>(0);
		System.out.println("list = "+list.size());
		return list;
	}	
	public List<UserChannel> getAllUserChannels() {
		//System.out.println("Map = "+ map);
		List<UserChannel> list = map.values().stream().flatMap(a->a.stream()).collect(Collectors.toList());
		return list;
	}		
	
	
	
	
	
	public void updateChannel() {
		map.values().stream().flatMap(a->a.stream())
			.filter(a->a.processor.isDisposed()||a.processor.isTerminated())
			.forEach(a->a.close());
	}
	public void removeChannel() {
		List<UserChannel> list = map.values().stream().flatMap(a->a.stream())
			.filter(a->a.isCompleted())
			.collect(Collectors.toList());
		System.out.println("Remove list = "+ list);
		list.stream().forEach(l->{
			map.keySet().stream().forEach(a->{
				if(map.get(a).contains(l)) {
					map.get(a).remove(l);
				}
			});
		});
	}


	@Override
	public void run() {
		System.out.println("Cleaning up....");
		updateChannel();
		removeChannel();
	}
}

package com.fepoc.pf.domain;

import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

import org.springframework.web.server.ServerWebExchange;

import com.fepoc.dc.ccc.RedisKey;
import com.fepoc.pf.sse.EventMessage;

public class Page<E> implements Cloneable, RedisKey{
	private List<PageFragment<?>> pageFagments = new CopyOnWriteArrayList<>();
	private String title;
	private String id;
	
	protected String userId;
	protected String userSessionId;
	protected String bizId;
	protected int nextRequestedPage=1;
	
	public Page() {
		this.id = UUID.randomUUID().toString();
	}

	public List<PageFragment<?>> getPageFagments() {
		return pageFagments;
	}

	public void setPageFagments(List<PageFragment<?>> pageFagments) {
		this.pageFagments = pageFagments;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserSessionId() {
		return userSessionId;
	}

	public void setUserSessionId(String userSessionId) {
		this.userSessionId = userSessionId;
	}

	public String getBizId() {
		return bizId;
	}

	public void setBizId(String bizId) {
		this.bizId = bizId;
	}

	public int getNextRequestedPage() {
		return nextRequestedPage;
	}

	public void setNextRequestedPage(int nextRequestedPage) {
		this.nextRequestedPage = nextRequestedPage;
	}

	public EventMessage getEventMessage(ServerWebExchange swe) {
		String msg = this.pageFagments.stream().map(pf->pf.getMessage()).collect(Collectors.joining());
		msg = "".equals(msg.trim())?"No page Fragment or status has been configured as of "+(new Date()):msg;
		return new EventMessage(this, "E001", msg, swe);
	}
	
	public Page<E> clone() throws CloneNotSupportedException {
		@SuppressWarnings("unchecked")
		Page<E> pg = (Page<E>) super.clone();
		return pg;
	}

	@Override
	public String key() {
		return "p:".concat(id);
	}
	
}

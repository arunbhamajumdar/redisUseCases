package com.fepoc.pf.sse;

import org.springframework.web.server.ServerWebExchange;

import com.fepoc.pf.domain.Page;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.UUID;;

public class EventMessage implements Serializable{

	private static final long serialVersionUID = 1L;
	private String responseCode;
	private String responseMessage;
	private String sessionId;
	private Page<?> errorPage;
	
	public EventMessage() {}
	public EventMessage(String responseCode, String responseMessage, ServerWebExchange swe) {
		//resolveSessionIds(swe);
		swe.getSession().subscribe(s->{
			sessionId=s.getId();
			this.responseMessage = responseMessage;
			this.responseCode = responseCode;
		});
	}

	public EventMessage(Page<?> errorPage, String responseCode, String responseMessage, ServerWebExchange swe) {
		swe.getSession().subscribe(s->{
			sessionId=s.getId();
			this.responseMessage = responseMessage;
			this.responseCode = responseCode;
			setErrorPage(errorPage);
		});
	}
	
	public void setSession(ServerWebExchange swe) {
		swe.getSession().subscribe(s->{
			sessionId=s.getId();
		});		
	}
	public String getResponseCode() {
		return responseCode;
	}


	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}


	public String getResponseMessage() {
		return responseMessage;
	}


	public void setResponseMessage(String responseMessage) {
		this.responseMessage = responseMessage;
	}


	public String getSessionId() {
		return sessionId;
	}
	
	
	public Page<?> getErrorPage() {
		return errorPage;
	}

	public void setErrorPage(Page<?> errorPage) {
		this.errorPage = process(errorPage);
	}

	private Page<?> process(Page<?> epage) {
		Page<?> npg;
		try {
			npg = epage.clone();
			npg.setPageFagments(new ArrayList<>());
			epage.getPageFagments().stream().forEach(pf->{
				try {
					npg.getPageFagments().add(pf.clone());
				} catch (CloneNotSupportedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
			return npg;
		} catch (CloneNotSupportedException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		return null;
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

}

package com.fepoc.claim.domain;

import com.fepoc.dc.ccc.RedisKey;

public class BillingProvider implements RedisKey{
	private String id;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	@Override
	public String key() {
		return "bp:".concat(id);
	}
	
	public String toString() {
		return "Billing Provider ["+id +"]";
	}
}

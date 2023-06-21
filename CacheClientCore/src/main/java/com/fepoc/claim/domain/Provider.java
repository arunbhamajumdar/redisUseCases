package com.fepoc.claim.domain;

import com.fepoc.dc.ccc.RedisKey;

public class Provider implements RedisKey{
	private PerformingProvider performingProvider;
	private BillingProvider billingProvider;
	public PerformingProvider getPerformingProvider() {
		return performingProvider;
	}
	public void setPerformingProvider(PerformingProvider performingProvider) {
		this.performingProvider = performingProvider;
	}
	public BillingProvider getBillingProvider() {
		return billingProvider;
	}
	public void setBillingProvider(BillingProvider billingProvider) {
		this.billingProvider = billingProvider;
	}
	
	@Override
	public String key() {
		return "pr";
	}
	
	
}

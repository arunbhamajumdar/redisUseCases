package com.fepoc.claim.domain;

public class Provider {
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
	
	
}

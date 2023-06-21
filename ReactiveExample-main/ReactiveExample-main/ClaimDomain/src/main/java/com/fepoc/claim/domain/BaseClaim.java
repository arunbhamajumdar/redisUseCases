package com.fepoc.claim.domain;

public abstract class BaseClaim {
	protected ClaimHeaderInformation claimHeaderInformation;
	protected Provider provider;
	protected Member member;
	protected ClaimDetails claimDetails;
	public ClaimHeaderInformation getClaimHeaderInformation() {
		return claimHeaderInformation;
	}
	public void setClaimHeaderInformation(ClaimHeaderInformation claimHeaderInformation) {
		this.claimHeaderInformation = claimHeaderInformation;
	}
	public Provider getProvider() {
		return provider;
	}
	public void setProvider(Provider provider) {
		this.provider = provider;
	}
	public Member getMember() {
		return member;
	}
	public void setMember(Member member) {
		this.member = member;
	}
	public ClaimDetails getClaimDetails() {
		return claimDetails;
	}
	public void setClaimDetails(ClaimDetails claimDetails) {
		this.claimDetails = claimDetails;
	}
	
	
}

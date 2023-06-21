package com.fepoc.claim.domain;
import java.io.Serializable;

public class BatchInformation implements Serializable{
	private static final long serialVersionUID = 1L;
	private String claimNumber;
	public String getClaimNumber() {
		return claimNumber;
	}
	public void setClaimNumber(String claimNumber) {
		this.claimNumber = claimNumber;
	}

}

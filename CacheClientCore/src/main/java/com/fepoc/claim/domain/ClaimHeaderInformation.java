package com.fepoc.claim.domain;

public class ClaimHeaderInformation {
	protected BatchInformation batchInformation;

	public BatchInformation getBatchInformation() {
		return batchInformation;
	}

	public void setBatchInformation(BatchInformation batchInformation) {
		this.batchInformation = batchInformation;
	}
	public String toString() {
		return "Header ["+batchInformation.getClaimNumber() +"]";
	}

}

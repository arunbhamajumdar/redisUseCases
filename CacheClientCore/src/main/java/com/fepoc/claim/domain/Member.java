package com.fepoc.claim.domain;

import com.fepoc.dc.ccc.RedisKey;

public class Member implements RedisKey{
	protected String id;
	protected PatientDetails patientDetails;
	protected SubmittedContractHolder submittedContractHolder;
	
	public PatientDetails getPatientDetails() {
		return patientDetails;
	}
	public void setPatientDetails(PatientDetails patientDetails) {
		this.patientDetails = patientDetails;
	}
	public SubmittedContractHolder getSubmittedContractHolder() {
		return submittedContractHolder;
	}
	public void setSubmittedContractHolder(SubmittedContractHolder submittedContractHolder) {
		this.submittedContractHolder = submittedContractHolder;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	@Override
	public String key() {
		return "mem:".concat(id);
	}
	public String toString() {
		return "Member ["+id +"]";
	}
}

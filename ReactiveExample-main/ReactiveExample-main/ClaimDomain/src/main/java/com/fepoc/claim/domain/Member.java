package com.fepoc.claim.domain;

public class Member {
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

}

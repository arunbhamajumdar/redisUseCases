package com.fepoc.cf.api;

public class ClaimRequestForm {
	private FormType formType;
	private String bizId;
	public FormType getFormType() {
		return formType;
	}
	public void setFormType(FormType formType) {
		this.formType = formType;
	}
	public String getBizId() {
		return bizId;
	}
	public void setBizId(String bizId) {
		this.bizId = bizId;
	}
	
	
}

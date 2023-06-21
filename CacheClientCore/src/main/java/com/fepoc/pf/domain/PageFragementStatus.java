package com.fepoc.pf.domain;

import java.util.List;

import com.fepoc.dc.ccc.RedisKey;

public class PageFragementStatus<T> implements RedisKey{
	private String statusCode;
	private String statusDescription;
	private List<PageFragmentError> errors;

	public String getStatusCode() {
		return statusCode;
	}


	public void setStatusCode(String statusCode) {
		this.statusCode = statusCode;
	}


	public String getStatusDescription() {
		return statusDescription;
	}


	public void setStatusDescription(String statusDescription) {
		this.statusDescription = statusDescription;
	}


	public List<PageFragmentError> getErrors() {
		return errors;
	}


	public void setErrors(List<PageFragmentError> errors) {
		this.errors = errors;
	}


	public void getMessage(StringBuilder sb) {
		sb.append(this.statusDescription).append(" (").append(this.statusCode).append(")\n");
		
	}


	@Override
	public String key() {
		return "pfs";
	}
}

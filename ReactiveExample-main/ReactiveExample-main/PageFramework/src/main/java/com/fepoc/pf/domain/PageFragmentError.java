package com.fepoc.pf.domain;

import java.util.List;

public class PageFragmentError {
	private String errorCode;
	private String errorMessage; // can have pattern and parameter substitution is required
	private List<String> params; //used if the error message is a pattern
	private String editCode; //e.g., edit code
	private String editResolution; //e.g., edit resolution
	
	public String getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	public List<String> getParams() {
		return params;
	}
	public void setParams(List<String> params) {
		this.params = params;
	}
	public String getEditCode() {
		return editCode;
	}
	public void setEditCode(String editCode) {
		this.editCode = editCode;
	}
	public String getEditResolution() {
		return editResolution;
	}
	public void setEditResolution(String editResolution) {
		this.editResolution = editResolution;
	}
	
}

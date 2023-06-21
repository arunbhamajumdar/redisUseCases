package com.fepoc.vf.json.schema;

import java.util.List;

public class JsonObjectPropertyDependency {
	private String fieldName;
	private List<String> dependentOnFields;
	public String getFieldName() {
		return fieldName;
	}
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}
	public List<String> getDependentOnFields() {
		return dependentOnFields;
	}
	public void setDependentOnFields(List<String> dependentOnFields) {
		this.dependentOnFields = dependentOnFields;
	}
	
	
}

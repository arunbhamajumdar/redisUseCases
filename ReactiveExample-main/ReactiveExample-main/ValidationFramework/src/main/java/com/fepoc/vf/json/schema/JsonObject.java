package com.fepoc.vf.json.schema;

import java.util.List;
import java.util.concurrent.ConcurrentMap;

public class JsonObject extends JsonBaseType{

	public JsonObject() {
		super(PropertyType.objectT);
	}
	private ConcurrentMap<String, JsonProperty<?>> properties;
	private boolean additionalPropertiesFlag;
	private JsonProperty<? extends JsonBaseType> additionalProperties;
	private List<String> required;
	private String propertyNamesPattern;
	private Integer minProperties;
	private Integer maxProperties;
	private List<JsonObjectPropertyDependency> propertyDependencies;
	private List<JsonObjectSchemaDependency> schemaDependencies;
	private List<PatternProperty> patternProperties;
	
	public ConcurrentMap<String, JsonProperty<? extends JsonBaseType>> getProperties() {
		return properties;
	}
	public void setProperties(ConcurrentMap<String, JsonProperty<?>> properties) {
		this.properties = properties;
	}
	public boolean isAdditionalPropertiesFlag() {
		return additionalPropertiesFlag;
	}
	public void setAdditionalPropertiesFlag(boolean additionalPropertiesFlag) {
		this.additionalPropertiesFlag = additionalPropertiesFlag;
	}
	public JsonProperty<? extends JsonBaseType> getAdditionalProperties() {
		return additionalProperties;
	}
	public void setAdditionalProperties(JsonProperty<? extends JsonBaseType> additionalProperties) {
		this.additionalProperties = additionalProperties;
	}
	public List<String> getRequired() {
		return required;
	}
	public void setRequired(List<String> required) {
		this.required = required;
	}
	public String getPropertyNamesPattern() {
		return propertyNamesPattern;
	}
	public void setPropertyNamesPattern(String propertyNamesPattern) {
		this.propertyNamesPattern = propertyNamesPattern;
	}
	public Integer getMinProperties() {
		return minProperties;
	}
	public void setMinProperties(Integer minProperties) {
		this.minProperties = minProperties;
	}
	public Integer getMaxProperties() {
		return maxProperties;
	}
	public void setMaxProperties(Integer maxProperties) {
		this.maxProperties = maxProperties;
	}
	public List<JsonObjectPropertyDependency> getPropertyDependencies() {
		return propertyDependencies;
	}
	public void setPropertyDependencies(List<JsonObjectPropertyDependency> propertyDependencies) {
		this.propertyDependencies = propertyDependencies;
	}
	public List<JsonObjectSchemaDependency> getSchemaDependencies() {
		return schemaDependencies;
	}
	public void setSchemaDependencies(List<JsonObjectSchemaDependency> schemaDependencies) {
		this.schemaDependencies = schemaDependencies;
	}
	public List<PatternProperty> getPatternProperties() {
		return patternProperties;
	}
	public void setPatternProperties(List<PatternProperty> patternProperties) {
		this.patternProperties = patternProperties;
	}
	@Override
	protected String toSchema() {
		// TODO Auto-generated method stub
		return null;
	}
	

}

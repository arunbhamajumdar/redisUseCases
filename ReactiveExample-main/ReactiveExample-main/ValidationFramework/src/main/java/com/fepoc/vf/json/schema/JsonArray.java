package com.fepoc.vf.json.schema;

import java.util.List;

public class JsonArray extends JsonBaseType{

	public JsonArray() {
		super(PropertyType.arrayT);
	}

	private List<JsonProperty<?>> items;
	private boolean uniqueness;
	private Integer minItems;
	private Integer maxItems;
	private boolean additionalItems;
	
	public List<JsonProperty<?>> getItems() {
		return items;
	}

	public void setItems(List<JsonProperty<?>> items) {
		this.items = items;
	}

	public boolean isUniqueness() {
		return uniqueness;
	}

	public void setUniqueness(boolean uniqueness) {
		this.uniqueness = uniqueness;
		attributes.put("uniqueItems", uniqueness);
	}

	public Integer getMinItems() {
		return minItems;
	}

	public void setMinItems(Integer minItems) {
		this.minItems = minItems;
		attributes.put("minItems", minItems);
	}

	public Integer getMaxItems() {
		return maxItems;
	}

	public void setMaxItems(Integer maxItems) {
		this.maxItems = maxItems;
		attributes.put("maxItems", maxItems);
	}

	public boolean isAdditionalItems() {
		return additionalItems;
	}

	public void setAdditionalItems(boolean additionalItems) {
		this.additionalItems = additionalItems;
		attributes.put("additionalItems", additionalItems);
	}

	@Override
	protected String toSchema() {
		// TODO Auto-generated method stub
		return null;
	}
	
	
}

package com.fepoc.vf.json.schema;

public class JsonNumber extends JsonBaseType{
	public JsonNumber() {
		super(PropertyType.numberT);
	}
	private Integer multipleOf;
	private Integer minimum;
	private Integer maximum;
	private Integer exclusiveMinimum;
	private Integer exclusiveMaximum;
	public Integer getMultipleOf() {
		return multipleOf;
	}
	public void setMultipleOf(Integer multipleOf) {
		this.multipleOf = multipleOf;
	}
	public Integer getMinimum() {
		return minimum;
	}
	public void setMinimum(Integer minimum) {
		this.minimum = minimum;
	}
	public Integer getMaximum() {
		return maximum;
	}
	public void setMaximum(Integer maximum) {
		this.maximum = maximum;
	}
	public Integer getExclusiveMinimum() {
		return exclusiveMinimum;
	}
	public void setExclusiveMinimum(Integer exclusiveMinimum) {
		this.exclusiveMinimum = exclusiveMinimum;
	}
	public Integer getExclusiveMaximum() {
		return exclusiveMaximum;
	}
	public void setExclusiveMaximum(Integer exclusiveMaximum) {
		this.exclusiveMaximum = exclusiveMaximum;
	}
	@Override
	protected String toSchema() {
		// TODO Auto-generated method stub
		return null;
	}
	
}

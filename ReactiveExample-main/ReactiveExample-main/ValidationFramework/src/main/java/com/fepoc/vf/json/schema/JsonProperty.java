package com.fepoc.vf.json.schema;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

public class JsonProperty<E extends JsonBaseType> {
	private String name;
	private PropertyType type;
	private ConcurrentMap<String, List<JsonProperty<?>>> properties;
	private ConcurrentMap<String, Object> attributes;
	private E propertyReference;
	private String reference;
	
	public JsonProperty(E propertyReference) {
		this.propertyReference = propertyReference;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public PropertyType getType() {
		return type;
	}
	public void setType(PropertyType type) {
		this.type = type;
	}

	public ConcurrentMap<String, List<JsonProperty<?>>> getProperties() {
		return properties;
	}
	public void setProperties(ConcurrentMap<String, List<JsonProperty<?>>> properties) {
		this.properties = properties;
	}
	
	public E getPropertyReference() {
		return propertyReference;
	}
	public void setPropertyReference(E propertyReference) {
		this.propertyReference = propertyReference;
	}
	public static JsonProperty<JsonString> createString(String name, JsonString jstring) {
		JsonProperty<JsonString> jp = new JsonProperty<>(jstring);
		jp .setName(name);
		jp.setType(PropertyType.stringT);
		return jp;
	}
	public static JsonProperty<JsonObject> createObject(String name, JsonObject jobject) {
		JsonProperty<JsonObject> jp = new JsonProperty<>(jobject);
		jp .setName(name);
		jp.setType(PropertyType.objectT);
		return jp;
	}
	public ConcurrentMap<String, Object> getAttributes() {
		return getPropertyReference()==null?null:getPropertyReference().getAttributes();
	}
	
	public String toType() {
		return toType(this);
	}
	
	public String toObject() {
		return "{ \n \"type\" : \"object\", \n".concat(JsonUtil.quote("properties")).concat(" : ").concat(" {\n").concat(
				getProperties()==null?"":getProperties().entrySet().stream().map(n->{
			return n.getValue().stream().map(m->{
						return JsonUtil.quote(m.getName()).concat(" : ")
								.concat(toType(m));
			}).collect(Collectors.joining(",\n"));
		}).collect(Collectors.joining("\n")))
		.concat("\n}\n}\n");
	}	
	public String toArray() {
		return "{ \n \"type\" : \"array\", \n".concat(JsonUtil.quote("items")).concat(" : ").concat(" [\n").concat(
				getProperties()==null?"":getProperties().entrySet().stream().map(n->{
			return n.getValue().stream().map(m->{
						return JsonUtil.quote(m.getName()).concat(" : ")
								.concat(toType(m));
			}).collect(Collectors.joining(",\n"));
		}).collect(Collectors.joining("\n")))
		.concat("\n]\n}\n");
	}	
	public String toType(JsonProperty<?> property) {
		String res;
		switch(property.getType()) {
		case objectT:
			res = property.toObject();
			break;
		case arrayT:
			res = property.toArray();
			break;
		default:
			res = property.toProperty();
		}
		return res;	
	}
	
	public String toProperty() {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
		sb.append(JsonUtil.quote("type")).append(" : ").append(JsonUtil.quote(getType().name));
		if(Objects.nonNull(getPropertyReference())) {
			sb.append(getPropertyReference().toSchema());
		}
		if(Objects.nonNull(getAttributes())) {
			sb.append(",\n");
			sb.append(getAttributes().entrySet().stream()
			.map(m->JsonUtil.quote(m.getKey()).concat(" : ").concat(
					m==null?"null":JsonUtil.quote(m.getValue().toString())))
			.collect(Collectors.joining(",\n")));
		}
		sb.append("}");		
		return sb.toString();
	}	
}

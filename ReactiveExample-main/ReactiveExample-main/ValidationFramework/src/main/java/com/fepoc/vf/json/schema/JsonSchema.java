package com.fepoc.vf.json.schema;
import java.util.List;

public class JsonSchema {
	private String id;
	private JsonProperty<?> property;
	private String title;
	private String description;
	private String defaultT;
	private List<Object> examples;
	private String comments;
	private List<JsonProperty<?>> definitions;
	private List<JsonProperty<?>> allOf;
	private List<JsonProperty<?>> anyOf;
	private List<JsonProperty<?>> oneOf;
	private List<JsonProperty<?>> not;
	
	public JsonProperty<?> getProperty() {
		return property; 
	}

	public void setProperty(JsonProperty<?> property) {
		this.property = property;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDefaultT() {
		return defaultT;
	}

	public void setDefaultT(String defaultT) {
		this.defaultT = defaultT;
	}

	public List<Object> getExamples() {
		return examples;
	}

	public void setExamples(List<Object> examples) {
		this.examples = examples;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public List<JsonProperty<?>> getDefinitions() {
		return definitions;
	}

	public void setDefinitions(List<JsonProperty<?>> definitions) {
		this.definitions = definitions;
	}

	public List<JsonProperty<?>> getAllOf() {
		return allOf;
	}

	public void setAllOf(List<JsonProperty<?>> allOf) {
		this.allOf = allOf;
	}

	public List<JsonProperty<?>> getAnyOf() {
		return anyOf;
	}

	public void setAnyOf(List<JsonProperty<?>> anyOf) {
		this.anyOf = anyOf;
	}

	public List<JsonProperty<?>> getOneOf() {
		return oneOf;
	}

	public void setOneOf(List<JsonProperty<?>> oneOf) {
		this.oneOf = oneOf;
	}

	public List<JsonProperty<?>> getNot() {
		return not;
	}

	public void setNot(List<JsonProperty<?>> not) {
		this.not = not;
	}

	public String toSchema() {
		return new StringBuilder()
		.append("{ \n")
		.append("\"$schema\": \"http://json-schema.org/schema#\"\n")
		.append("\"$id\": ").append(JsonUtil.quote(getId())).append("\n")
		.append(getProperty().toType())
		.append(" } ")
		.toString();		
	}
}

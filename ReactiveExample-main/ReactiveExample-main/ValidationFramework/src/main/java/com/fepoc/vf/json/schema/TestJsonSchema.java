package com.fepoc.vf.json.schema;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;

public class TestJsonSchema {

	public static void main(String [] args) {
		JsonSchema schema = new JsonSchema();
		schema.setId("http://yourdomain.com/schemas/myschema.json");
		JsonProperty<JsonObject> root = JsonProperty.createObject("properties", null);
		schema.setProperty(root );
		schema.getProperty().setProperties(new ConcurrentHashMap<>());
		List<JsonProperty<?>> values = new CopyOnWriteArrayList<>();
		values.add(JsonProperty.createString("first_name", null));
		values.add(JsonProperty.createString("last_name", null));
		JsonProperty<JsonObject> addr = JsonProperty.createObject("address", null);
		addr.setProperties(new ConcurrentHashMap<>());

		JsonString jstring = new JsonString();
		jstring.setMinLength(10);
		jstring.setMaxLength(30);
		addr.getProperties().put("properties", 
				Arrays.asList(new JsonProperty<?>[] {
						JsonProperty.createString("street_addr", jstring),
						JsonProperty.createString("city", null),
						JsonProperty.createString("state", null),
						JsonProperty.createString("country", null),
						}));
		values.add(addr );
		schema.getProperty().getProperties().put("properties", values );
		
		System.out.println(schema.toSchema());
	}
}

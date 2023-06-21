package com.fepoc.vf.json.schema;

import java.util.List;
import java.util.Arrays;

public enum FormatType {
	dateAndTime("dateTime", Arrays.asList(new String[] {"date-time", "time", "date"})),
	emailAddress("emailAddress", Arrays.asList(new String[] {"email", "idn-email"})),
	hostnames("hosynames", Arrays.asList(new String[] {"hostname", "idn-hostname"})),
	ipAddresses("ipAddresses", Arrays.asList(new String[] {"ipv4", "ipv6"})),
	resourceIdentifier("resourceIdentifier", Arrays.asList(new String[] {"uri", "uri-reference", "iri", "iri-reference"})),
	uriTemplate("uriTemplate", Arrays.asList(new String[] {"uri-template"})),
	jsonPointer("jsonPointer", Arrays.asList(new String[] {"json-pointer", "relative-json-pointer"})),
	regularExpression("regularExpression", Arrays.asList(new String[] {"regex"})),
	;
	
	String name;
	List<String> formats;
	
	FormatType(String name, List<String> formats) {
		this.name = name;
		this.formats = formats;
	}
}

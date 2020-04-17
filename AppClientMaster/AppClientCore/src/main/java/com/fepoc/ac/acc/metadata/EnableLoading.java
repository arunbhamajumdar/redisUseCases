package com.fepoc.ac.acc.metadata;

import java.util.Map;

public interface EnableLoading {
	String getApplicationName();
	String getApplicationVersion();
	Map<Class<?>,String> getTags();
	void load();
}

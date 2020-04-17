package com.fepoc.ac.acc.annotation;

import java.util.Map;

public class TmpEntry<K,V> implements Map.Entry<K, V>{
	private K key;
	private V value;
	
	public TmpEntry(K k, V v) {
		this.key =k;
		this.value =v;
	}
	@Override
	public K getKey() {
		return key;
	}

	@Override
	public V getValue() {
		return value;
	}

	@Override
	public V setValue(V value) {
		this.value = value;
		return this.value;
	}
	
}
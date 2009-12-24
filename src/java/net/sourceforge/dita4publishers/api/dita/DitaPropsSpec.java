/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Represents a unique set of DITA properties (@props values).
 * 
 */
public class DitaPropsSpec {

	private Map<String, Set<String>> propertyValues = new HashMap<String, Set<String>>();

	/**
	 * @param propName
	 * @param propVal
	 */
	public void addPropValue(String propName, String propVal) {
		if (!this.propertyValues .containsKey(propName)) {
			this.propertyValues.put(propName, new HashSet<String>());
		}
		Set<String> values = this.propertyValues.get(propName);
		values.add(propVal);
	}

	/**
	 * @return
	 */
	public List<String> getProperties() {
		List<String> result = new ArrayList<String>();
		result.addAll(propertyValues.keySet());
		return result;
	}

	/**
	 * @param propName
	 * @return
	 */
	public Set<String> getPropertyValues(String propName) {
		if (this.propertyValues.containsKey(propName))
			return this.propertyValues.get(propName);
		return new HashSet<String>();
	}

}

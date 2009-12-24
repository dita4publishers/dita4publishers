/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Represents a unique set of DITA properties (@props values).
 * <p>Two DitaPropsSpecs are equal if they define the same
 * set of values for the same set of property names.</p>
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
	public Set<String> getProperties() {
		return propertyValues.keySet();
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
	
	public boolean equals(DitaPropsSpec cand) {
		boolean result = false;
		if (this.propertyValues.keySet().equals(cand.getProperties())) {
			result = true;
			for (String propName : this.propertyValues.keySet()) {
				Set<String> values = this.propertyValues.get(propName);
				if (!cand.getPropertyValues(propName).equals(values))
					return false;
			}
		}
		return result;
	}



}

/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
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

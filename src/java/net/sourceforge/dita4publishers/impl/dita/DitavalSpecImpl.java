/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.dita4publishers.api.dita.DitavalSpec;

/**
 * Ditaval specification implementation.
 */
public class DitavalSpecImpl implements DitavalSpec {
	
	public enum ActionType {
		inclusion,
		exclusion;
	}
	
	protected Map<String, List<String>> exclusions = new HashMap<String, List<String>>();
	protected Map<String, List<String>> inclusions = new HashMap<String, List<String>>();
	protected ActionType defaultPropertyAction = ActionType.inclusion;
	protected Map<String, ActionType> defaultPropertyActions = new HashMap<String, ActionType>();

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitavalSpec#addExclusion(java.lang.String, java.lang.String)
	 */
	public void addExclusion(String property, String value) {
		if (property == null) {
			if (value == null)
				defaultPropertyAction = ActionType.exclusion;
			return;
		}
		if (value == null) {
			defaultPropertyActions.put(property, ActionType.exclusion);
			return;
		}
		
		List<String> valueList = null;
		if (!this.exclusions.containsKey(property)) {
			valueList = new ArrayList<String>();
			this.exclusions.put(property, valueList);
		}
		valueList = this.exclusions.get(property);
		if (!valueList.contains(value))
			valueList.add(value);
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitavalSpec#isExcluded(java.lang.String, java.lang.String)
	 */
	public boolean isExcluded(String propName, String value) {
		if (this.exclusions.containsKey(propName)) {
			List<String> cands = this.exclusions.get(propName);
			return cands.contains(value);
		}
		if (this.inclusions.containsKey(propName)) {
			if (this.inclusions.get(propName).contains(value))
				return false;
		}
		if (this.defaultPropertyActions.containsKey(propName)) {
			return this.defaultPropertyActions.get(propName).equals(ActionType.exclusion);
		}
		return this.defaultPropertyAction.equals(ActionType.exclusion);
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitavalSpec#addInclusion(java.lang.String, java.lang.String)
	 */
	public void addInclusion(String property, String value) {
		if (property == null) {
			if (value == null)
				defaultPropertyAction = ActionType.inclusion;
			return;
		}
		if (value == null) {
			defaultPropertyActions.put(property, ActionType.inclusion);
			return;
		}
		
		List<String> valueList = null;
		if (!this.inclusions.containsKey(property)) {
			valueList = new ArrayList<String>();
			this.inclusions.put(property, valueList);
		}
		valueList = this.inclusions.get(property);
		if (!valueList.contains(value))
			valueList.add(value);
		if (this.exclusions.containsKey(property)) {
			if (this.exclusions.get(property).contains(value))
				this.exclusions.get(property).remove(value);
		}
	}
	
}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
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
	
	protected Map<String, List<String>> exclusions = new HashMap<String, List<String>>();

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitavalSpec#addExclusion(java.lang.String, java.lang.String)
	 */
	public void addExclusion(String property, String value) {
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
		return false;
	}

}

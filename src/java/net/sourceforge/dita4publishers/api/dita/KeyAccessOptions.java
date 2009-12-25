/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.HashMap;
import java.util.Map;

import net.sourceforge.dita4publishers.api.PropertyContainer;
import net.sourceforge.dita4publishers.impl.dita.DitavalSpecImpl;


/**
 * Bean that holds options used to configure how keys
 * in a key space are accessed. In particular, 
 * allows use or non use of filter conditions. Could
 * also hold properties for access control (e.g., 
 * user, session, credentials, etc.).
 */
public class KeyAccessOptions implements PropertyContainer {

	/**
	 * 
	 */
	public static final String DITAVAL_SPEC_PROP = "ditavalSpec";
	private Map<String, Object> properties = new HashMap<String, Object>();

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.PropertyContainer#getPropertyMap()
	 */
	public Map<String, Object> getPropertyMap() {
		return this.properties;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.PropertyContainer#getPropertyValue(java.lang.String)
	 */
	public Object getPropertyValue(String name) {
		return this.properties.get(name);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.PropertyContainer#setProperty(java.lang.String, java.lang.Object)
	 */
	public void setProperty(String name, Object value) {
		this.properties.put(name, value);
	}

	/**
	 * @param name
	 * @param default
	 * @return
	 */
	public String getProperty(String name, String defaultValue) {
		if (this.properties.containsKey(name))
			return (String)this.properties.get(name);
		return defaultValue;
	}

	/**
	 * @param name
	 * @return
	 */
	public String getProperty(String name) {
		return (String)this.properties.get(name);
	}

	/**
	 * @param ditavalSpec
	 */
	public void setDitavalSpec(DitavalSpec ditavalSpec) {
		this.setProperty(DITAVAL_SPEC_PROP, ditavalSpec);
	}
	
	public DitavalSpec getDitavalSpec() {
		return (DitavalSpec)this.getPropertyValue(DITAVAL_SPEC_PROP);
	}

	/**
	 * Add a DITA value exclusion
	 * @param propName
	 * @param value
	 */
	public void addExclusion(String propName, String value) {
		DitavalSpec spec = getDitavalSpec();
		if (spec == null) {
			spec = new DitavalSpecImpl();
			this.setDitavalSpec(spec);
		}
		spec.addExclusion(propName, value);
	}

	/**
	 * Add a DITA value exclusion
	 * @param propName
	 * @param value
	 */
	public void addInclusion(String propName, String value) {
		DitavalSpec spec = getDitavalSpec();
		if (spec == null) {
			spec = new DitavalSpecImpl();
			this.setDitavalSpec(spec);
		}
		spec.addInclusion(propName, value);
	}


}

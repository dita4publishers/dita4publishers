/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.HashMap;
import java.util.Map;

import net.sourceforge.dita4publishers.api.PropertyContainer;


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


}

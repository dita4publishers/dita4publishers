/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.util.HashMap;
import java.util.Map;

import net.sourceforge.dita4publishers.api.PropertyContainer;

/**
 * Holds options used to configure DITA map importing.
 */
public class DitaMapImportOptions implements PropertyContainer {

	private static final String MISSING_GRAPHIC_URI_OPTION = "missingGraphicUri";
	private Map<String, Object> properties = new HashMap<String, Object>();
	private boolean validate = true;

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
	 * @param defaultValue
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
	 * @param b
	 */
	public void setValidate(boolean b) {
		this.validate  = b;
	}

	/**
	 * @param uriString
	 */
	public void setMissingGraphicUri(String uriString) {
		this.setProperty(MISSING_GRAPHIC_URI_OPTION, uriString);
	}


	/**
	 * @return True if validation has been turned on.
	 */
	public boolean getValidate() {
		return this.validate;
	}

}

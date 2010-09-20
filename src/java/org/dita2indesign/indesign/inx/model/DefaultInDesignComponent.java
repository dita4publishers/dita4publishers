/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;


import java.util.Map.Entry;

import org.apache.log4j.Logger;


/**
 * Base for all InDesign components. A component
 * is just a set of properties. 
 */
public class DefaultInDesignComponent extends InDesignComponent {

	Logger logger = Logger.getLogger(DefaultInDesignComponent.class);

	/**
	 * 
	 */
	public DefaultInDesignComponent() {
		super();
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		InxValueList ptagValue = new InxValueList();
		for (Entry<String, String> entry : this.tags.entrySet()) {
			InxValueList labelItem = new InxValueList();
			InxString key = new InxString(entry.getKey());
			InxString value = new InxString(entry.getValue());
			labelItem.add(key);
			labelItem.add(value);
			ptagValue.add(labelItem);
		}
		this.setProperty(InDesignDocument.PROP_PTAG,ptagValue);
	}
	
	
	
}

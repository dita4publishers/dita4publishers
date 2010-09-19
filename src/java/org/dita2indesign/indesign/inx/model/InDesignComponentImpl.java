/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;


import org.apache.log4j.Logger;


/**
 * Base for all InDesign components. A component
 * is just a set of properties. 
 */
public class InDesignComponentImpl extends InDesignComponent {

	Logger logger = Logger.getLogger(InDesignComponentImpl.class);

	/**
	 * 
	 */
	public InDesignComponentImpl() {
		super();
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		// Nothing to do for generic components.
	}
	
	
	
}

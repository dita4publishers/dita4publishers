/**
 * 
 */
package org.dita2indesign.indesign.inx.model;

import org.w3c.dom.Element;

/**
 * Generic object for which no special business logic is implemented.
 */
public class DefaultInDesignObject extends InDesignObject {

	/**
	 * 
	 */
	public DefaultInDesignObject() {
		super();
	}

	/**
	 * @param dataSource
	 * @throws Exception
	 */
	public DefaultInDesignObject(Element dataSource) throws Exception {
		super(dataSource);
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		super.updatePropertyMap();
	}

}

/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

import java.util.Map;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;




/**
 * Base class for InDesign objects (components that have IDs).
 * 
 * Used for objects for which no more specific class is available.
 */
public class InDesignObject extends AbstractInDesignObject {

	private static Logger logger = Logger.getLogger(InDesignObject.class);

	/**
	 * 
	 */
	public InDesignObject() {
		super();
	}

	/**
	 * @param dataSource
	 * @throws Exception 
	 */
	public InDesignObject(Element dataSource) throws Exception {
		this.loadObject(dataSource);
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.AbstractInDesignObject#loadObject(org.dita2indesign.indesign.inx.model.InDesignObject)
	 */
	@Override
	public void loadObject(InDesignObject sourceObj) throws Exception {
		String id = this.getId(); // If ID has been assigned, we don't want to inherent
		this.setDataSource((Element)sourceObj.getDataSourceElement().cloneNode(true));
		                          // the ID of our clone source.
		logger.debug("loadObject(): id=" + id);
		if (this.getDataSourceElement() != null) {
			this.loadObject(this.getDataSourceElement());
			if (id != null) {
				logger.debug("loadObject(): setting ID to " + id);
				this.setId(id); // Make sure we use any assigned object ID.
			}
		}
		// If there is no datasource element, then it's the responsibility of subclasses to do the cloning
		// appropriately.
	}

	/**
	 * @param label
	 * @param value
	 */
	public void insertLabel(String label, String value) {
		this.tags.put(label, value);
		
	}

	/**
	 * @param label
	 * @return
	 */
	public String extractLabel(String label) {
		if (this.tags.containsKey(label)) {
			return this.tags.get(label);
		}
		return null;
	}

	/**
	 * @return
	 */
	public Map<String, String> getLabels() {
		return this.tags;
	}




}

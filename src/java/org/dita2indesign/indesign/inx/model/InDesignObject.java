/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;


import org.apache.log4j.Logger;
import org.w3c.dom.Element;




/**
 * Base class for InDesign objects (components that have IDs).
 * 
 * Used for objects for which no more specific class is available.
 */
public abstract class InDesignObject extends DefaultInDesignComponent {

	private static Logger logger = Logger.getLogger(InDesignObject.class);
	private String id;
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
		logger.debug("Constructing a new InDesignObject from data source " + dataSource.getNodeName() + "...");
		this.loadObject(dataSource);
	}

	/**
	 * @return ID, if there is one, otherwise returns null. Not all objects have IDs.
	 */
	public String getId() {
		return this.id;
	}

	/**
	 * @param dataSource
	 * @throws InDesignDocumentException 
	 */
	public void loadObject(Element dataSource) throws Exception {
		if (dataSource == null) return;
		super.loadComponent(dataSource);
	}

	/**
	 * Load an object from an existing object, assigning the new object ID.
	 * @param sourceObj
	 * @param newObjectId
	 * @throws Exception
	 */
	public void loadObject(InDesignComponent sourceObj, String newObjectId) throws Exception {
		loadComponent((InDesignComponent)sourceObj);
		
		this.setId(newObjectId);
	}

	/**
	 * @param id
	 */
	public void setId(String id) {	
		this.id = id;
		this.setStringProperty(InDesignDocument.PROP_SELF, id);
	}


}

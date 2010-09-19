/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;




/**
 * Base class for InDesign objects (components that have IDs).
 * 
 * Used for objects for which no more specific class is available.
 */
public abstract class InDesignObject extends InDesignComponent {

	private static Logger logger = Logger.getLogger(InDesignObject.class);
	private String id;
	protected Map<String, String> tags = new HashMap<String, String>();

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

	public void loadObject(InDesignObject sourceObj, String newObjectId) throws Exception {
		loadComponent((InDesignComponent)sourceObj);
		this.setId(newObjectId);
	}

	/**
	 * @return
	 */
	public String getLabel() {
		return this.tags.get(InDesignDocument.TAG_KEY_LABEL);
	}

	/**
	 * @param id
	 */
	public void setId(String id) {	
		this.id = id;
		this.setStringProperty(InDesignDocument.PROP_SELF, id);
	}


}

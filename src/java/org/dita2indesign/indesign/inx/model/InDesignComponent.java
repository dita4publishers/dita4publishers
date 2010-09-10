/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;


/**
 * Base for all InDesign components. A component
 * is just a set of properties. InDesign objects,
 * which extend components, have unique IDs and may
 * be referenced by other objects or components.
 */
public class InDesignComponent {

	Logger logger = Logger.getLogger(this.getClass());

	private InDesignComponent parent;
	private Element dataSourceElement;
	private List<InDesignComponent> childObjects = new ArrayList<InDesignComponent>();
	private Map<String, Object> properties = new HashMap<String, Object>();
	private InDesignDocument document;


	/**
	 * 
	 */
	public InDesignComponent() {
	}
	
	/**
	 * Load any subcomponents of the component.
	 * @param dataSource
	 * @throws Exception
	 */
	public void loadComponent(Element dataSource) throws Exception {
		this.setDataSource(dataSource);
		
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(dataSource);
		// Process all child objects.
		// Subclasses that need to do additional things with children must
		// iterate over their children and do whatever they need to do.
		while (elemIter.hasNext()) {
			Element child = elemIter.next();
			// logger.debug("loadObject(): Input element is <" + child.getNodeName() + ">");
			 InDesignComponent obj = this.getDocument().newInDesignComponent(child);
			 this.addChild(obj);
		}
		
	}

	/**
	 * @param dataSource
	 * @throws InDesignDocumentException 
	 * @throws Exception 
	 */
	public void setDataSource(Element dataSource) throws Exception {
		this.dataSourceElement = dataSource;
		this.componentLoad();
	}
	

	/**
	 * @param run
	 */
	public void addChild(InDesignComponent child) {
		this.childObjects.add(child);
		child.setParent(this);
	}

	/**
	 * @param run
	 */
	protected void addChild(InDesignObject child) {
		addChild((InDesignComponent)child);
		child.setParent(this);
	}


	/**
	 * Load the properties of the datasource element (but not any child elements)
	 * @throws Exception 
	 * 
	 */
	protected void componentLoad() throws Exception {
		Element dataSource = this.getDataSourceElement();
		NamedNodeMap atts = dataSource.getAttributes();
		for (int i = 0; i < atts.getLength(); i++) {
			Node node = atts.item(i);
			String rawValue = node.getNodeValue();
			InxValue value = null;
			try {
				value = InxHelper.newValue(rawValue);
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
			this.properties.put(node.getNodeName(), value);
		}

	}

	/**
	 * @return
	 */
	public Element getDataSourceElement() {
		return this.dataSourceElement;
	}

	/**
	 * Set the parent for the object (e.g., when adding it to an existing structure.
	 * @param inDesignObject
	 */
	public void setParent(InDesignComponent parent) {
		this.parent = parent;
	}

	/**
	 * @param propName
	 * @return
	 */
	public boolean hasProperty(String propName) {
		return this.properties.containsKey(propName);
	}

	
	/**
	 * Returns the containing document for the component.
	 * @return Containing document or null if the component is not associated with a document.
	 */
	protected InDesignDocument getDocument() {
		return this.document;
	}

	/**
	 * @return
	 */
	public InDesignComponent getParent() {
		return this.parent;
	}

	/**
	 * @param document
	 */
	public void setDocument(InDesignDocument document) {
		this.document = document;
	}

	/**
	 * @param propPagc
	 * @return
	 * @throws Exception 
	 */
	protected long getLongProperty(String attName) throws Exception {
		long value = -1L;
		if (this.getDataSourceElement().hasAttribute(attName)) 
			value = InxHelper.decodeRawValueToSingleLong(this.getDataSourceElement().getAttribute(attName));
		return value;
	}

	/**
	 * @param propPagc
	 * @return
	 * @throws Exception 
	 */
	protected double getDoubleProperty(String attName) throws Exception {
		double value = -1.0;
		if (this.getDataSourceElement().hasAttribute(attName)) 
			value = InxHelper.decodeRawValueToSingleDouble(this.getDataSourceElement().getAttribute(attName));
		return value;
	}

	/**
	 * @param propSelf
	 * @return
	 * @throws Exception 
	 */
	protected String getStringProperty(String attName) throws Exception {
		if (this.getDataSourceElement().hasAttribute(attName)) {
			return InxHelper.decodeRawValueToSingleString(this.getDataSourceElement().getAttribute(attName));
		}
		return null;
	}

	/**
	 * @param object
	 */
	protected void registerObject(InDesignObject object) {
		this.getDocument().registerObject(object);
	}

	/**
	 * @param attName
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public Enum getEnumProperty(String attName) throws Exception {
		if (this.getDataSourceElement().hasAttribute(attName)) {
			String rawValue = InxHelper.decodeRawValueToSingleString(this.getDataSourceElement().getAttribute(attName));
			return InxEnums.getEnumForRawProperty(attName, rawValue);
		}
		return null;
	}

	/**
	 * @param attName
	 * @return
	 * @throws Exception 
	 */
	protected List<InxValue> getValueListProperty(String attName) throws Exception {
		if (this.getDataSourceElement().hasAttribute(attName)) {
			return InxHelper.decodeRawValueToList(this.getDataSourceElement().getAttribute(attName));
		}
		return null;
	}

	/**
	 * @param attName
	 * @return
	 * @throws Exception 
	 */
	protected boolean getBooleanProperty(String attName) throws Exception {
		if (this.getDataSourceElement().hasAttribute(attName)) {
			return InxHelper.decodeRawValueToBoolean(this.getDataSourceElement().getAttribute(attName));
		}
		return false;
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/**
	 * @return
	 */
	public List<InDesignComponent> getChildren() {
		return this.childObjects;
	}


}

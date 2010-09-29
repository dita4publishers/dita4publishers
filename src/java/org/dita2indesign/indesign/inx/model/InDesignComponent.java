/**
 * 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;

/**
 * Base class for InDesign components.
 */
public abstract class InDesignComponent {

	private InDesignComponent parent;
	private List<InDesignComponent> childObjects = new ArrayList<InDesignComponent>();
	private Map<String, InxValue> properties = new HashMap<String, InxValue>();
	private InDesignDocument document;
	private String inxTagname = null;
	protected Map<String, String> tags = new HashMap<String, String>();

	/**
	 * Load any subcomponents of the component.
	 * @param dataSource
	 * @throws Exception
	 */
	public void loadComponent(Element dataSource) throws Exception {
		loadPropertiesFromDataSource(dataSource);
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(dataSource);
		
		// Process all child components.
		// Subclasses that need to do additional things with children must
		// iterate over their children and do whatever they need to do.
		while (elemIter.hasNext()) {
			Element child = elemIter.next();
			// logger.debug("loadObject(): Input element is <" + child.getNodeName() + ">");
			 InDesignComponent obj = this.getDocument().newInDesignComponent(child);
			 this.addChild(obj);
		}
		
		setTagsFromPtagProperty();
		
	}

	/**
	 * @throws Exception
	 */
	protected void setTagsFromPtagProperty() throws Exception {
		// Value is a list of lists, each sublist being a key/value pair.
		InxValueList propValue = (InxValueList)getPropertyValue(InDesignDocument.PROP_PTAG);
		if (propValue != null) {
			Iterator<InxValue> iter = ((InxValueList)propValue).getItems().iterator();
			while (iter.hasNext()) {
				InxValueList tag = (InxValueList)iter.next();
				String label = tag.getItems().get(0).toString();
				String value = tag.getItems().get(1).toString();
				this.tags.put(label, value);
			}
		}
	}

	/**
	 * @param dataSource
	 * @throws Exception 
	 */
	private void loadPropertiesFromDataSource(Element dataSource) throws Exception {
		this.inxTagname = dataSource.getNodeName();
		NamedNodeMap atts = dataSource.getAttributes();
		for (int i = 0; i < atts.getLength(); i++) {
			Attr att = (Attr)atts.item(i);
			String rawValue = att.getNodeValue();
			InxValue value = null;
			try {
				value = InxHelper.newValue(rawValue);
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
			this.properties.put(att.getNodeName(), value);			
		}
	}
	
	/**
	 * @param run
	 * @throws Exception 
	 */
	public void addChild(InDesignComponent child) throws Exception {
		this.childObjects.add(child);
		child.setParent(this);
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
	 * 
	 * @param propName
	 * @return
	 * @throws Exception 
	 */
	protected long getLongProperty(String propName) throws Exception {
		InxValue valueObj = getValueObject(propName);
		if (valueObj == null) return 0L;
		if (valueObj instanceof InxLongBase) {
			return ((InxLongBase)valueObj).getValue().longValue();
		}
		throw new Exception("Property named \"" + propName + "\" is not a long value");
	}

	/**
	 * @param propName
	 * @return
	 */
	public InxValue getValueObject(String propName) {
		InxValue valueObj = null;
		if (this.properties.containsKey(propName)) { 
			 valueObj = this.properties.get(propName);
		}
		return valueObj;
	}

	/**
	 * @param propPagc
	 * @return
	 * @throws Exception 
	 */
	public double getDoubleProperty(String propName) throws Exception {
		InxValue valueObj = getValueObject(propName);
		if (valueObj == null) return 0.0;
		if (valueObj instanceof InxDouble) {
			return ((InxDouble)valueObj).getValue().doubleValue();
		}
		throw new Exception("Property named \"" + propName + "\" is not a double value");
	}

	/**
	 * @param propName
	 * @return
	 * @throws Exception 
	 */
	public String getStringProperty(String propName) throws Exception {
		InxValue valueObj = getValueObject(propName);
		if (valueObj == null) return null;
		if (valueObj instanceof InxString) {
			return ((InxString)valueObj).getValue();
		}
		throw new Exception("Property named \"" + propName + "\" is not a String value");
	}

	/**
	 * @param propName
	 * @return
	 * @throws Exception 
	 */
	public Map<String, String> getStringMapListProperty(String propName) throws Exception {
		InxValue valueObj = getValueObject(propName);
		if (valueObj == null) return null;
		if (valueObj instanceof InxStringMap) {
			return ((InxStringMap)valueObj).getValue();
		}
		throw new Exception("Property named \"" + propName + "\" is not a string map value");
	}

	/**
	 * @param propSelf
	 * @return
	 * @throws Exception 
	 */
	protected String getObjectReferenceProperty(String propName) throws Exception {
		InxValue valueObj = getValueObject(propName);
		if (valueObj == null) return null;
		if (valueObj instanceof InxObjectRef) {
			return ((InxObjectRef)valueObj).getValue();
		}
		throw new Exception("Property named \"" + propName + "\" is not an Object Reference value");
	}

	/**
	 * @param object
	 */
	protected void registerObject(InDesignObject object) {
		this.getDocument().registerObject(object);
	}

	/**
	 * @param propName
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public Enum getEnumProperty(String propName) throws Exception {
		if (this.properties.containsKey(propName)) {
		}
		return null;
	}

	/**
	 * @param propName
	 * @return
	 * @throws Exception 
	 */
	protected List<? extends InxValue> getValueListProperty(String propName) throws Exception {
		InxValue valueObj = getValueObject(propName);
		if (valueObj == null) return null; // Should we return empty list?
		if (valueObj instanceof InxValueList) {
			return ((InxValueList)valueObj).getValue();
		}
		throw new Exception("Property named \"" + propName + "\" is not a value list");
	}

	/**
	 * @param attName
	 * @return
	 * @throws Exception 
	 */
	protected boolean getBooleanProperty(String attName) throws Exception {
		if (this.properties.containsKey(attName)) {
			return ((InxBoolean)properties.get(attName)).getValue().booleanValue();
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

	public void setStringProperty(String propName, String value) {
		InxString inxValue = new InxString(value);
		this.properties.put(propName, inxValue);
	}

	/**
	 * Gets full property map for this component.
	 * @return The component's property map.
	 */
	public Map<String, InxValue> getPropertyMap() {
		// updatePropertyMap();
		return this.properties;
	}

	/**
	 * Gets the Inx value of the specified property.
	 * @param propName The property to get the value of.
	 * @return InxValue object for the property, if it exists.
	 */
	public InxValue getPropertyValue(String propName) {
		return this.properties.get(propName);
	}

	/**
	 * Sets the specified property to the provided value.
	 * @param propName Name of the property to set.
	 * @param value The INX value to set.
	 */
	public void setProperty(String propName, InxValue value) {
		this.properties.put(propName, value);
	}

	/**
	 * @return
	 */
	public String getInxTagName() {
		return inxTagname;
	}

	/**
	 * Sets a property from raw INX value.
	 * @param propName Property to be set.
	 * @param rawValue Value to use.
	 */
	public void setPropertyFromRawValue(String propName, String rawValue)
			throws Exception {
				InxValue value = InxHelper.newValue(rawValue);
				this.setProperty(propName, value);
			}

	/**
	 * Updates the component's property map with any dynamic properties.
	 * @throws Exception
	 */
	public abstract void updatePropertyMap() throws Exception;

	/**
	 * @param sourceObj
	 * @throws Exception 
	 */
	protected void loadComponent(InDesignComponent sourceObj) throws Exception {
		this.inxTagname = sourceObj.getInxTagName();
		if (sourceObj != null) {
			for (String propName : sourceObj.getPropertyMap().keySet()) {
				this.setProperty(propName, sourceObj.getPropertyValue(propName));
			}
		}
		setTagsFromPtagProperty();
		for (InDesignComponent child : sourceObj.getChildren()) {
			InDesignComponent newChild = this.getDocument().clone(child);
			addChild(newChild);
		}		
	}

	/**
	 * @param propName
	 * @param geometry
	 */
	public void setGeometryProperty(String propName, Geometry geometry) {
		InxValue geometryValue = new InxGeometry(geometry);
		this.setProperty(propName, geometryValue);
		
	}

	/**
	 * Sets the INX tagname to use for this component.
	 * @param tagName The XML tag name to use.
	 */
	public void setInxTagName(String tagName) {
		this.inxTagname = tagName;
	}
	
	/**
	 * Get the name of the object.
	 * @return Name value, possibly null.
	 * @throws Exception 
	 */
	public String getPName() throws Exception {
		return this.getStringProperty(InDesignDocument.PROP_PNAM);
	}

	/**
	 * @param name
	 */
	protected void setPName(String name) {
		this.setStringProperty(InDesignDocument.PROP_PNAM, name);
	}

	/**
	 * Set a property that is a reference to an object.
	 * @param propName
	 * @param targetObj
	 */
	public void setObjectReferenceProperty(String propName, InDesignObject targetObj) {		
		InxValue objRef = new InxObjectRef((targetObj != null ? targetObj.getId() : "n"));
		setProperty(propName, objRef);
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
	 * @return
	 */
	public String getLabel() {
		String label = this.tags.get(InDesignDocument.TAG_KEY_LABEL);
		if (label == null) label = "";
		return label;
	}

	/**
	 * Returns true if the component is marked as overrideable.
	 * @return True if component can be overridden.
	 * @throws Exception 
	 */
	public boolean isOverrideable() throws Exception {
		return getBooleanProperty("ovbl");
	}



}

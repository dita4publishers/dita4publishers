/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  
 */
package org.dita2indesign.indesign.inx.model;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Element;


/**
 * Abstract supertype for all InDesign objects
 */
public abstract class AbstractInDesignObject extends InDesignComponent {

	private String id;
	private String pnam = null;
	protected Map<String, String> tags = new HashMap<String, String>();

	/**
	 * 
	 */
	public AbstractInDesignObject() {
		super();
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
	public void setDataSource(Element dataSource) throws Exception {
		super.setDataSource(dataSource);
		this.objectLoad();
	}

	/**
	 * @throws Exception 
	 * 
	 */
	protected void objectLoad() throws Exception {
		this.id = getSelfProperty(InDesignDocument.PROP_SELF);
		// logger.debug(" + objectLoad(): Setting ID to \"" + this.id + "\"");
		this.pnam = getStringProperty(InDesignDocument.PROP_PNAM);
		// logger.debug(" + objectLoad(): Setting PName to \"" + this.pnam + "\"");
		this.tags  = getStringMapListProperty(InDesignDocument.PROP_PTAG);
		// logger.debug(" + objectLoad(): Setting PName to \"" + this.pnam + "\"");
		
	}

	/**
	 * Gets properties that are lists of name/value pairs, returning a map of strings to strings.
	 * @param attName
	 * @return
	 * @throws Exception 
	 */
	private Map<String, String> getStringMapListProperty(String attName) throws Exception {
		if (this.getDataSourceElement().hasAttribute(attName)) {
			return InxHelper.decodeRawValueToStringMap(this.getDataSourceElement().getAttribute(attName));
		}
		return new HashMap<String, String>();
	}

	/**
	 * @param propSelf
	 * @return
	 * @throws Exception 
	 */
	private String getSelfProperty(String attName) throws Exception {
		
		if (this.getDataSourceElement().hasAttribute(attName)) {
			return InxHelper.decodeRawValueToSingleObjectId(this.getDataSourceElement().getAttribute(attName));
		}
		return null;
	}

	/**
	 * @param dataSource
	 * @throws InDesignDocumentException 
	 */
	public void loadObject(Element dataSource) throws Exception {
		if (dataSource == null) return;
		// logger.debug("loadObject(): loading from data source element \"" + dataSource.getNodeName() + "\"");
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
	 * @return
	 */
	public String getPName() {
		return this.pnam;
	}

	/**
	 * @param object
	 * @param dataSource 
	 * @return
	 * @throws Exception 
	 */
	protected InDesignComponent newObject(InDesignObject object, Element dataSource) throws Exception {
		addChild(object);
		object.loadObject(dataSource);
		return object;
	}

	/**
	 * @return
	 */
	public String getLabel() {
		return this.tags.get(InDesignDocument.TAG_KEY_LABEL);
	}

	/**
	 * @param spreadName
	 */
	protected void setPName(String name) {
		this.pnam = name;
	}

	/**
	 * @param id
	 */
	public void setId(String id) {	
		this.id = id;
	}

	/**
	 * @param sourceObj
	 */
	public abstract void loadObject(InDesignObject sourceObj) throws Exception;
	
	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}



}
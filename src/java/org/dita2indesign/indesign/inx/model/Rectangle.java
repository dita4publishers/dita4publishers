/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;



/**
 * Represents a rectangle, capturing its geometry and other
 * properties.
 */
public class Rectangle extends InDesignRectangleContainingObject {

	static Logger logger = Logger.getLogger(Rectangle.class);

	public Rectangle() throws Exception {
		super();
		this.geometry = new Geometry(0.0, 0.0, 10.0, 10.0);
	}
	
	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.AbstractInDesignObject#loadObject(org.dita2indesign.indesign.inx.model.InDesignObject)
	 */
	@Override
	public void loadObject(InDesignObject sourceObj) throws Exception {
		super.loadObject(sourceObj);
		Rectangle sourceRect = (Rectangle)sourceObj;
		this.geometry = sourceRect.getGeometry();
	} 
	
	public void loadObject(Element dataSource) throws Exception {
		logger.debug("loadObject(): loading from data source element \"" + dataSource.getNodeName() + "\"");
		super.loadObject(dataSource);
		this.geometry = new Geometry(dataSource);
	}

	public String toString() {
		StringBuilder result = new StringBuilder();
		String lbl = this.getLabel();
		result.append(this.getClass().getSimpleName());
		if (lbl != null)
			lbl = " [" + (lbl.length() > 20?lbl.substring(0, 15) + "...":lbl) + "]";
		result.append(lbl);
		result.append(" [");
		result.append(this.getId());
		result.append("] ");
		this.getGeometry().getBoundingBox().reportGeometry(result);
		return result.toString();
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}



}

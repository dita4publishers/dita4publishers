/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Element;




/**
 * Represents a single page.
 */
public class Page extends InDesignRectangleContainingObject {
	
	Logger logger = Logger.getLogger(this.getClass());

	PageSideOption pageSide = PageSideOption.SINGLE_SIDED; // Nominal default;
	
	TransformationMatix transformMatrix = null; // Values determined by size of page bounding box.

	Box boundingBox;

	private String name;

	public void loadObject(Element dataSource) throws Exception {
		super.loadObject(dataSource);
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(dataSource);
		this.name = getStringProperty(InDesignDocument.PROP_PNAM);
		PageSideOption tempPgSide = (PageSideOption)getEnumProperty(InDesignDocument.PROP_PGSD);
		if (tempPgSide != null) { // If null, use default
			pageSide = tempPgSide; 
		}
		setBounds();
		
		while (elemIter.hasNext()) {
			Element child = elemIter.next();
			if (child.getNodeName().equals("imgp")) {
				// Margin preferences.
			} else if (child.getNodeName().equals("Jgda")) {
					// Undocumented
			} else {
				// Unrecognized object type
				logger.debug(" - Unrecognized component type [" + child.getNodeName() + "]");
//				InDesignComponent obj = this.getDocument().newObject(child);
//				this.addChild(obj);
			}
		}

	}

	/**
	 *  Set the page bounds as a Box. This is the position of box in in the
	 *  pasteboard coordinate space.
	 * @throws Exception 
	 */
	protected void setBounds() throws Exception {
		List<InxValue> bounds = getValueListProperty(InDesignDocument.PROP_PBND);
		// Bounds is list of four Units: y1,x1,y2,x2
		boundingBox = new Box();
		if (bounds == null) return;
		double y1 = ((InxUnit)bounds.get(0)).getValue();
		double x1 = ((InxUnit)bounds.get(1)).getValue();
		double y2 = ((InxUnit)bounds.get(2)).getValue();
		double x2 = ((InxUnit)bounds.get(3)).getValue();
		boundingBox.setCorners(x1,y1,x2,y2);

	}

	/**
	 * @return
	 */
	public double getWidth() {
		return this.getBoundingBox().getRectangle2D().getWidth();
	}

	/**
	 * @return
	 */
	public double getHeight() {
		return this.getBoundingBox().getRectangle2D().getHeight();
	}

	/**
	 * @return
	 */
	public PageSideOption getPageSide() {
		return pageSide;
	}

	/**
	 * @return The bounding box for the page.
	 */
	public Box getBoundingBox() {
		return this.boundingBox;
	}

	public String getName() {
		return this.name;
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/**
	 * Override of abstract superclass. Pages are not the parents of the frames
	 * they contain, spreads are.
	 */
	public void addRectangle(Rectangle rect) {
		logger.debug("addRectang(): rect=" + rect);
		this.rectangles.put(rect.getId(), rect);
		if (rect instanceof TextFrame)
			this.frames.put(rect.getId(), (TextFrame)rect);
	}




}

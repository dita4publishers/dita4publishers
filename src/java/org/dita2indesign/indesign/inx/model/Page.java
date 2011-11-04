/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.Iterator;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Element;




/**
 * Represents a single page.
 */
public class Page extends InDesignRectangleContainingObject {
	
	/**
	 * @throws Exception
	 */
	public Page() throws Exception {
		super();
		setInxTagName("page");
	}

	Logger logger = Logger.getLogger(this.getClass());

	PageSideOption pageSide = PageSideOption.SINGLE_SIDED; // Nominal default;
	
	private String name;

	public void loadObject(Element dataSource) throws Exception {
		if (dataSource == null) return;

		super.loadObject(dataSource);
		// NOTE: The bounds of a page are determined by the page width and
		// height set on the document properties held by the InDesignDocument object.
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(dataSource);
		this.name = getStringProperty(InDesignDocument.PROP_PNAM);
		PageSideOption tempPgSide = (PageSideOption)getEnumProperty(InDesignDocument.PROP_PGSD);
		if (tempPgSide != null) { // If null, use default
			pageSide = tempPgSide; 
		}
		
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
	
	public void setWidth(double width)  {
		Double x1 = (this.pageSide.equals(PageSideOption.LEFT_HAND)? 0.0 - width : 0.0);
		Double x2 = (this.pageSide.equals(PageSideOption.LEFT_HAND)? 0.0 : width);
		Double y1 = this.getGeometry().getBoundingBox().getTop();
		Double y2 = this.getGeometry().getBoundingBox().getBottom();
		this.geometry.getBoundingBox().setCorners(x1, y1, x2, y2);
	}

	public void setHeight(double height)  {
		this.getGeometry().setHeight(height);
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
		return this.getGeometry().getBoundingBox();
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

	/**
	 * Sets the page side. Can only be determined in the context
	 * of a sequence of pages within a spread.
	 * @param pageSide
	 */
	public void setPageSide(PageSideOption pageSide) {
		this.pageSide = pageSide;
	}

	/**
	 * @return
	 */
	public MasterSpread getMasterSpread() {
		MasterSpread masterSpread = ((Spread)this.getParent()).getMasterSpread();
		return masterSpread;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		super.updatePropertyMap();
		this.setObjectReferenceProperty(InDesignDocument.PROP_PMAS, getMasterSpread());
	}





}

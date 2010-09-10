/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;

/**
 * Superclass for types that have a geometry property, e.g., rectangles,
 * pages, images.
 */
public class InDesignGeometryHavingObject extends InDesignObject {
	
	static Logger logger = Logger.getLogger(InDesignGeometryHavingObject.class);

	protected Geometry geometry;

	/**
	 * 
	 */
	public InDesignGeometryHavingObject() {
		super();
	}

	/**
	 * @param dataSource
	 * @throws Exception
	 */
	public InDesignGeometryHavingObject(Element dataSource) throws Exception {
		super(dataSource);
	}

	public Geometry getGeometry() {
		return this.geometry;
	}

	/**
	 * @param box
	 * @return
	 */
	public boolean intersects(Box box) {
		if (box == null)
			throw new RuntimeException("box parameter is null");
		if (geometry == null)
			throw new RuntimeException("Rectangle has no geometry");
		Box myBox = geometry.getBoundingBox();
		if (myBox == null)
			throw new RuntimeException("Got null bounding box from non-null Geometry");
		return box.intersects(myBox);
	}

	/**
	 * Apply the Rectangle's transformation matrix to its bounding box to 
	 * to return a new Box in terms of the Pasteboard coordinates.
	 * @return
	 */
	public Box innerToPasteBoard() {
		Box bb = this.getGeometry().getBoundingBox();
		// The rectangle's transform converts to the containing Spread's
		// coordinate space. To get to pasteboard space, must apply the
		// the Spread's transformation matrix. This will translate the 
		// rectangle in the positive vertical direction, one spread
		// depth for each preceding spread in the document.
		Box spreadBox = bb.transform(this.getGeometry().getTransformationMatrix());
		Box pbBox =  spreadBox.transform(((Spread)this.getParent()).getTransformationMatrix());
		return pbBox;
	}

	/**
	 * @return
	 */
	public Box getBoundingBox() {
		return this.getGeometry().getBoundingBox();
	}

	/**
	 * Return a box with the rectangle's coordinates translated to the pasteboard coordinate space.
	 * @return
	 */
	public Box innerToPasteboard() {
		return this.getBoundingBox().transform(this.getGeometry().getTransformationMatrix());
	}

	/**
	 * @return
	 */
	public TransformationMatix getTransformationMatrix() {
		return this.geometry.getTransformationMatrix();
	}

	/**
	 * @param width
	 */
	public void setWidth(double width) {
		this.geometry.setWidth(width);
		
	}

	/**
	 * @param height
	 */
	public void setHeight(double height) {
		this.geometry.setHeight(height);
	}

	/**
	 * @param geometry
	 */
	public void setGeometry(Geometry geometry) {
		this.geometry = geometry;
		if (this.getDataSourceElement() != null) {
			String geoDataString = InxHelper.encodeGeometry(this.getGeometry());
			logger.debug("geoDataString=\"" + geoDataString + "\"");
			this.getDataSourceElement().setAttribute("IGeo", geoDataString);
		}
	}

	/**
	 * Returns true if the rectangle overlaps the page's boundary.
	 * Note that the rectangle need to be completely contained within the page
	 * @param rect
	 * @return
	 */
	public boolean intersects(Rectangle rect) {
		Box pbBox = rect.innerToPasteBoard();
		logger.debug("intersects(): rect.boundingBox     =" + rect.getBoundingBox());
		logger.debug("intersects(): rect's matrix        =" + rect.getTransformationMatrix());
		logger.debug("intersects(): rect's pasteboard Box=" + pbBox);
		logger.debug("intersects(): page's bounding box  =" + this.getBoundingBox());
		logger.debug("intersects(): returning: " + pbBox.intersects(this.getBoundingBox()));
		return pbBox.intersects(this.getBoundingBox());
	}

	/**
	 * @param rect
	 * @return
	 */
	public boolean contains(Rectangle rect) {
		return this.getBoundingBox().contains(rect.getGeometry().getBoundingBox());
	}

}
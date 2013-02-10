/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.awt.geom.Rectangle2D;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;


/**
 * Represents a rectangular box, e.g., a bounding box.
 */
public class Box {
	
	Logger logger = Logger.getLogger(this.getClass());

	private double left = 0.0;
	private double bottom = 0.0;
	private double top = 0.0;
	private double right = 0.0;
	private Rectangle2D rect2D;

	/**
	 * @param boxData A list of 4 double values
	 * @throws Exception 
	 */
	public Box(String boxData) throws Exception {
		List<InxValue> values = InxHelper.decodeRawValueToList(boxData);
		loadData(values, 0);
//		logger.debug("Box(): " + this.toString());
	}

	/**
	 * 
	 */
	public Box() {
	}

	/**
	 * @param left
	 * @param top
	 * @param right
	 * @param bottom
	 */
	public Box(double left, double top, double right, double bottom) {
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
	}

	/**
	 * @param values
	 * @param itemCursor
	 * @return
	 */
	public int loadData(List<InxValue> values, int itemCursor) {
		// On exit, the itemCursor should point to the item after the last
		// item consumed by the path.
		left = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		top = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		right = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		bottom = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		
		return itemCursor;
	}

	protected void constructRectangle2D() {
		double x,y,w,h = 0.0;
		w = right - left;
		h = bottom - top;
		x = (w>=0)?left:left - Math.abs(w);
		y = (h>=0)?top:top - Math.abs(h);
		w = Math.abs(w);
		h = Math.abs(h);
		
		this.rect2D = new Rectangle2D.Double(x,y,w,h);
	}

	/**
	 * @return
	 */
	public double getLeft() {
		return this.left;
	}
	
	/**
	 * @return
	 */
	public double getRight() {
		return this.right;
	}
	
	/**
	 * @return
	 */
	public double getTop() {
		return this.top;
	}
	
	/**
	 * @return
	 */
	public double getBottom() {
		return this.bottom;
	}

	/**
	 * @param box1
	 * @return
	 */
	public boolean intersects(Box box1) {
		Rectangle2D b1Rect = box1.getRectangle2D();
		Rectangle2D myRect = this.getRectangle2D();
		return b1Rect.intersects(myRect);
	}

	/**
	 * @return
	 */
	public Rectangle2D getRectangle2D() {
		if (this.rect2D == null)
			constructRectangle2D();

		return this.rect2D;
	}
	
	public String toString() {
		StringBuilder result = new StringBuilder();
		result.append(this.getClass().getSimpleName());
		this.reportGeometry(result);
		result.append("] Rect2D: ");
		result.append(this.getRectangle2D().toString());
		return result.toString();
	}

	/**
	 * Appends the geometry report to the specified string builder.
	 * @param result StringBuilder to put the report in.
	 * @return
	 */
	public void reportGeometry(StringBuilder result) {
		result.append(" Left: [");
		result.append(this.getLeft());
		result.append("] Top: [");
		result.append(this.getTop());
		result.append("] Right: [");
		result.append(this.getRight());
		result.append("] Bottom: [");
		result.append(this.getBottom());
		result.append("]");
	}

	/**
	 * Returns a string reporting the geometry of the box.
	 * @return
	 */
	public String reportGeometry() {
		StringBuilder result = new StringBuilder();
		reportGeometry(result);
		return result.toString();
	}

	/**
	 * Sets the upper left and lower right corners of the box.
	 * @param x1
	 * @param y1
	 * @param x2
	 * @param y2
	 */
	public void setCorners(double x1, double y1, double x2, double y2) {
		this.left = x1;
		this.top = y1;
		this.right = x2;
		this.bottom = y2;
	    constructRectangle2D();
	}

	/**
	 * @param box
	 * @return
	 */
	public boolean contains(Box box) {
		return this.getRectangle2D().contains(box.getRectangle2D());
	}

	/**
	 * @param matrix
	 * @return
	 */
	public Box transform(TransformationMatix matrix) {
		
		// FIXME: This is bogus because the transform could do a rotation or
		// skew, in which case defining the box as the position of the edges
		// is no good. For now using the opposite corners to set the edge
		// positions.

		PathPoint ul = new PathPoint(this.getLeft(), this.getTop());
		PathPoint newUl = matrix.transform(ul);
		
//		PathPoint ur = new PathPoint(this.getRight(), this.getTop());
//		PathPoint newUr = matrix.transform(ur);
		
		PathPoint lr = new PathPoint(this.getRight(), this.getBottom());
		PathPoint newLr = matrix.transform(lr);
		
//		PathPoint ll = new PathPoint(this.getLeft(), this.getBottom());
//		PathPoint newLl = matrix.transform(ll);
		
		Box newBox = new Box(newUl.getX(),newUl.getY(), newLr.getX(), newLr.getY());
		return newBox;
	}
	
}

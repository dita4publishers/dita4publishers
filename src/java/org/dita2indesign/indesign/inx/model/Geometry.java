/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.awt.geom.Rectangle2D;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;


/**
 * Captures the details of the geometry of an InDesign rectangle
 */
public class Geometry {

	static Logger logger = Logger.getLogger(Geometry.class);

	private List<Path> paths = new ArrayList<Path>();
	private Box boundingBox;
	private TransformationMatix transformMatrix;
	private Box graphicBoundingBox;

	/**
	 * @param dataSource
	 * @throws Exception 
	 */
	public Geometry(Element dataSource) throws Exception {
		if (!dataSource.hasAttribute(InDesignDocument.PROP_IGEO))
			throw new InDesignDocumentException("No " + InDesignDocument.PROP_IGEO + " attribute on data source.") ;
		String rawIGeoValue = dataSource.getAttribute(InDesignDocument.PROP_IGEO);
		loadData(rawIGeoValue);
	}

	public Geometry(Double left, Double top, Double right, Double bottom) throws Exception {
		this.boundingBox = new Box(left, top, right, bottom);
		this.paths.add(new Path(left, top, right, bottom, false));
		this.transformMatrix = new TransformationMatix();
	}


	public Geometry(String rawIGeoValue) throws Exception {
		loadData(rawIGeoValue);
	}

	protected void loadData(String rawIGeoValue) throws Exception {
		/* From the ww-inx-file-format document:
		 
		   IGeo="x_19_l_1_l_4_l_2_D_36_D_-360_l_2_D_36_D_-175.2_l_2_D_309.8181818181818_D_-175.2_l_2_D_309.8181818181818_D_-360_b_f_ D_36_D_360_D_309.8181818181818_D_-175.2_D_1_D_0_D_0_D_1_D_0_D_0"
		         0 1  2 3 4 5 6 7 8 9  1 1    2 3 4 5  6  7     8 9 2 1                 2 3      4 5 6 7                 8  9   3 1  2 3  4 5   6 7                 8 9      4 1 2 3 4 5 6 7 8 9 5 1
		                               0                            0                                                           0                                            0                   0

			The items in the sample are interpreted as follows:

			* x_19 indicates a general list type of 25 (0x19) items.
			
			* l_1 indicates there is one path. If there were more paths, the others would be inserted after
			b_f, which marks the end of a path.
			
			* l_4 indicates the start of a path containing four points.
			
			* l_2 indicates the first point, whose type is 2 (enum PMPathPointType, kL, see Path-
			Types.h), which represents a corner point, where only the anchor point itself matters; the
			point's X(), Y() value is appended (�D_36_D_-360�). If the path point type were 0 or 1 (kCS
			or kCK), the left and right direction points also would be written out, so there would be
			another four numbers. The same rules apply to the second, third, and fourth points.
			
			* b_f indicates the end of the single path containing four points, whose boolean value specifies
			whether the path is open.
			
			* D_36_D_360_D_309.8181818181818_D_-175.2 indicates the geometric bounds, four double
			values that represent the left, top, right, and bottom of the bounding box.
			
			* D_1_D_0_D_0_D_1_D_0_D_0 indicates the transform matrix, whose six double values
			represent the matrix.
			
			* If the item has graphic bounds, an additional four double values represent the left, top,
			right, and bottom of the graphic bounding box.
		 
		 */
		List<InxValue> values = InxHelper.decodeRawValueToList(rawIGeoValue);
		int itemCursor = 1;
		// Item 0: number of paths
		// Item 1: Start of path, gives number of points in path
		Path path = new Path();
		itemCursor = path.loadData(values, itemCursor);
		this.paths.add(path);
		this.boundingBox = new Box();
		itemCursor = boundingBox.loadData(values, itemCursor);
		
		// Transform matrix is array of 6 double values:
		this.transformMatrix = new TransformationMatix();
		itemCursor = this.transformMatrix.loadData(values, itemCursor);
		
		if (itemCursor < values.size()) {
			// Must be a graphic bounding box
			this.graphicBoundingBox = new Box();
			itemCursor = this.graphicBoundingBox.loadData(values, itemCursor);
		}
		
		
 		
		
	}

	/**
	 * @return
	 */
	public List<Path> getPaths() {
		return this.paths;
	}

	/**
	 * @return
	 */
	public Box getBoundingBox() {
		return this.boundingBox;
	}

	/**
	 * @return
	 */
	public Box getGraphicBoundingBox() {
		return this.graphicBoundingBox;
	}

	/**
	 * @return
	 */
	public TransformationMatix getTransformationMatrix() {
		return this.transformMatrix;
	}

	/**
	 * @param width
	 */
	public void setWidth(double width) {
		Rectangle2D r = this.boundingBox.getRectangle2D();
		this.boundingBox.getRectangle2D().
		  setRect(r.getX(), r.getY(), width, r.getHeight());
		this.paths.add(new Path(r.getX(), r.getY(), r.getX() + r.getWidth(), r.getY() - r.getHeight(), false));
		
	}

	/**
	 * @param width
	 */
	public void setHeight(double height) {
		Rectangle2D r = this.boundingBox.getRectangle2D();
		this.boundingBox.getRectangle2D().
		  setRect(r.getX(), r.getY(), r.getWidth(), height);
	}

	/**
	 * @return
	 */
	public double getWidth() {
		return this.boundingBox.getRectangle2D().getWidth();
	}

	/**
	 * @return
	 */
	public double getHeight() {
		return this.boundingBox.getRectangle2D().getHeight();
	}
	
	public String toString() {
		StringBuilder str = new StringBuilder("\n");
		str.append(this.getClass().getSimpleName());
		str.append(":\n  Paths: ");
		for (Path path : this.getPaths()) {
			str.append("\n  ");
			str.append(path.toString());
		}
		str.append(":\n  Bounding box: ");
		this.getBoundingBox().reportGeometry(str);
		str.append("\n");
		str.append("  Tranformation matrix: ");
		TransformationMatix tm = this.getTransformationMatrix();
		if (tm != null)
			str.append(tm.toString());
		else 
			str.append("{No transformation matrix}");
		return str.toString();
	}


}

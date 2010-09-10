/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * Represents an InDesign Path object, which is an ordered sequence of Points
 */
public class Path {

	Logger logger = Logger.getLogger(this.getClass());
	private List<Point> points = new ArrayList<Point>();
	private boolean isOpen = true;

	/**
	 * @param left
	 * @param top
	 * @param right
	 * @param bottom
	 * @param isOpen
	 */
	public Path(Double left, Double top, Double right, Double bottom, boolean isOpen) {
		Point p;
		this.points.add(new Point(left, top));
		this.points.add(new Point(right, top));
		this.points.add(new Point(right, bottom));
		this.points.add(new Point(left, bottom));
		this.isOpen = isOpen;
	}

	/**
	 * 
	 */
	public Path() {
	}

	/**
	 * @param values
	 * @param itemCursor
	 * @return
	 */
	public int loadData(List<InxValue> values, int itemCursor) {
		// On exit, the itemCursor should point to the item after the last
		// item consumed by the path.
		
		//FIXME: parse out the path points:
		int pathType = ((InxLong32)values.get(itemCursor++)).getValue().intValue();
		switch (pathType) {
		case 4:
			// Four-point path
			for (int i = 0; i < 4; i++) {
				Point point = new Point();
				itemCursor = point.loadData(values, itemCursor);
				this.points.add(point);
			}
			break;
		default:
			logger.debug("Unhandled path type: " + pathType);
		}
		
		// Last bit of path is open/closed indicator:
		
		isOpen = ((InxBoolean)values.get(itemCursor++)).getValue().booleanValue();
		
		return itemCursor;
	}

	/**
	 * @return
	 */
	public List<Point> getPoints() {
		return this.points;
	}

	/**
	 * @return
	 */
	public boolean isOpen() {
		return this.isOpen;
	}
	
	public String toString() {
		StringBuilder result = new StringBuilder(" Path: ");
		for (Point point : this.getPoints()) {
			result.append("[")
			.append(point.getX())
			.append(", ")
			.append(point.getY())
			.append("], ");
		}
		result.append(" isOpen=")
		.append(this.isOpen);		
		return result.toString();
	}

}

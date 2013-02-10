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
	private List<PathPoint> points = new ArrayList<PathPoint>();
	private boolean isOpen = true;

	/**
	 * @param left
	 * @param top
	 * @param right
	 * @param bottom
	 * @param isOpen
	 */
	public Path(Double left, Double top, Double right, Double bottom, boolean isOpen) {
		this.points.add(new PathPoint(left, top));
		this.points.add(new PathPoint(right, top));
		this.points.add(new PathPoint(right, bottom));
		this.points.add(new PathPoint(left, bottom));
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
		InxValue value = values.get(itemCursor++);
		
		int pointCount = ((InxLong32)value).getValue().intValue();
		
		// Iterate over path points until we get the boolean value
		value = values.get(itemCursor);		
		
		while (!(value instanceof InxBoolean)) {
			PathPoint pathPoint = new PathPoint();
			itemCursor = pathPoint.loadData(values, itemCursor);
			this.points.add(pathPoint);
			value = values.get(itemCursor);
		}
		
		// Last bit of path is open/closed indicator:
		isOpen = ((InxBoolean)value).getValue();
		
		return ++itemCursor;
	}

	/**
	 * @return
	 */
	public List<PathPoint> getPoints() {
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
		for (PathPoint point : this.getPoints()) {
			result.append(point.toString())
			.append(", ");
		}
		result.append(" isOpen=")
		.append(this.isOpen);		
		return result.toString();
	}

}

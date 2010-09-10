/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.List;

import org.apache.log4j.Logger;

/**
 * A single point
 */
public class Point {

	Logger logger = Logger.getLogger(this.getClass());

	double x = 0.0;
	double y = 0.0;
	
	/**
	 * @param left
	 * @param top
	 */
	public Point(Double x, Double y) {
		this.x = x;
		this.y = y;
	}

	/**
	 * 
	 */
	public Point() {
	}

	/**
	 * @return the x
	 */
	public double getX() {
		return this.x;
	}

	/**
	 * @return the y
	 */
	public double getY() {
		return this.y;
	}

	/**
	 * @param values
	 * @param itemCursor
	 * @return
	 */
	public int loadData(List<InxValue> values, int itemCursor) {
		int pointType = ((InxLong32)values.get(itemCursor++)).getValue().intValue();
		switch (pointType) {
		case 2: // Corner point.
			x = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			y = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			break;
		default:
			logger.debug("Unhandled point type " + pointType);
		}
		return itemCursor;
	}

}

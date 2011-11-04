/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;


/**
 * Holds the six values of an InDesign transformation matrix and
 * provides utility methods for applying transformation matrices to
 * boxes.
 */
public class TransformationMatix {

	static Logger logger = Logger.getLogger(TransformationMatix.class);

	private double a = 1; // Scale X. 
	private double b = 0; // Rotation 
	private double c = 0; // Rotation
	private double d = 1; // Scale Y. Default for translation
	private double e = 1; // X translation
	private double f = 1; // Y translation

	/**
	 * @param values
	 */
	public TransformationMatix(double[] values) {
		if (values.length != 6)
			throw new RuntimeException("Expected 6 values for matrix data, got " + values.length);
		int i = 0;
		this.a = values[i++];
		this.b = values[i++];
		this.c = values[i++];
		this.d = values[i++];
		this.e = values[i++];
		this.f = values[i++];
	}

	/**
	 * 
	 */
	public TransformationMatix() {
	}

	/**
	 * @param values
	 * @param itemCursor
	 * @return
	 */
	public int loadData(List<InxValue> values, int itemCursor) {
		// values must be a list of 6 doubles, labeled a-f in the InDesign docs:
		// Items e and f are the x and y transform values, which are used
		// to translate inner coordinates to parent coordinates.
		this.a = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		this.b = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		this.c = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		this.d = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		this.e = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		this.f = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
		return itemCursor;
	}
	
	public double getXTranslation() {
		return e;
	}

	public double getYTranslation() {
		return f;
	}
	
	public String toString() {
		return "xForm[" + a + ", " + b + ", " + c + ", " + d + ", " + e + ", " + f + "]"; 
	}

	/**
	 * @return
	 */
	public Collection<? extends InxValue> getMatrixValues() {
		List<InxDouble> values = new ArrayList<InxDouble>();
		values.add(new InxDouble(a));
		values.add(new InxDouble(b));
		values.add(new InxDouble(c));
		values.add(new InxDouble(d));
		values.add(new InxDouble(e));
		values.add(new InxDouble(f));
		return values;
	}

	/**
	 * @param f Y translation value
	 */
	public void setYTranslation(double f) {
		this.f = f;
		
	}

	/**
	 * @param e X translation value
	 */
	public void setXTranslation(double e) {
		this.e = e;
		
	}


}

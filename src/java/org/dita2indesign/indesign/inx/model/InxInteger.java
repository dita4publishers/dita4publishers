/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  
 */
package org.dita2indesign.indesign.inx.model;

/**
 * Represents a 16-bit integer value.
 */
public class InxInteger extends InxValue {
	

	private int value;

	/**
	 * @param valueStr
	 */
	public InxInteger(String rawValue) {
	    // LJT: There is a java bug if the hex value is negative, e.g. ffffffff
	    // This is a workaround for that problem.
	    this.value = (int)Long.parseLong(rawValue, 16);
		// this.value = Integer.parseInt(rawValue, 16);
	}

	/**
	 * @param intValue
	 */
	public InxInteger(int intValue) {
		this.value = intValue;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#getValue()
	 */
	@Override
	public Integer getValue() {
		return new Integer(this.value);
	}
	
	public int getIntegerValue() {
		return this.value;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#toEncodedString()
	 */
	@Override
	public String toEncodedString() {
		return "s_" + Integer.toString(value, 16);
	}

}

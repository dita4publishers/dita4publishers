/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

/**
 *
 */
public class InxLong64 extends InxValue {

	private long value;

	/**
	 * @param rawValue
	 */
	public InxLong64(String rawValue) {
		
		// INX number values are hex, not decimal
		if (rawValue.indexOf("~") >= 0) {
			// 64-bit value
			String lowOrder = rawValue.substring(rawValue.indexOf("~")+1);
			lowOrder = leftZeroPad(lowOrder, 8);
			String highOrder = rawValue.substring(0, rawValue.indexOf("~"));
			value = Long.parseLong(highOrder + lowOrder, 16);
			
		} else {
			this.value = Long.parseLong(rawValue, 16);
		}
	}
	
	public static final String zeroes = "000000000000000000000000000000000000000000000000000000000000000000";
	
	public static String leftZeroPad(String src, int maxLen)
	  {
	    if (src == null)
	      return null;
	    if (src.length() > zeroes.length())
	      return src;
	    return zeroes.substring(0, maxLen-src.length())+src;
	  }

	/**
	 * @param value
	 */
	public InxLong64(int value) {
		this.value = value;
	}

	public Long getValue() {
		return new Long(value);
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#toEncodedString()
	 */
	@Override
	public String toEncodedString() {
		return "l_" + Long.toString(value, 16);
	}

}

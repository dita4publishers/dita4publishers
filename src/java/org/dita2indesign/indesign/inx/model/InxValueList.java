/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.List;

/**
 * List of InxValues
 */
public class InxValueList extends InxValue {

	private List<InxValue> items = new ArrayList<InxValue>();

	/**
	 * @param valueStr
	 * @throws Exception 
	 */
	public InxValueList(String valueStr) throws Exception {
		if (valueStr.startsWith("x_") || valueStr.startsWith("rx_")) {
			int p = valueStr.indexOf("_");
			valueStr = valueStr.substring(p+1);
		}

		// Get the list item count (size):
		
		String[] parts = valueStr.split("_");
		int p = 0; // List length
		p = processListParts(this, parts, p);
	}


	/**
	 * 
	 */
	public InxValueList() {
		super();
	}


	/**
	 * @param targetList List to add the parsed item to
	 * @param parts String array of raw value split on "_"
	 * @param p Current item within parts. Should be type code of value item to process.
	 * @return index of part item following last parsed item (e.g., start of next value or end of list).
	 * @throws Exception 
	 */
	protected int parseValueList(InxValueList targetList, String[] parts, int p) throws Exception {		
		p = processListParts(targetList, parts, p);
		return p;
	}


	protected int processListParts(InxValueList targetList, String[] parts, int p) throws Exception {
		int size = Integer.parseInt(parts[p++], 16);
		if (size > 0) {
			// p should now be typecode of first list item
			int itemCount = 0;
			while (p < parts.length) {
				String typeCode = parts[p];
				if (typeCode.equals("x") || typeCode.equals("rx")) {
					InxValueList newList = new InxValueList();
					p = parseValueList(newList, parts, p+1); // p should point at the list length part
					targetList.add(newList);
				} else if (typeCode.equals("y") || typeCode.equals("ry")) {
					InxValueList newList = new InxObjectList();
					p = parseValueList(newList, parts, p+1);
					targetList.add(newList);
				} else if (typeCode.equals("z") || typeCode.equals("rz")) {
					InxRecordList newRecordList = new InxRecordList();
					p = parseRecordList(newRecordList, parts, p+1);
					targetList.add(newRecordList);
				} else {
					p = parseAtomicValue(targetList, parts, p);
				}
				itemCount++;
				if (itemCount == size)
					break; // We're done
			}
		}
		return p;
	}

	/**
	 * @param newList
	 * @param parts
	 * @param p
	 * @return
	 * @throws Exception 
	 */
	protected int parseRecordList(InxRecordList newList, String[] parts, int p) throws Exception {
		p = processRecordListParts(newList, parts, p);
		return p;
	}


	/**
	 * @param targetList
	 * @param parts
	 * @param p
	 * @return
	 * @throws Exception 
	 */
	protected int parseAtomicValue(InxValueList targetList, String[] parts, int p) throws Exception {
		if (p >= parts.length)
			throw new RuntimeException("Parts index p greater than or equal to number of value parts. This is a code bug.");
		InxValue value =  null;
		String rawValue = null;
		// The last member of a list may be something like "c_", which means there's no actual value item in the string array.
		if (p+1 < parts.length)
			rawValue = parts[p+1];
		try {
			value = InxHelper.newValue(parts[p], rawValue);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Exception parsing parts: " + parts + ": " + e.getMessage());
		}
		targetList.add(value);
		return p+2;
		
	}




	/**
	 * @param newList
	 */
	protected void add(InxValue newList) {
		this.items.add(newList);
	}


	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#getValue()
	 */
	@Override
	public List<? extends InxValue> getValue() {
		return this.items;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#toEncodedString()
	 */
	@Override
	public String toEncodedString() {
		String typeCode = "x";
		return encodeListAsString(typeCode);
	}


	protected String encodeListAsString(String typeCode) {
		StringBuilder value = new StringBuilder();
		value.append(typeCode).append("_").append(Integer.toHexString(this.items.size()));
		for (InxValue v : this.items) {
			value.append("_");
			value.append(v.toEncodedString());
		}
		return value.toString();
	}


	/**
	 * @return The number of items in the list.
	 */
	public int size() {
		return this.items.size();
	}


	/**
	 * @param i
	 * @return
	 */
	public InxValue get(int i) {
		return this.items.get(i);
	}


	/**
	 * @return
	 */
	public List<InxValue> getItems() {
		return this.items;
	}


	protected int processRecordListParts(InxRecordList inxRecordList, String[] parts,
			int p) throws Exception {
				int size = Integer.parseInt(parts[p++], 16);
				int itemCount = 0;
				InxValueList tempList = null;
				
				while (p < parts.length) {
					String dataType = parts[p++];
					String typeCode = parts[p];
					if (typeCode.equals("x") || typeCode.equals("rx")) {
						tempList = new InxValueList();
						p = parseValueList(tempList, parts, p);
					} else if (typeCode.equals("y") || typeCode.equals("ry")) {
						tempList = new InxObjectList();
						p = parseValueList(tempList, parts, p);
					} else if (typeCode.equals("z") || typeCode.equals("rz")) {
						InxRecordList tempRecordList = new InxRecordList();
						tempList = tempRecordList;
						p = parseRecordList(tempRecordList, parts, p);
					} else {
						tempList = new InxValueList();
						p = parseAtomicValue(tempList, parts, p);						
					}
					InxRecord record = new InxRecord(dataType, tempList.get(0));
					inxRecordList.add(record);
					itemCount++;
					if (itemCount == size)
						break; // We're done
				}
				return p;
			}


}

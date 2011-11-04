/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

/**
 * Filters result sets by DITA class token or tagname
 * 
 **/
public class DitaFilterByType implements DitaResultSetFilter {

	private String typeSpecifier;

	/**
	 * @param typeSpecifier The element type name or DITA class token of the
	 * type to return. Bare element type names match exactly against
	 * the element type of the reference. DITA class tokens 
	 * ({module}/{tagname}) match all elements that have the specified
	 * DITA type in their specialization hierarchy.
	 */
	public DitaFilterByType(String typeSpecifier) {
		this.typeSpecifier = typeSpecifier;
	}
	
	public String toString() {
		return "[DitaFilterByType] Specifier: \'" + typeSpecifier + "'";
	}

}

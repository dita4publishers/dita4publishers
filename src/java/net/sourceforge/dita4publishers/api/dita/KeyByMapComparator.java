/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.Comparator;

/**
 * Comparese two key definitions by map URI and then by key name.
 */
public class KeyByMapComparator implements Comparator<DitaKeyDefinition> {

	/* (non-Javadoc)
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	public int compare(DitaKeyDefinition o1, DitaKeyDefinition o2) {
		int result = o1.getBaseUri().compareTo(o2.getBaseUri());
		if (result == 0)
			result = o1.getKey().compareTo(o2.getKey());
		return result;
	}

}

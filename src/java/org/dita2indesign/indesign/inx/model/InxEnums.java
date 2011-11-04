/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Maintains a mapping from raw INX enums for properties to Java Enums
 */
public final class InxEnums {
	
	@SuppressWarnings("unchecked")
	static Map<String, Map<String, ? extends Enum>> enumMaps = new HashMap<String, Map<String, ? extends Enum>>();
	static {
		Map<String, PageSideOption> pageSideOptions = new HashMap<String, PageSideOption>();
		pageSideOptions.put("rgth", PageSideOption.RIGHT_HAND);
		pageSideOptions.put("lfth", PageSideOption.LEFT_HAND);
		pageSideOptions.put("usex", PageSideOption.SINGLE_SIDED);
		enumMaps.put(InDesignDocument.PROP_PGSD, pageSideOptions);

		Map<String, PageBindingOption> pageBindingOptions = new HashMap<String, PageBindingOption>();
		pageBindingOptions.put("Dflt", PageBindingOption.DEFAULT);
		pageBindingOptions.put("rtlb", PageBindingOption.RIGHT_TO_LEFT);
		pageBindingOptions.put("ltrb", PageBindingOption.LEFT_TO_RIGHT);
		enumMaps.put(InDesignDocument.PROP_PBIN, pageBindingOptions);
}

	/**
	 * @param propKey
	 * @param propValue
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Enum getEnumForRawProperty(String propKey, String propValue) {
		Enum result;
		Map<String, ? extends Enum> enumMap = enumMaps.get(propKey);
		if (enumMap == null)
			throw new RuntimeException("No mapping for enum property \"" + propKey + "\"");
		result = enumMap.get(propValue);
		if (result == null)
			throw new RuntimeException("No mapping for raw value \"" + propValue + "\" in enum \"" + propKey + "\"");
		return result;
	}
	
	

}

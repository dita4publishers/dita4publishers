/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.HashMap;
import java.util.Map;

/**
 * Options that configure key reporting.
 */
public class KeyReportOptions {
	
	/**
	 * When true, only effective keys are reported, otherwise, all keys
	 * are reported. Default is "true".
	 */
	public static final String ONLY_EFFECTIVE_KEYS = "onlyEffectiveKeys";
	/**
	 * When true, keys are sorted by their definining map and then by 
	 * key name. When false, keys are sorted by key name. Default is "false".
	 */
	public static final String SORT_BY_MAP = "sortByMap";

	private Map<String, String> options = new HashMap<String, String>();
	
	public KeyReportOptions() {
		options.put(ONLY_EFFECTIVE_KEYS, "true");
		options.put(SORT_BY_MAP, "false");
	}

	public void setOption(String name, String value) {
		this.options.put(name, value);
	}

	/**
	 * @return
	 */
	public boolean isOnlyEffectiveKeys() {
		return Boolean.valueOf(this.options.get(ONLY_EFFECTIVE_KEYS));
	}

	/**
	 * @return
	 */
	public boolean isSortByMap() {
		return Boolean.valueOf(this.options.get(SORT_BY_MAP));
	}

	/**
	 * @param b
	 */
	public void setSortByMap(boolean b) {
		this.options.put(SORT_BY_MAP, String.valueOf(b));
	}

	/**
	 * @param b
	 */
	public void setAllKeys(boolean b) {
		this.options.put(ONLY_EFFECTIVE_KEYS, String.valueOf(!b));
	}

	/**
	 * @param b
	 */
	public void setOnlyEffectiveKeys(boolean b) {
		this.options.put(ONLY_EFFECTIVE_KEYS, String.valueOf(b));
	}

}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
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

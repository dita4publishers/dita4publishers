/**
 * Copyright (c) 2009 Really Strategies, Inc.
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

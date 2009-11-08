/**
 * Copyright (c) 2009 Really Strategies, Inc.
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

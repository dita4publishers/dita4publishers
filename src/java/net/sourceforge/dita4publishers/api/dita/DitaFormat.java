/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

/**
 * Reflects the effective value of the format attribute
 * of topicref. The value for format is unbounded, so
 * this enum only reflects the common or important
 * values. The default value for format when unspecified
 * on a topicref, xref, or link is "dita".
 */
public enum DitaFormat {
	
	/**
	 * A DITA topic.
	 */
	DITA,     
	
	/**
	 * A DITA map.
	 */
	DITAMAP, 
	
	/**
	 * An HTML resource.
	 */
	HTML, 
	
	/**
	 * Some other kind of resource.
	 */
	NONDITA;

}

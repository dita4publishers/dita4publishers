/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;

/**
 * A bounded object set of DITA resources: maps, topics, and non-DITA 
 * objects (graphics, Web pages, etc.).
 * <p>A DITA bounded object set may consist of just a map tree or may
 * include all local-scope dependencies ultimately referenced from the map.
 */
public interface DitaBoundedObjectSet extends BoundedObjectSet {

	/**
	 * @return Returns the key space represented by the DITA bounded object set.
	 */
	DitaKeySpace getKeySpace();

	/**
	 * Sets the key space used by and/or constructed from this bounded object set.
	 * <p>When a DITA BOS is constructed from a map, the key space should be
	 * constructed from that map's map tree. When a DITA BOS is constructed from
	 * a topic, the key space enables resolution of key references in the context
	 * of some key space context.
	 * @param keySpace The key space to populate and/or use for resolving key
	 * references.
	 */
	void setKeySpace(DitaKeySpace keySpace);

}

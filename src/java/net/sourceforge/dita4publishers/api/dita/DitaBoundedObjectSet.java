/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
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

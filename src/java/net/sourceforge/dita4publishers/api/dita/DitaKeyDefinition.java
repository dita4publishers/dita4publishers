/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.net.URI;
import java.net.URL;

import org.w3c.dom.Element;

/**
 * Represents the definition of a single key. Note that a single
 * topicref element may define any number of keys. However, for 
 * key definition objects to be meaningfully comparable they must
 * reflect exactly one key, which becomes the sort key. Two key
 * definitions are equal if they have the same key, keyref, and
 * absolute resource URI (which may be null) (remembering that 
 * the resource URI is calculated relative to the effective
 * base URI of the topicref element from which the key definition
 * was constructed.
 */
public interface DitaKeyDefinition extends Comparable<DitaKeyDefinition> {

	/**
	 * @return The key reference specified by the key definition or
	 * null if the key definition does not reference a key.
	 */
	String getKeyref();

	/**
	 * @return Key defined defined by the key definition. Note that
	 * any underlying topicref element may define multiple keys. 
	 */
	String getKey();

	/**
	 * @return The href (URI) specified by the key definition or
	 * null if the key definition does not address a resource by URI.
	 */
	String getHref();

	/**
	 * @return The base URI for the key definition or null if the
	 * key definition was not defined by a DITA map. If the key
	 * definition is defined in a map, the base URI should be the
	 * URI of the map document that directly contained the key definition.
	 */
	URI getBaseUri();

	/**
	 * @return The absolute URI of the resource addressed by the key definition.
	 * Will be null if the key definition does not specify an href value.
	 * If the base URI of the definition is null and the href value is not
	 * absolute, the returned value may or may not be meaningful.
	 */
	URL getAbsoluteUrl();

	/**
	 * @return
	 */
	DitaFormat getFormat();

	/**
	 * For collation, keys are sorted alphabetically by key in a locale-
	 * specific way (that is, UIs are free to sort keys based on the 
	 * current locale). There is no DITA-defined processing implication for
	 * how keys might be sorted other than in original document order
	 * (which determines whether or not they are effective within a given
	 * DITA map tree).
	 * @see java.lang.Comparable#compareTo(java.lang.Object)
	 */
	public int compareTo(DitaKeyDefinition keyDefinition);
	
	/**
	 * Two key definitions are equal if they define the same key, have the
	 * same (or null) keyref, and the same (or null) absolute href value,
	 * compared using URI comparison. 
	 * @param keyDefinition Candidate key definition.
	 * @return 
	 */
	public boolean equals(DitaKeyDefinition keyDefinition);

	/**
	 * @return The DITA properties specification for the key definition.
	 */
	DitaPropsSpec getDitaPropsSpec();

	/**
	 * @return The resource to which this key definition is bound. Will be
	 * a DOM (DITA document), Element (the key definition element), or
	 * a URI.
	 */
	Object getResource();

	/**
	 * @return The DITA element (specialization of topicref) that defined the key.
	 */
	Element getKeyDefElem();

	/**
	 * @param resource The object the key is bound to.
	 */
	void setResource(Object resource);

}

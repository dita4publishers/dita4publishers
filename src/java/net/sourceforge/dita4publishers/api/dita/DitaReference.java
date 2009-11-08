/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import org.w3c.dom.Element;

/**
 * Represents a reference to a resource. The reference may reflect
 * a DITA element or some non-DITA source, including references
 * constructed purely programmatically. DITA
 * elements may, depending on type, address resources directly by 
 * URI (href, conref) or indirectly by key (keyref, conkeyref).
 */
public interface DitaReference {

	/**
	 * @return True if the reference reflects an element in a DITA document.
	 */
	boolean isDitaElement();

	/**
	 * @return True if the reference reflects a DITA topicref element (specialized
	 * or unspecialized).
	 */
	boolean isTopicRef();

	/**
	 * @return The element that is the direct source for the reference, or
	 * null if the reference does not reflect a literal element.
	 */
	Element getElement();

}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import org.w3c.dom.Element;


/**
 * A DITA resource that is a DITA element (an XML element within
 * a DITA document (map or topic).
 */
public interface DitaElementResource extends DitaResource {

	/**
	 * @return The element that is the resource data.
	 */
	Element getElement() throws DitaApiException;

}

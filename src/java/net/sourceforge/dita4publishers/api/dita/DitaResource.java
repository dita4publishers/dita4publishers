/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.net.URL;

/**
 * Represents a resource addressed by a DITA link (topicref, xref, link).
 * <p>A resource may be one of:
 * <ul>
 * <li>A DITA element (meaning an XML element within a DITA document)</li>
 * <li>A non-DITA resource (in the HTTP sense)
 * </ul>
 * </p>
 * 	
 */
public interface DitaResource {

	/**
	 * @return The URL of the resource. For DITA resources, this is the URL of the
	 * containing DITA document plus a DITA-specific fragment identifier. For
	 * non-DITA resources, this is whatever the URL specified by the whatever
	 * href attribute ultimately addressed the resource.
	 */
	URL getUrl();

}

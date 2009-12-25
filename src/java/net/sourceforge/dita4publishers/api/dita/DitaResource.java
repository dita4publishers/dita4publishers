/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
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

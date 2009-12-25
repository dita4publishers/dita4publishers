/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import org.w3c.dom.Document;



/**
 * Represents a DITA element that is the potential target of
 * an ID-based reference.
 */
public interface DitaIdTarget {

	/**
	 * @return True of the target element is of DITA type "topic/topic".
	 */
	boolean isTopic();

	/**
	 * @return The ID of the target element.
	 */
	Object getId();

	/**
	 * @return True if the element is a subelement of a topic but not itself of type "topic/topic".
	 */
	boolean isTopicComponent();

	/**
	 * @return True if the element is of type "map/map" or occurs within a map document.
	 */
	boolean isMapComponent();

	/**
	 * @return The DITA class information for the target element.
	 */
	DitaClass getDitaClass();

	/**
	 * @return The tag name of the target element (e.g., "topic", "p", etc.).
	 */
	String getTagName();

	/**
	 * @return Document that contains the element.
	 */
	Document getDocument();

}

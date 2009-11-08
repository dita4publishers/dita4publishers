/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;



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

}

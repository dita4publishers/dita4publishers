/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

/**
 * Represents a Ditaval specification: zero or more filtering
 * specs and zero or more flagging specs.
 */
public interface DitavalSpec {

	/**
	 * Adds an exclusion condition for a specific property. 
	 * @param property The property the condition applies to.
	 * @param value The value to be excluded.
	 */
	void addExclusion(String property, String value);

	/**
	 * @param propName
	 * @param value
	 * @return True if the value is set as excluded in the Ditaval specification.
	 */
	boolean isExcluded(String propName, String value);

	/**
	 * Adds an explicit inclusion for a given property.
	 * @param propName
	 * @param value
	 */
	void addInclusion(String propName, String value);

}

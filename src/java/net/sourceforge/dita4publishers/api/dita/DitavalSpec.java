/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
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

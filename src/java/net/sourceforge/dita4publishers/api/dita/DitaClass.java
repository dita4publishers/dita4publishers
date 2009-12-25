/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.List;

/**
 * Abstracts the DITA "class" attribute.
 */
public interface DitaClass {

	/**
	 * @return The literal value of the class attribute as declared. White space
	 * in the original attribute value may be normalized.
	 */
	String getClassValue();

	/**
	 * @return The type specification (module/tagname) for the base type of the
	 * element, e.g. "topic/p", "map/topicref", etc.
	 */
	String getBaseType();

	/**
	 * @return The type specification for the most-specialized component of the 
	 * class specification (e.g., "mymodule/mytype").
	 */
	String getLastType();

	/**
	 * @return A list, from least specialized to most specialized, of the terms in
	 * the element's class value. Within the list, get(0) always equals getBaseType().
	 */
	List<String> getTypes();

	/**
	 * @return True if the element is defined in a domain vocabulary module.
	 */
	boolean isDomainType();

	/**
	 * @return True if the element is defined in a structural vocabulary module.
	 */
	boolean isStructuralType();

	/**
	 * @param candType Type to which this type is compared.
	 * @return True if this type is a the same as or specialization of the candidate type.
	 */
	boolean isType(DitaClass candType);

	/**
	 * @param DITA type specification (module/tagname)
	 * @return True if the type specification occurs in the class hierarchy for
	 * this DITA class.
	 */
	boolean isType(String string);

}

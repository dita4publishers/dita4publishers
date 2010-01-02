/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.bos;



/**
 * Base tree walker interface. Tree walkers use the Walker pattern to process the root member of a BOS (e.g., a root DITA map, 
 * a Word doc, an InDesign document) and determine the other BOS members. The general processing pattern is:
 * <ol>
 * <li>Construct a new BOS instance.</li>
 * <li>Construct the root member and set is as the BOS root.</li>
 * <li>Apply a walker to the BOS to do the BOS construction.</li>
 * </ol>
 * <p>BOS visitors are intended to operate on already-constructed BOSes</p>
 */
public interface TreeWalker {
	
	/**
	 * Sets the root object that the walker will walk. Implementations
	 * must check the type of the root object.
	 * @param rootObject
	 * @throws BosException
	 */
	public void setRootObject(Object rootObject) throws BosException;
	
	/**
	 * Walk the previously-set root object and add the result to the 
	 * specified Bounded Object Set.
	 * @param bos Bounded Object Set to which members may be added as a result of walking the tree.
	 * @throws BosException
	 */
	public void walk(BoundedObjectSet bos) throws BosException;
	
	/**
	 * Gets the configured root object, or null if not set.
	 * @return
	 * @throws BosException
	 */
	public Object getRootObject() throws BosException;

}
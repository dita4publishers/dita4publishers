/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.bos;

/**
 * Visitors that operate on Bounded Object Sets
 */
public interface BosVisitor {

	/**
	 * @param boundedObjectSet
	 * @throws BosException 
	 */
	void visit(BoundedObjectSet boundedObjectSet) throws BosException;

	/**
	 * @param bosMember
	 * @throws BosException 
	 * 
	 */
	void visit(BosMember bosMember) throws BosException;

}

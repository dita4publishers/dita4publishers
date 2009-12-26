/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.ditabos;

import java.net.URI;
import java.util.Collection;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;

/**
 *
 */
public interface BoundedObjectSet {

	/**
	 * @return
	 */
	public abstract BosMember getRoot();

	/**
	 * @return
	 */
	public abstract long size();

	/**
	 * @param member
	 */
	public abstract void setRootMember(BosMember member);

	/**
	 * @return
	 */
	public abstract Collection<BosMember> getMembers();

	/**
	 * @param log
	 */
	public abstract void reportBos(Log log);

	/**
	 * @param visitor
	 * @throws BosException 
	 */
	public abstract void accept(BosVisitor visitor) throws BosException;

	/**
	 * @return
	 */
	public abstract Log getLog();

	/**
	 * Create a BOS member whose data source is an XML document.
	 * @param parentMember
	 * @param mapDoc
	 * @return
	 * @throws BosException 
	 */
	public abstract XmlBosMember constructBosMember(BosMember parentMember,
			Document mapDoc) throws BosException;

	/**
	 * Create a BOS member whose data source is a URI. Implies that the
	 * data source is not an XML document.
	 * @param member
	 * @param targetUri
	 * @return
	 */
	public abstract BosMember constructBosMember(BosMember member,
			URI targetUri) throws BosException;

	/**
	 * @return True if any member of the BOS fails a validation check during BOS construction.
	 */
	public abstract boolean hasInvalidMembers();

	/**
	 * Adds a new member, if the key is not already in the BOS. If the key
	 * is in the BOS, updates the existing member with the specified parent
	 * and returns the resulting member.
	 * @param parentMember
	 * @param member 
	 * @return 
	 */
	public abstract BosMember addMember(BosMember parentMember, BosMember member) throws BosException;



}
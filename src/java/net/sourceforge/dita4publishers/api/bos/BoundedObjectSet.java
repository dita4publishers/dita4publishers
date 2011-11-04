/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.bos;

import java.net.URI;
import java.util.Collection;
import java.util.List;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;

/**
 * Represents a set of storage objects (files, URIs, etc.). A bounded object set (BOS) may
 * be constructed from some initial data object (e.g., a DITA map document, a Word document)
 * or may be constructed manually as an arbitrary list of objects. Each member of the bounded
 * object set represents a unique storage object.
 * <p>At its simplest a BOS is a flat list of files. However, BOS members may have associated
 * child members, allowing a BOS to represent one or more trees. A given BOS member may
 * have any number of parents.</p>
 */
public interface BoundedObjectSet {

	/**
	 * Gets the root member of the BOS, if one has been defined. Bounded object sets
	 * constructed from some initial starting object, such as a DITA map, have a natural
	 * and unambiguous root. Bounded object sets constructed from arbitrary lists of 
	 * objects may not have a meaningful root object.
	 * @return The root member or null, if there is no defined root member (or the BOS
	 * has no members).
	 */
	public abstract BosMember getRoot();

	/**
	 * Gets the number of members in the BOS>
	 * @return The number of members in the BOS.
	 */
	public abstract long size();

	/**
	 * Sets the root member of the BOS.
	 * @param member
	 */
	public abstract void setRootMember(BosMember member);

	/**
	 * Gets the BOS members as a collection.
	 * @return A collection of all the members of the BOS. The order
	 * of the members is effectively random.
	 */
	public abstract Collection<BosMember> getMembers();

	/**
	 * Accepts a BOS visitor and applies it to the BOS appropriately.
	 * @param visitor
	 * @throws Exception 
	 */
	public abstract void accept(BosVisitor visitor) throws Exception;

	/**
	 * Gets the log associated with the BOS.
	 * @return The log associated with the BOS.
	 */
	public abstract Log getLog();

	/**
	 * Create a BOS member whose data source is an XML document.
	 * @param parentMember
	 * @param document
	 * @return The BOS member. If a BOS member for specified document
	 * already exists, that member is returned.
	 * @throws BosException 
	 * @throws Exception 
	 */
	public abstract XmlBosMember constructBosMember(BosMember parentMember,
			Document document) throws BosException, Exception;

	/**
	 * Create a BOS member whose data source is a URI. Implies that the
	 * data source is not an XML document.
	 * @param member
	 * @param targetUri
	 * @return The BOS member. If a BOS member for the specified URI already
	 * exists, that member is returned.
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

	/**
	 * Adds a new member.
	 * @param member Member to add if it is not already a member, based on member key matching.
	 * @return The BosMember added or the pre-existing member instance.
	 */
	public abstract BosMember addMember(BosMember member);

	/**
	 * Adds a member, if it is not already a member, and registers it as a dependency of the
	 * the using member.
	 * @param dependencyKey The key, whithin the scope of the using member, that distinguishes the
	 * the dependency, such as an href or keyref value. 
	 * @param depType The type of the dependency.
	 * @param usingMember The member that has a dependency on the used member. 
	 * @param usedMember The member to add and on which the using member has a dependency.
	 */
	public abstract void addMemberAsDependency(String dependencyKey, DependencyType depType, XmlBosMember usingMember,
			BosMember usedMember);


	/**
	 * Returns the list, possibly empty, of BosMembers that use specified member.
	 * @param usedMember Member to get the where-used list for.
	 * @return List of using members, possibly empty.
	 */
	public abstract List<BosMember> getWhereUsed(BosMember usedMember);

}
/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.bos;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sourceforge.dita4publishers.api.PropertyContainer;


/**
 * Represents a unique storage object within a set of storage objects (a "bounded object set"). A BOS
 * member has the following properties:<ul>
 * <li>Key: The BOS member's unique identifier within the BOS. The key can be any
 * string. Two BOS members are equal if they have the same key. Typically keys
 * will be absolute URIs or repository object IDs.</li>
 * <li>Data source: The data contained by the storage object the BOS member
 * represents. BOS processors may modify the BOS member's data during BOS 
 * processing, for example, to rewrite pointers in an XML document. In general,
 * implementations should expect to create a copy of the original data and
 * allow the copy to be modified without affecting the original.</li>
 * <li>Effective URI: the URI of the BOS member in some target storage space. Used
 * to create a mapping from BOS members as originally stored to some target space, e.g.,
 * packaging within a Zip, export from a CMS, import to a CMS, etc.</li>
 * <li>Dependencies: The set of BOS members on which this member depends for
 * any reason. Dependencies typically reflect semantic links or inclusion (composition)
 * relationships among storage objects. Each dependency has one or more associated
 * dependency types, reflecting the reasons why the dependency exists. Note that 
 * a given dependent BOS member is only listed once regardless of the number of times
 * it is linked from the using member or the number of different ways it is linked.
 * The purpose of the dependency list is to simply establish that one BOS member
 * requires another for any reason.</li>
 * <li>Children: A BOS member may have some dependencies identified as children,
 * allowing the BOS to represent a tree or set of trees of storage objects. A given BOS member
 * may have any number of parents.</li>
 * </ul>
 * <p>BOS members are generic property containers, so they may have any number
 * of arbitrary properties.</p>
 * 
 */
public interface BosMember extends PropertyContainer {

	/**
	 * Gets the unique key for the BOS member.
	 * @return Unique key within the BOS by which the member is identified
	 */
	public abstract String getKey();

	/**
	 * A BOS member may have zero or more parent members.
	 * @param parentMember
	 */
	public abstract void addParent(BosMember parentMember);

	/**
	 * Gets the parents of the BOS member
	 * @return List, possibly empty, of parent members.
	 */
	public abstract List<BosMember> getParents();

	/**
	 * Adds a child member.
	 * @param member
	 */
	public abstract void addChild(BosMember member);

	/**
	 * Gets the children of the member, if any.
	 * @return List, possibly empty, of child BOS members.
	 */
	public abstract List<BosMember> getChildren();

	/**
	 * The filename to use for the member.
	 * This can be used to establish a result filename
	 * without specifying the full URI. The file name need
	 * not be unique within the BOS.
	 * @param fileName The filename associated with the BOS member.
	 */
	public abstract void setFileName(String fileName);

	/**
	 * Accepts a BOS visitor per the standard Visitor pattern. Applies
	 * the visitor to the BOS member.
	 * @param visitor
	 * @throws Exception 
	 */
	public abstract void accept(BosVisitor visitor) throws Exception;

	/**
	 * Gets the associated file name of the BOS member.
	 * @return File name set for the BOS member.
	 */
	public abstract String getFileName();

	/**
	 * Gets the associated file for the BOS member.
	 * @return File associated with the BOS member, or null if there is no associated file.
	 */
	public abstract File getFile();

	/**
	 * Gets an input stream for accessing the member's data content.
	 * The input stream should reflect any modifications made to the 
	 * data source during BOS processing.
	 * @return An input stream on the member's data source.
	 * @throws BosException 
	 */
	public abstract InputStream getInputStream() throws BosException;

	/**
	 * Gets the dependencies registered with the BOS member. Does not
	 * include any members only registered as children.
	 * @return Dependencies as a map of member keys to members.
	 */
	public abstract Map<String, ? extends BosMember> getDependencies();

	/**
	 * Gets the dependencies registered with the BOS member. Does not
	 * include any members only registered as children.
	 * @param includeChildren When true, includes children in the list of dependencies.
	 * @return Dependencies as a map of member keys to members.
	 */
	public abstract Map<String, ? extends BosMember> getDependencies(boolean includeChildren);

	/**
	 * Gets a dependency with the specified key. Note that the key is not necessarily the
	 * dependent member's key, but is a specific to the BOS member that has the dependency.
	 * For example, the key may be the unresolved value of an @href attribute, a DITA key name,
	 * or some other value specific to that member's use of the dependency. This allows
	 * lookup of dependencies by their original addressing syntax.
	 * @param key
	 * @return Dependency with the specified key, or null if the specified key is not a dependency. 
	 */
	public abstract BosMember getDependency(String key);
	
	
	/**
	 * Gets the set of dependencies of the specified type.
	 * @param type DependencyType to return.
	 * @return Set, possibly empty, of dependencies of the specified type.
	 */
	public abstract Set<BosMember> getDependenciesOfType(DependencyType type);

	/**
	 * Gets the set of dependency types registered for the dependencies of 
	 * this BOS member.
	 * @return Set, possibly empty, of dependency types.
	 */
	public abstract Set<DependencyType> getDependencyTypes();

	/**
	 * Gets the set of dependency types the specified member is registered as.
	 * @return Set, possibly empty, of dependency types.
	 */
	public abstract Set<DependencyType> getDependencyTypes(String key);

	/**
	 * Registers a generic (untyped) dependency.
	 * @param href
	 * @param dependentMember
	 */
	public abstract void registerDependency(String href,
			BosMember dependentMember);

	/**
	 * Registers a dependency classified by the specified type.
	 * @param href
	 * @param dependentMember
	 * @param type Dependencyh type
	 */
	public abstract void registerDependency(String href,
			BosMember dependentMember, DependencyType type);

	/**
	 * Indicates that the member is an XML BOS member
	 * @return true if the member is an XML BOS member
	 */
	public abstract boolean isXml();

	/**
	 * Indicates that the BOS member failed some validation check during BOS construction.
	 * @return True if the member is not valid (e.g., failed a validation check during BOS construction).
	 */
	public abstract boolean isInvalid();

	/**
	 * Gets the effective URI of the BOS member, as distinct from
	 * its data source URI. This
	 * URI may be modified as part of BOS processing to reflect
	 * a new target location, for example,
	 * to reflect reorganization of files as part of a packaging
	 * or export operation. Use getDataSourceUri() to get the
	 * original URI of the BOS member's data source.
	 * @return The URI to which the BOS member is associated. 
	 */
	public abstract URI getEffectiveUri();

	/**
	 * Returns the URI of data source for the BOS member. This
	 * URI should always enable access to the data as long 
	 * as the URI itself can be resolved (that is, the URI
	 * should work barring connectivity issues). This URI
	 * is effectively invariant. Use setUri() and getUri()
	 * to manipulate the effective URI for the BOS member
	 * as determined by BOS processing.
	 * @return URI by which the data of the BOS member can
	 * be accessed.
	 */
	public abstract URI getDataSourceUri();

	/**
	 * Sets the URI of the data source for the BOS member
	 * (e.g., the storage object from which the BOS member
	 * is constructed. This URI should not be modified
	 * during BOS processing unless the location of the
	 * data source itself has changed.
	 */
	public abstract void setDataSourceUri(URI uri);

	/**
	 * Sets the effective URI for the BOS member, for 
	 * example, to reflect a modification of the storage
	 * location of the BOS member as part of a packaging
	 * or export operation. This URI may reflect a resource
	 * that has not yet been created, thus it cannot be used
	 * to access the BOS member's data.
	 * @param uri
	 */
	public abstract void setEffectiveUri(URI uri);
	
	/**
	 * Sets the file system directory that contains or should contain the member.
	 * @param directory File system directory to use.
	 */
	public void setFileSystemDirectory(File directory);

	/**
	 * Gets the file system directory that contains or should contain the member.
	 * May be null.
	 * @return File system directory as a file or null if not set.
	 */
	public File getFileSystemDirectory();

}
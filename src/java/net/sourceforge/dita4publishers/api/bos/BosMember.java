/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.bos;

import java.io.InputStream;
import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sourceforge.dita4publishers.api.PropertyContainer;


/**
 * Represents a unique object within a set of objects (a "bounded object set") to be imported to or exported from 
 * the RSuite repository, essentially acting as a mapping between files or other external
 * resources and RSuite Managed Objects. Each BOS member must have a unique key within the BOS. For export,
 * the key is the RSuite Managed Object ID, which is always globally unique within the RSuite repository.
 * For import, the key is normally the full path of the BOS member's associated file, although BOS constructors
 * may use any algorithm for determining keys. BOS member identity is determined by the key value.
 * <p>
 * For import, BOS members are normally constructed from files or URI-accessed resources and then associated
 * with Managed Objects. For export, BOS members are constructed from Managed Objects and then associated with
 * the files to which they are exported. Files can be associated by either setting the file directly or by
 * setting the file system path and file name to use to construct the file.
 * </p>
 */
public interface BosMember extends PropertyContainer {

	/**
	 * @return unique key within the BOS by which the member is identified
	 */
	public abstract String getKey();

	/**
	 * A BOS member may have zero or more parent members.
	 * @param parentMember
	 */
	public abstract void addParent(BosMember parentMember);

	public abstract List<BosMember> getParents();

	/**
	 * @param member
	 */
	public abstract void addChild(BosMember member);

	/**
	 * @return
	 */
	public abstract List<BosMember> getChildren();

	/**
	 * The filename to use for the member.
	 * This can be used to establish a result filename
	 * without specifying the full URI.
	 * @param fileName
	 */
	public abstract void setFileName(String fileName);

	/**
	 * @param visitor
	 * @throws BosException 
	 */
	public abstract void accept(BosVisitor visitor) throws BosException;

	/**
	 * @return File name set for the BOS member.
	 */
	public abstract String getFileName();

	/**
	 * @return
	 * @throws BosException 
	 */
	public abstract InputStream getInputStream() throws BosException;

	/**
	 * @return Dependencies as a map of member keys to members.
	 */
	public abstract Map<String, ? extends BosMember> getDependencies();

	/**
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
	 * @return true if the Member is an XML BOS member
	 */
	public abstract boolean isXml();

	/**
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
	
}
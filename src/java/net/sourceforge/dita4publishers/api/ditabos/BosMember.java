/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.ditabos;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.util.List;
import java.util.Map;


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
public interface BosMember {

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
	 * Sets the file system directory in which the BOS member's file
	 * does (import) or should (export) exist.
	 * @param directory
	 */
	public abstract void setFileSystemDir(File directory);

	/**
	 * The filename, within the separately-specified file system directory, to
	 * use for the member.
	 * @param fileName
	 */
	public abstract void setFileName(String fileName);

	/**
	 * @param visitor
	 * @throws BosException 
	 */
	public abstract void accept(BosVisitor visitor) throws BosException;

	/**
	 * @return
	 */
	public abstract File getFileSystemDirectory();

	/**
	 * @return
	 */
	public abstract String getFileName();

	/**
	 * @return
	 * @throws BosException 
	 */
	public abstract InputStream getInputStream() throws BosException;

	/**
	 * @return
	 */
	public abstract Map<String, BosMember> getDependencies();

	/**
	 * @param key
	 * @return
	 */
	public abstract BosMember getDependency(String key);

	/**
	 * @param href
	 * @param dependentMember
	 */
	public abstract void registerDependency(String href,
			BosMember dependentMember);

	/**
	 * @return true if the Member is an XML BOS member
	 */
	public abstract boolean isXml();

	/**
	 * @return True if the member is not valid (e.g., failed a validation check during BOS construction).
	 */
	public abstract boolean isInvalid();

	/**
	 * 
	 * @return The URI to which the BOS member is associated.
	 */
	public abstract URI getUri();

	/**
	 * Sets the URI to which thie BOS member is associated.
	 * @param uri
	 */
	public abstract void setUri(URI uri);
	
}
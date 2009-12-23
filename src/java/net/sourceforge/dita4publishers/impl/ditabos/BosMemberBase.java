/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.BosVisitor;
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;

/**
 *
 */
public abstract class BosMemberBase implements BosMember {

	protected Map<String, BosMember> dependencies = new HashMap<String, BosMember>();
	protected File fileSystemDirectory;
	protected String fileName;
	protected List<BosMember> children = new ArrayList<BosMember>();
	private List<BosMember> parents = new ArrayList<BosMember>();
	protected String key;
	protected BoundedObjectSet bos = null;
	protected boolean isXml = false;
	private File file;
	private boolean isInvalid = false;
	private URI sourceUri;

	/**
	 * @param bos
	 */
	public BosMemberBase(BoundedObjectSet bos) {
		this.bos = bos;		
	}

	/**
	 * @param bos
	 * @param dataSourceFile
	 */
	public BosMemberBase(DitaBoundedObjectSetImpl bos, File dataSourceFile) {
		this.bos = bos;
		this.setFile(dataSourceFile);
		this.key = dataSourceFile.getAbsolutePath();
	}

	/**
	 * Registers a BOS member on which the member is dependent, specifing a key by 
	 * which the member can be later looked up, such as the original referencing
	 * element, the fully-qualified URI of the target, a database key, or whatever.
	 * Intended to enable mapping from original references in member data to
	 * the target managed object in order to rewrite pointers.
	 * @param key
	 * @param targetMember
	 */
	public void registerDependency(String key, BosMember targetMember) {
		dependencies.put(key, targetMember);
	}

	/**
	 * @return
	 */
	public File getFileSystemDirectory() {
		return this.fileSystemDirectory;
	}

	/**
	 * @return
	 */
	public String getFileName() {
		if (this.fileName == null && this.getFile() != null) {
			this.fileName = this.getFile().getName();
		}
		return this.fileName;
	}
	
	public File getFile() {
		if (this.file != null)
			return this.file;
		else {
			if (this.fileSystemDirectory != null && this.fileName != null) {
				if (!"".equals(this.fileName.trim())) {
					this.file = new File(this.fileSystemDirectory, this.fileName);
					return this.file;
				}
			}
		}
		return null;
	}

	public abstract void accept(BosVisitor visitor) throws BosException;

	public void setFileSystemDir(File directory) {
		this.fileSystemDirectory = directory;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public List<BosMember> getChildren() {
		return this.children;
	}

	public String getKey() {
		return this.key;
	}

	/**
	 * 
	 * @return The parent BOS member or null if the member is the root member
	 */
	public List<BosMember> getParents() {
		return this.parents;
	}

	public void addParent(BosMember parentMember) {
		if (parentMember != null && !this.parents.contains(parentMember)) {
			this.parents.add(parentMember);
		}
	}

	public void addChild(BosMember member) {
		if (!this.children.contains(member)) {
			this.children.add(member);
			member.addParent(this);
		}
		
	}

	public Map<String, BosMember> getDependencies() {
		Map<String, BosMember> newMap = new HashMap<String, BosMember>();
		newMap.putAll(this.dependencies);
		return newMap;
	}

	public BosMember getDependency(String key) {
		return this.dependencies.get(key);
	}
	
	public boolean isXml() {
		return this.isXml;
	}

	public InputStream getInputStream() throws BosException {
		try {
			return this.sourceUri.toURL().openStream();
		} catch (MalformedURLException e) {
			throw new BosException(e);
		} catch (IOException e) {
			throw new BosException(e);
		}
	}

	@Override
	public String toString() {
			StringBuilder buf = new StringBuilder();
			buf.append("[")
			.append(this.getKey())
			.append("] ")
			.append(" ")
			.append(this.getClass().getSimpleName());
			
			// FIXME: Need to rationalize use of files and URIs
			
			if (this.getFile() != null) {
				String fileName = this.getFileName();
				buf.append(", file=")
				.append(fileName);
			} else {
				buf.append(", {No associated file}");
			}
			
			return buf.toString();
		}

	public boolean isInvalid() {
		return this.isInvalid ;
	}

	
}
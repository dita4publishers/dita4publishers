/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.bos;

/**
 * Represents the semantic type of a dependency, e.g., "xref", "link",
 * "child", etc. 
 */
public interface DependencyType {
	
	/**
	 * Generic (untyped) dependency.
	 */
	public static final Dependency DEPENDENCY = new Dependency();
	
	/**
	 * @return The display name for the type.
	 */
	public String toString();

}

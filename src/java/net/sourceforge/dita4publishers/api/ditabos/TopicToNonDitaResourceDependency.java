/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.api.bos.DependencyType;

/**
 * Topic to non-DITA resource (e.g., image, Web page) dependency.
 */
public class TopicToNonDitaResourceDependency implements DependencyType {

	public String toString() {
		return "Topic to non-DITA resource";
	}
}

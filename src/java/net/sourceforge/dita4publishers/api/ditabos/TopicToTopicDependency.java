/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.api.bos.DependencyType;

/**
 * Topic to topic dependency.
 */
public abstract class TopicToTopicDependency implements DependencyType {

	public String toString() {
		return "Topic to topic";
	}
}

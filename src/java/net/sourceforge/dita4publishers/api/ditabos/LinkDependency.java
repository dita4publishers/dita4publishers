/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.api.bos.DependencyType;


/**
 * DITA link dependency (created via <link> or <relatatedLinks>).
 */
public class LinkDependency implements DependencyType {

	public String toString() {
		return "Link";
	}
}

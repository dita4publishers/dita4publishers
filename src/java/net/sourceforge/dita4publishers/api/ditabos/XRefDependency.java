/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.api.bos.DependencyType;


/**
 * Cross reference dependency (<xref> or keyref-only elements that address a topic).
 */
public class XRefDependency implements DependencyType  {

	public String toString() {
		return "Cross reference";
	}
}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.api.bos.DependencyType;


/**
 * A content reference dependency between two DITA documents.
 */
public class ConrefDependency implements DependencyType {

	public String toString() {
		return "Conref";
	}
}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.impl.ditabos.DitaBosMember;
import net.sourceforge.dita4publishers.impl.ditabos.DitaMapBosMember;
import net.sourceforge.dita4publishers.impl.ditabos.DitaTopicBosMember;

/**
 * Visitors that visit DITA Bounded Object Sets.
 */
public interface DitaBosVisitor extends BosVisitor {
	/**
	 * @param ditaBosMember
	 * @throws BosException 
	 * 
	 */
	void visit(DitaBosMember ditaBosMember) throws BosException;

	/**
	 * 
	 * @param ditaMapBosMember
	 * @throws BosException
	 */
	void visit(DitaMapBosMember ditaMapBosMember) throws BosException;
	
	/**
	 * 
	 * @param ditaTopicBosMember
	 * @throws BosException
	 */
	void visit(DitaTopicBosMember ditaTopicBosMember) throws BosException;
	

}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.impl.ditabos.DitaBosMemberImpl;
import net.sourceforge.dita4publishers.impl.ditabos.DitaMapBosMemberImpl;
import net.sourceforge.dita4publishers.impl.ditabos.DitaTopicBosMemberImpl;

/**
 * Visitors that visit DITA Bounded Object Sets.
 */
public interface DitaBosVisitor extends BosVisitor {
	/**
	 * @param ditaBosMember
	 * @throws BosException 
	 * 
	 */
	void visit(DitaBosMemberImpl ditaBosMember) throws BosException;

	/**
	 * 
	 * @param ditaMapBosMember
	 * @throws BosException
	 */
	void visit(DitaMapBosMemberImpl ditaMapBosMember) throws BosException;
	
	/**
	 * 
	 * @param ditaTopicBosMember
	 * @throws BosException
	 */
	void visit(DitaTopicBosMemberImpl ditaTopicBosMember) throws BosException;
	

}

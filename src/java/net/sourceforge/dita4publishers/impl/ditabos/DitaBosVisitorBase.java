/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosVisitor;

import org.apache.commons.logging.Log;

/**
 * Base for DITA BOS visitors.
 */
public abstract class DitaBosVisitorBase extends BosVisitorBase implements
		DitaBosVisitor {

	/**
	 * @param log
	 */
	public DitaBosVisitorBase(Log log) {
		super(log);
	}

	public void visit(DitaBosMemberImpl ditaBosMember) throws BosException {
		visit((BosMember)ditaBosMember);
	}

	public void visit(DitaMapBosMemberImpl bosMember) throws BosException {
		visit((DitaBosMemberImpl)bosMember);
		
	}


	public void visit(DitaTopicBosMemberImpl bosMember) throws BosException {
		visit((DitaBosMemberImpl)bosMember);
		
	}
	


}

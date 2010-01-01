/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosVisitor;
import net.sourceforge.dita4publishers.impl.bos.BosVisitorBase;

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

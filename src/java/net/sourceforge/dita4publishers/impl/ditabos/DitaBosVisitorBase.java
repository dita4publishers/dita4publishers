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

	public void visit(DitaBosMember ditaBosMember) throws BosException {
		visit((BosMember)ditaBosMember);
	}

	public void visit(DitaMapBosMember bosMember) throws BosException {
		visit((DitaBosMember)bosMember);
		
	}


	public void visit(DitaTopicBosMember bosMember) throws BosException {
		visit((BosMember)bosMember);
		
	}


}

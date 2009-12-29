/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.BosVisitor;
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;

import org.apache.commons.logging.Log;
import org.jbpm.graph.exe.ExecutionContext;

/**
 * Base class for BosVisitor implementations. Provides default BOS visiting method
 * that iterates over BOS members as a list.
 */
public abstract class BosVisitorBase implements BosVisitor {

	protected Log log;
	protected ExecutionContext context;


	/**
	 * @param log 
	 * 
	 */
	public BosVisitorBase(Log log) {
		super();
		this.log = log;
	}
	

	/**
	 * @param context
	 * @param log
	 */
	public BosVisitorBase(ExecutionContext context, Log log) {
		this.log = log;
		this.context = context;
	}


	public void xvisit(DitaBosMember ditaBosMember) throws BosException {
		visit((BosMember)ditaBosMember);
	}

	public void visit(BosMemberBase member) throws BosException {
		visit((BosMember)member);
	}


	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosVisitor#visit(com.reallysi.tools.dita.BoundedObjectSet)
	 */
	public void visit(BoundedObjectSet bos)
			throws BosException {
		// By default, just iterate over the members as a flat list.
		for (BosMember member : bos.getMembers()) {
			member.accept(this);
		}
		
	}


	public void xvisit(DitaMapBosMember bosMember) throws BosException {
		visit((DitaBosMember)bosMember);
		
	}


	public void visit(DitaTopicBosMember bosMember) throws BosException {
		visit((BosMember)bosMember);
		
	}


}
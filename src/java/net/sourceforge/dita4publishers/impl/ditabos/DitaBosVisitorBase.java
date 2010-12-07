/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosVisitor;
import net.sourceforge.dita4publishers.api.ditabos.DitaMapBosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaTopicBosMember;
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

	public void visit(DitaBosMember ditaBosMember) throws Exception {
		visit((BosMember)ditaBosMember);
	}

	public void visit(DitaMapBosMember bosMember) throws Exception {
		visit((DitaBosMember)bosMember);
		
	}


	public void visit(DitaTopicBosMember bosMember) throws Exception {
		visit((DitaBosMember)bosMember);
		
	}
	


}

/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosVisitor;
import net.sourceforge.dita4publishers.api.ditabos.NonXmlBosMember;

/**
 * BOS member that is not XML data.
 */
public class NonXmlBosMemberImpl extends BosMemberBase implements NonXmlBosMember {

	/**
	 * @param bos
	 * @param dataSourcefile
	 */
	public NonXmlBosMemberImpl(DitaBoundedObjectSetImpl bos, File dataSourcefile) {
		super(bos, dataSourcefile);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosMemberBase#accept(com.reallysi.tools.dita.BosVisitor)
	 */
	@Override
	public void accept(BosVisitor visitor) throws BosException {
		visitor.visit(this);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosMember#rewritePointers()
	 */
	public void rewritePointers() throws BosException {
		// Nothing to do for generic non-XML content.
	}

}

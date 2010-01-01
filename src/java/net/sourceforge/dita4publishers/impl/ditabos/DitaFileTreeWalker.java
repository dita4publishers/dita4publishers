/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.dita.InMemoryDitaKeySpace;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;

/**
 * DITA walker that operates on files as input.
 */
public class DitaFileTreeWalker extends DitaTreeWalkerBase  {

	/**
	 * @param log
	 * @param keySpace
	 * @param failOnAddressResolutionFailure
	 * @param bosConstructionOptions
	 * @throws BosException
	 */
	public DitaFileTreeWalker(Log log,
			InMemoryDitaKeySpace keySpace, boolean failOnAddressResolutionFailure, BosConstructionOptions bosConstructionOptions) throws BosException {
		super(log, keySpace, bosConstructionOptions);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.TreeWalker#setRootObject(java.lang.Object)
	 */
	public void setRootObject(Object rootObject) throws BosException {
		if (!(rootObject instanceof Document)) {
			throw new BosException("Unhandled root object type " + rootObject.getClass().getName());
		}	
		this.rootObject = rootObject;		
	}

}

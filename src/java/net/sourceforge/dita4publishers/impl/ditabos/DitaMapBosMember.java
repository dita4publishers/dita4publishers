/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosMember;

import org.w3c.dom.Document;

/**
 * A DITA BOS member that represents a DITA map
 */
public class DitaMapBosMember extends DitaBosMember {

	/**
	 * @param bos
	 * @param doc
	 * @throws BosException
	 */
	public DitaMapBosMember(BoundedObjectSet bos, Document doc)
			throws BosException {
		super(bos, doc);
	}

}

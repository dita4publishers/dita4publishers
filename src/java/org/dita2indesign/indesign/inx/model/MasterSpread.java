/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;


import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;





/**
 * Represents a master spread within an InDesign document.
 * Contains one or more pages.
 */
public class MasterSpread extends Spread {

	Logger logger = Logger.getLogger(this.getClass());
	String baseName;
	String namePrefix;
	/**
	 * @throws Exception 
	 * 
	 */
	public MasterSpread() throws Exception {
		super();
	}
	
	public void loadObject(Element dataSource, int spreadIndex) throws Exception {
		super.loadObject(dataSource, spreadIndex);
		this.baseName = getStringProperty(InDesignDocument.PROP_NMBS);
		logger.debug(" + objectLoad(): Setting baseName to \"" + this.baseName + "\"");
		this.namePrefix = getStringProperty(InDesignDocument.PROP_NPFX);
		logger.debug(" + objectLoad(): Setting baseName to \"" + this.namePrefix + "\"");

	}
	
	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}




}

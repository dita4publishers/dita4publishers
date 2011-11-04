/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.writers;

import java.io.File;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.indesign.inx.visitors.InxDomConstructingVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * Writes an InDesign document as INX XML.
 */
public class InxWriter {
	
	Logger logger = Logger.getLogger(this.getClass());


	private File inxFile;

	/**
	 * @param inxFile
	 */
	public InxWriter(File inxFile) {
		this.inxFile = inxFile;
	}

	/**
	 * @param doc
	 * @throws Exception 
	 */
	public void write(InDesignDocument doc) throws Exception {
		logger.debug("write(): Writing InDesign document to file \"" + inxFile.getAbsolutePath() + "\"...");
		InDesignDocumentVisitor visitor = new InxDomConstructingVisitor();
		logger.debug("write(): Visiting document...");
		visitor.visitDocument(doc);
		logger.debug("write(): Getting result dom from visitor...");
		Document resultDom = ((InxDomConstructingVisitor)visitor).getResultDom();
		logger.debug("write(): Result DOM=" + resultDom);
		NodeList nl = resultDom.getChildNodes();
		logger.debug("write(): Document children: " + nl.getLength());
		for (int i = 0; i < nl.getLength(); i++) {
			Node node = nl.item(i);
			logger.debug("write(): Node [" + i + "] " + node);
		}
		logger.debug("write(): Serializing DOM to file \"" + inxFile.getAbsolutePath() + "\"...");
		DataUtil.serializeDomToFile(resultDom, inxFile);
		logger.debug("write(): Done.");

	}
	
	

}

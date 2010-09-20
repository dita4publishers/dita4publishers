/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * Contains text content with no subordinate components other than
 * PIs representing special characters. Maintains its content as a DOM
 * tree since that's as convenient as anything else.
 */
public class TextContents extends DefaultInDesignComponent {
	
	/**
	 * Node list of Text and ProcessingInstruction nodes holding
	 * the text content of the object.
	 */
	private NodeList contents;
	private String textContent;

	public TextContents() {
		super();
	}
	
	public void loadComponent(Element dataSource) throws Exception {
		super.loadComponent(dataSource);
		String rawContents = dataSource.getTextContent();
		if (rawContents.startsWith("c_")) {
			this.textContent = InxHelper.decodeRawValueToSingleString(rawContents);
		} else {
			this.textContent = rawContents;
		}
	}

	/**
	 * @param text
	 */
	public TextContents(String text) {
		this.textContent = text;
	}

	/**
	 * @return
	 */
	public NodeList getContents() {
		if (this.contents != null) {
			return this.contents;
		} else {
			DocumentBuilder builder;
			try {
				builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			} catch (ParserConfigurationException e) {				
				e.printStackTrace();
				throw new RuntimeException("Failed to get a new document builder. Should never happen", e);
			}
			// FIXME: Should probably be constructing an XML string then parsing it so PIs in textContent
			// will get parsed.
			Document doc = builder.newDocument();
			Element elem = doc.createElement(InDesignDocument.TXSR_TAGNAME);
			if (textContent.startsWith("e_")) { // Value is an enumeration, no need to encode it.
				elem.setTextContent(textContent);
			} else {
				elem.setTextContent(InxHelper.encodeString(textContent));
			}
			return elem.getChildNodes();
		}
	}
	
	public String getText() {
		if (this.textContent != null)
			return this.textContent;
		
		// Construct text from data source
		StringBuilder text = new StringBuilder();
		NodeList nl = getContents();
		for (int i = 0; i < nl.getLength(); i++) {
			Node node = nl.item(i);
			switch (node.getNodeType()) {
			case Node.TEXT_NODE:
				text.append(node.getTextContent());
				break;
			case Node.PROCESSING_INSTRUCTION_NODE:
				text.append("<?").append(node.getNodeName())
				.append(" ")
				.append(node.getTextContent())
				.append("?>");
				break;
			case Node.CDATA_SECTION_NODE:
				text.append("<![CDATA[")
				.append(node.getTextContent())
				.append("]]>");
				break;
			default:
				throw new RuntimeException("Unhandled node type " + node.getNodeType());
			}
		}
		String temp = text.toString();
		if (temp.startsWith("c_"))
			return temp.substring(2);
		return temp;
	}

	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}
}

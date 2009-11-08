/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;
import java.net.URI;
import java.net.URISyntaxException;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosVisitor;
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.XmlBosMember;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 *
 */
public class XmlBosMemberImpl extends BosMemberBase implements XmlBosMember {

	private Document document;
	private Element element;

	/**
	 * @param bos
	 * @param doc
	 * @throws BosException 
	 */
	public XmlBosMemberImpl(BoundedObjectSet bos, Document doc) throws BosException {
		super(bos);
		this.setDocument(doc);
		try {
			String rawDocUri = doc.getDocumentURI();
			String docUri = null;
			if (rawDocUri.contains("#"))
				docUri = rawDocUri.substring(0, rawDocUri.indexOf("#"));
			else if (rawDocUri.contains("?"))
				docUri = rawDocUri.substring(0, rawDocUri.indexOf("?"));
			else
				docUri = rawDocUri;
			File file = new File(new URI(docUri));
			this.setFile(file);
		} catch (URISyntaxException e) {
			throw new BosException("URISyntaxException creating file for document URI \"" + doc.getDocumentURI() + "\": " + e.getMessage());
		}
		this.key = doc.getDocumentURI();
		if (key == null) {
			throw new BosException("No document URI for input doc, cannot set BOS member key;");
		}
	}

	/**
	 * @param doc
	 */
	public Document setDocument(Document doc) throws BosException {
		document = doc;
		element = doc.getDocumentElement();
		return document;
	}

	/**
	 * @param doc
	 */
	public Element setElement(Element element) throws BosException {
		this.element = element;
		this.document = element.getOwnerDocument();
		return element;
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
	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.XmlBosMember#rewritePointers()
	 */
	public void rewritePointers() throws BosException {
		// Nothing to do for generic XML content.
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.XmlBosMember#getElement()
	 */
	public Element getElement() throws BosException {
		if (this.element == null) {
			if (this.document != null) {
				this.setElement(document.getDocumentElement());
			}
 		}
		return this.element;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.XmlBosMember#getDocument()
	 */
	public Document getDocument() {
		return this.document;
	}
	
}

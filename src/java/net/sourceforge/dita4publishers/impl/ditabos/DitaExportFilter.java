/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import net.sourceforge.dita4publishers.util.DitaUtil;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import org.xml.sax.ext.Attributes2Impl;
import org.xml.sax.ext.DefaultHandler2;

/**
 * SAX filter for suppressing DITA attributes that should not be included in 
 * document instances that have an associated DTD or XSD. Intended for use primarily
 * in exporting DITA documents from XML repositories that store all attributes 
 * literally or in any processing pipeline that instantiates defaulted attributes.
 * Can be extended to do other filtering as well, such as repository-specific
 * attributes or content.
 */
public class DitaExportFilter extends DefaultHandler2 implements ContentHandler {
	
	public DitaExportFilter() {
		super();
	}

	public void startElement(String uri, String localName, String qName, Attributes atts) throws SAXException {
		// Suppress RSUITE-specific elements.
		if (uri.equals("http://www.reallysi.com"))
			return;
		Attributes2Impl attsImpl = (Attributes2Impl)atts;
		
		// Remove attributes that should never be specified in instances:
		removeAttribute(attsImpl, "class");
		removeAttribute(attsImpl, "domains");
		removeAttribute(attsImpl, DitaUtil.DITA_ARCH_NS, DitaUtil.DITA_ARCH_VERSION_ATTNAME);

		// Note that because shell DTDs or schemas can override attribute declarations for
		// base element types, there's no way to know if a given attribute value matches
		// the declared default without fetching the DTD, which we are not stepping up to 
		// at this time.
		
		try {
			super.startElement(uri, localName, qName, atts);
		} catch (SAXException e) {
			e.printStackTrace();
		}
	}

	protected void removeAttribute(Attributes2Impl attsImpl, String attName) {
		removeAttribute(attsImpl, null, attName);
	}

	protected void removeAttribute(Attributes2Impl attsImpl,
			String attNs, String attName) {
		int i;
		if (attNs != null) 
			i = attsImpl.getIndex(attNs, attName);
		else 
			i = attsImpl.getIndex(attName);
		if (i > 0)
			attsImpl.removeAttribute(i);
	}

  	
}

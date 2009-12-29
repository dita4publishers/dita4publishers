/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.net.URL;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaElementResource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 *
 */
public class DitaElementResourceImpl extends DitaResourceImpl implements DitaElementResource {

	private Element element = null;

	/**
	 * @param resUrl Absolute URI of the resource;
	 * @param elem
	 */
	public DitaElementResourceImpl(URL resUrl, Element elem) {
		super(resUrl);
		this.element = elem;
	}

	/**
	 * @param elem
	 */
	public DitaElementResourceImpl(Element elem) {
		this.element = elem;
	}

	/**
	 * @param doc
	 */
	public DitaElementResourceImpl(Document doc) {
		super(doc);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.impl.DitaElementResource#getElement()
	 */
	public Element getElement() throws DitaApiException {
		return this.element;
	}
	
}

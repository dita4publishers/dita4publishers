/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.net.URI;
import java.net.URL;

import net.sourceforge.dita4publishers.api.dita.DitaResource;

import org.w3c.dom.Document;

/**
 *
 */
public class DitaResourceImpl implements DitaResource {

	protected URL url = null;

	/**
	 * @param resUrl
	 */
	public DitaResourceImpl(URL resUrl) {
		this.url = resUrl;
	}

	/**
	 * 
	 */
	public DitaResourceImpl() {
		super();
	}

	/**
	 * @param doc
	 */
	public DitaResourceImpl(Document doc) {
		try {
			this.url = new URI(doc.getDocumentURI()).toURL();
		} catch (Exception e) {
			throw new RuntimeException("Unexpected " + e.getClass().getSimpleName() + " exception using getDocumentURI() to construct a URL. URI is \"" + doc.getDocumentURI() + "\"");
		}
		
	}

	public URL getUrl() {
		return this.url;
	}
	

}
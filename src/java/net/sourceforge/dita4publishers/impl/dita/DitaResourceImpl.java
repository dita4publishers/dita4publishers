/**
 * Copyright (c) 2009 Really Strategies, Inc.
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
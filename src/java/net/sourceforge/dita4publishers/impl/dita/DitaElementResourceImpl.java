/**
 * Copyright (c) 2009 Really Strategies, Inc.
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
	 * @param elem
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

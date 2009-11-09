/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.dita;

import net.sourceforge.dita4publishers.api.dita.DitaClass;
import net.sourceforge.dita4publishers.api.dita.DitaClassImpl;
import net.sourceforge.dita4publishers.api.dita.DitaIdTarget;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 * Implements DITA ID target within RSuite.
 */
public class DitaIdTargetImpl implements DitaIdTarget {

	private static Log log = LogFactory.getLog(DitaIdTargetImpl.class);

	
	private Element targetElem;
	private String id;
	private DitaClass ditaClass;


	private Document containingDoc;
	

	/**
	 * @param containingDoc
	 * @param targetElem
	 */
	public DitaIdTargetImpl(Document containingDoc, Element targetElem) {
		this.containingDoc = containingDoc;
		this.targetElem = targetElem;
		this.id = targetElem.getAttribute("id");
		try {
			this.ditaClass = new DitaClassImpl(targetElem.getAttribute("class"));
		} catch (DitaClassSpecificationException e) {
			log.warn("Problem with DITA class specification for element \"" + targetElem.getNodeName() + "\": " + e.getMessage() + "\n"
					+ "  Processing of this target may be incorrect.");
		}
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaIdTarget#getDitaClass()
	 */
	public DitaClass getDitaClass() {
		return this.ditaClass;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaIdTarget#getId()
	 */
	public Object getId() {
		return id;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaIdTarget#getTagName()
	 */
	public String getTagName() {
		return this.targetElem.getNodeName();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaIdTarget#isMapComponent()
	 */
	public boolean isMapComponent() {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaIdTarget#isTopic()
	 */
	public boolean isTopic() {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaIdTarget#isTopicComponent()
	 */
	public boolean isTopicComponent() {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaIdTarget#getDocument()
	 */
	public Document getDocument() {
		return containingDoc;
	}

}

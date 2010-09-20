/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;



/**
 *
 */
public class Story extends InDesignObject {

	Logger logger = Logger.getLogger(this.getClass());

	private List<TextStyleRange> textRuns = new ArrayList<TextStyleRange>();

	/**
	 */
	public Story() {
		super();
		this.setInxTagName("cflo");
	}
	
	public void loadObject(Element dataSource) throws Exception {
		super.loadObject(dataSource);
		for (InDesignComponent child : this.getChildren()) {
			if (child instanceof TextStyleRange) {
				this.textRuns.add((TextStyleRange)child);
			}
		}
	}

	/**
	 * @return
	 */
	public Iterator<TextStyleRange> getTextRunIterator() {
		return this.textRuns .iterator();
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		// Nothing to do?
	}



}

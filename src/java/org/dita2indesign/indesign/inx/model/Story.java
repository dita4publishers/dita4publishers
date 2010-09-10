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
	}
	
	public void loadObject(Element dataSource) throws Exception {
		this.setDataSource(dataSource);
		super.loadObject(dataSource);
		for (InDesignComponent child : this.getChildren()) {
			if (child instanceof TextStyleRange) {
				this.textRuns.add((TextStyleRange)child);
			}
		}
		// Story has a property, TextContainers, which is an array of the text frames or text paths
		// that "contain" (on spreads) the text of the story. It does not appear to be necessary
		// to write this value to the INX data, so removing it from the data source so it won't
		// cause confusion. Text frames point to their parent stories, so this value is merely a
		// convenience.
		dataSource.removeAttribute("stcs");
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



}

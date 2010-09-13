/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;


/**
 * A set of one or more pages.
 */
public class Spread extends InDesignRectangleContainingObject {

	private static Logger logger = Logger.getLogger(Spread.class);

	/**
	 * The index of this spread within the list of spreads
	 * or master spreads.
	 */
	private int spreadIndex = -1;

	private MasterSpread masterSpread;


	/**
	 * Pages indexed by object ID.
	 */
	protected Map<String, Page> pagesById = new HashMap<String, Page>();
	/**
	 * The page count specified as a property on the INX element.
	 * This should of course match the number of actual page objects
	 * read.
	 */
	protected long pageCount;

	/**
	 * Pages indexed page name (this assumes page names are unique within a spread)
	 */
	protected Map<String, Page> pagesByName = new HashMap<String, Page>();
	/**
	 * Pages in document order.
	 */
	private List<Page> pages = new ArrayList<Page>();

	private TransformationMatix transformationMatrix;

	/**
	 * 
	 */
	public Spread() {
		super();
	}
	
	/**
	 * Gets the spread index for the spread.
	 * @return The spread index. A value of -1 indicates the spread has not been
	 * placed into a document (and therefore has no meaningful index).
	 */
	public int getSpreadIndex() {
		return this.spreadIndex;
	}

	/**
	 * @return
	 */
	public List<Page> getPages() {
		return this.pages;
	}

	/**
	 * @param dataSource
	 * @param spreadIndex 
	 * @throws Exception 
	 */
	protected InDesignComponent newPage(Element dataSource) throws Exception {
		Page page = this.getDocument().newPage(dataSource);
		page.setParent(this);
		this.getDocument().registerObject(page);
		this.pagesById.put(page.getId(), page);
		this.pagesByName.put(page.getName(), page);
		this.pages .add(page);
		return page;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.AbstractInDesignObject#loadObject(org.dita2indesign.indesign.inx.model.InDesignObject)
	 */
	@Override
	public void loadObject(InDesignObject sourceObj) throws Exception {
		super.loadObject(sourceObj);
		// FIXME: load additional properties.
	}
	
	public void loadObject(Element dataSource, int spreadIndex) throws Exception {
			// logger.debug("loadObject(): spreadIndex=" + spreadIndex);
			this.spreadIndex = spreadIndex;
			this.pageCount = getLongProperty(InDesignDocument.PROP_PAGC);
			// logger.debug(" + objectLoad(): Setting pageCount to \"" + this.pageCount + "\"");
			for (InDesignComponent child : this.getChildren()) {
				if (child instanceof Page) {
					Page page = (Page)child;
					this.pages.add(page);
					this.pagesById.put(page.getId(), page);
				}
			}
			if (this.pageCount != this.pagesById.size())
				throw new InDesignDocumentException("Expected " + this.pageCount + " pages, but only loaded " + this.pagesById.size());
			if (this.getName() == null) {
				String spreadName = this.pages.get(0).getName();
				if (this.pages.size() > 1)
					spreadName += "-" + this.pages.get(this.pages.size() - 1).getName();
				this.setPName(spreadName);
			}
			logger.debug("loadObject(): Spread name=\"" + this.getName() + "\"");
			
			// We have to have the pages loaded before we can calculate the transformation matrix
			// because we use the pages to calculate the spread-to-spread offset.
			logger.debug("loadObject(): Calling setTransformationMatrix...");
			setTransformationMatrix(spreadIndex);
				
			// Pages do not literally contain frames but InDesign maintains a list of frames for each
			// page.
			logger.debug("loadObject(): Assigning rectangles to pages()");
			assignRectanglesToPages();
		}

	protected void setTransformationMatrix(int spreadIndex) {
		logger.debug("setTransformationMatrix(): Starting, spreadIndex=" + spreadIndex);
		double[] matrix = {1.0,0.0,0.0,1.0,0.0,0.0};
		// The spread matrix translates spread coordinates to pasteboard
		// coordinates. The horizontal coordinates are invariant, but the
		// vertical dimension is translated in the positive direction for
		// each spread
		
		if (spreadIndex > 0) {
			logger.debug("setTransformationMatrix(): spreadIndex=" + spreadIndex);
			InDesignDocument doc = (InDesignDocument)this.getParent();
			double offset = doc.getSpreadOffset();
			logger.debug("setTransformationMatrix(): offset=" + offset);
			matrix[5] = offset * spreadIndex;
		}
		
		this.transformationMatrix = new TransformationMatix(matrix);
		logger.debug("setTransformationMatrix(): Matrix=" + this.getTransformationMatrix());
	}

	/**
	 * @return
	 */
	Page getFirstPage() {
		return this.pages.get(0);
	}

	/**
	 * Populate each page's list of rectangles by comparing the geometry of the
	 * page to the geometry of the rectangle.
	 */
	private void assignRectanglesToPages() {
		logger.debug("assignRectanglesToPages(): Assigning rectangles to pages for spread " + this.getName() + "....");
		
		List<Rectangle> recs = new ArrayList<Rectangle>(this.getRectangles());
		logger.debug("assignRectanglesToPages(): got " + recs.size() + " rectangles for spread");
		logger.debug("assignRectanglesToPages(): got " + pagesById.size() + " pages for spread");
		for (Page page : this.getPages()) {
			logger.debug("assignRectanglesToPages(): Processing page " + page.getName() + " with bounding box " + page.getBoundingBox());
			ListIterator<Rectangle> iter = recs.listIterator();
			while (iter.hasNext()) {
				Rectangle rect = iter.next();
				String label = rect.getLabel();
				if (label != null) {
					String lbl = label;
					if (label.length() > 20)
						lbl = label.substring(0,20);
					label = " [" + lbl + "]"; 
				} else
					label = "";
				logger.debug("assignRectanglesToPages(): " + rect.getClass().getSimpleName() + ": " + label + rect + "...");
				if (page.intersects(rect)) {
					logger.debug("assignRectanglesToPages():   rect intersects page, adding to page's rect list");
					page.addRectangle(rect);
					if (page.contains(rect))
						logger.debug("assignRectanglesToPages():   Page contains rectangle, removing from master list of rectagles.");
						iter.remove();
				}
			}
			logger.debug("assignRectanglesToPages(): Assigned " + page.getRectangles().size() + " to page " + page.getName());
		}
		logger.debug("assignRectanglesToPages(): Done.");
		
		
	}

	/**
	 * Get the (first) page of the spread that is an even (left-hand) page.
	 * @return Page or null if there is no left-hand page. If the document
	 * does not use facing pages then all pages are left-hand (and right-hand)
	 * pages.
	 */
	public Page getEvenPage() {
		for (Page page : getPages()) {
			if (page.getPageSide() == PageSideOption.LEFT_HAND || page.getPageSide() == PageSideOption.SINGLE_SIDED)
				return page;
		}
		return null;
	}

	/**
	 * Get the (first) page of the spread that is an odd (right-hand) page.
	 * @return Page or null if there is no right-hand page. If the document
	 * does not use facing pages then all pages are right-hand (and left-hand)
	 * pages.
	 */
	public Page getOddPage() {
		for (Page page : this.getPages()) {
			if (page.getPageSide() == PageSideOption.RIGHT_HAND || page.getPageSide() == PageSideOption.SINGLE_SIDED)
				return page;
		}
		return null;
	}

	/**
	 * @return
	 */
	public String getName() {
		return this.getPName();
	}

	/**
	 * @return
	 */
	public TransformationMatix getTransformationMatrix() {
		return this.transformationMatrix;
	}
	
	/**
	 * @return
	 */
	public MasterSpread getMasterSpread() {
		return this.masterSpread;
	}

	/**
	 * @param masterSpread
	 */
	public void setMasterSpread(MasterSpread masterSpread) {
		this.masterSpread = masterSpread;
	}

	/**
	 * @param pageNumber
	 * @return
	 * @throws Exception 
	 */
	public Page addPage(int pageNumber) throws Exception {
		String pageNumberStr = String.valueOf(pageNumber);
		if (this.pagesByName.containsKey(pageNumberStr))
			throw new RuntimeException("Page number \"" + pageNumber + "\" already exists in spread.");
		Page page = new Page();
		InDesignDocument doc = (InDesignDocument)this.getParent();
		page.setId(doc.assignObjectId());
		doc.registerObject(page);
		
		// Get the corresponding master page, clone its data source,
		// and use that to load the page. Then adjust the bounding box
		// to reflect the vertical position of the spread. Note that for
		// single-spread documents the vertical translation is zero (that
		// is, spread coordinates and pasteboard coordinates are the same
		// for the first spread.
		
		Page masterPage;
		if (doc.isFacingPages()) {
			if (pageNumber % 2 == 0)
				masterPage = getMasterSpread().getEvenPage();
			else
				masterPage = getMasterSpread().getOddPage();
		} else {
			masterPage = getMasterSpread().getFirstPage();
		}
		Element pageDataSource = (Element) masterPage.getDataSourceElement().cloneNode(true);
		page.loadObject(pageDataSource);
		
		// Now adjust the page's bounding box:
		
		this.pagesById.put(page.getId(), page);
		this.pagesByName.put(pageNumberStr, page);
		// NOTE: this means that pages need to be added in an appropriate order:
		this.pages.add(page);
		this.pageCount = this.pages.size();
		return page;
	}


	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}




}

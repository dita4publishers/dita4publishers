/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Element;




/**
 * Represents a single page.
 */
public class Page extends InDesignRectangleContainingObject {
	
	private static Logger log = Logger.getLogger(Page.class);
	
	/**
	 * @throws Exception
	 */
	public Page() throws Exception {
		super();
		setInxTagName("page");
	}

	Logger logger = Logger.getLogger(this.getClass());

	PageSideOption pageSide = PageSideOption.SINGLE_SIDED; // Nominal default;
	
	private String name;

	private Spread spread;

	private MasterSpread appliedMaster;

	public void loadObject(Element dataSource) throws Exception {
		if (dataSource == null) return;

		super.loadObject(dataSource);
		// NOTE: The bounds of a page are determined by the page width and
		// height set on the document properties held by the InDesignDocument object.
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(dataSource);
		this.name = getStringProperty(InDesignDocument.PROP_PNAM);
		PageSideOption tempPgSide = (PageSideOption)getEnumProperty(InDesignDocument.PROP_PGSD);
		if (tempPgSide != null) { // If null, use default
			pageSide = tempPgSide; 
		} else {
		}
		
		while (elemIter.hasNext()) {
			Element child = elemIter.next();
			if (child.getNodeName().equals("imgp")) {
				// Margin preferences.
			} else if (child.getNodeName().equals("Jgda")) {
					// Undocumented
			} else {
				// Unrecognized object type
				logger.debug(" - Unrecognized component type [" + child.getNodeName() + "]");
//				InDesignComponent obj = this.getDocument().newObject(child);
//				this.addChild(obj);
			}
		}
		

	}
	
	@Override
	public void postLoad() throws Exception {
		
		InxObjectRef masterRef = (InxObjectRef)getPropertyValue(InDesignDocument.PROP_PMAS);
		if (masterRef != null) {
			String masterId = masterRef.getValue();
			MasterSpread master = (MasterSpread)this.getDocument().getObject(masterId);
			if (master != null) {
				this.setAppliedMaster(master);
			}
		}
		

	}
	
	/**
	 * Set the master applied to this page.
	 * <p>NOTE: All the pages for a given spread should/must have
	 * the same master spread.
	 * @param master
	 * @throws Exception
	 */
	public void setAppliedMaster(MasterSpread master) throws Exception {
		this.appliedMaster = master;
	}
	
	public MasterSpread getAppliedMaster() throws Exception {
		return this.appliedMaster;
	}
	
	/**
	 * @return
	 * @throws Exception 
	 */
	public MasterSpread getMasterSpread() throws Exception {
		return this.getAppliedMaster();
	}



	@Override
	public void setParent(InDesignComponent parent) {
		super.setParent(parent);
		// Pages are only ever children of spreads.
		this.spread = (Spread)parent;
	}
	
	public Spread getSpread() throws Exception {
		return this.spread;
	}


	public void setWidth(double width)  {
		// Page's coordinate space has the origin at upper-left corner.
		Double x1 = 0.0;
		Double x2 = width;
		Double y1 = 0.0;
		Double y2 = this.getGeometry().getBoundingBox().getBottom();
		this.geometry.getBoundingBox().setCorners(x1, y1, x2, y2);
	}

	public void setHeight(double height)  {
		this.getGeometry().setHeight(height);
	}

	/**
	 * @return
	 */
	public double getWidth() {
		return this.getBoundingBox().getRectangle2D().getWidth();
	}

	/**
	 * @return
	 */
	public double getHeight() {
		return this.getBoundingBox().getRectangle2D().getHeight();
	}

	/**
	 * @return
	 */
	public PageSideOption getPageSide() {
		return pageSide;
	}

	/**
	 * @return The bounding box for the page.
	 */
	public Box getBoundingBox() {
		return this.getGeometry().getBoundingBox();
	}

	public String getName() {
		return this.name;
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/**
	 * Override of abstract superclass. Pages are not the parents of the frames
	 * they contain, spreads are.
	 */
	public void addRectangle(Rectangle rect) {
		logger.debug("addRectang(): rect=" + rect);
		this.rectangles.put(rect.getId(), rect);
		if (rect instanceof TextFrame)
			this.frames.put(rect.getId(), (TextFrame)rect);
	}

	/**
	 * Sets the page side. Can only be determined in the context
	 * of a sequence of pages within a spread.
	 * @param pageSide
	 */
	public void setPageSide(PageSideOption pageSide) {
		this.pageSide = pageSide;
		// Changing the page side can affect the position
		// of the page within the spread:
		TransformationMatix matrix = this.getTransformationMatrix();
		if (pageSide.equals(PageSideOption.LEFT_HAND)) {
			// Translation is the negative page width.
			matrix.setXTranslation(0.0 - getWidth());
			this.setTransformationMatrix(matrix);
		} else {
			// Right-hand pages have their left-edge coincident
			// with the spread's origin, which is the middle
			// of the spread.
			matrix.setXTranslation(0.0);
			this.setTransformationMatrix(matrix);
		}
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		super.updatePropertyMap();
		this.setObjectReferenceProperty(InDesignDocument.PROP_PMAS, getMasterSpread());
	}


	/**
	 * Override any overrideable page master items that apply to this
	 * page. Does not modify text threads. Use this form for adding
	 * multiple pages to a spread.
	 * @param masterToOverride Map to hold mapping from master items to overrides for 
	 * post-override thread fixup. 
	 * @throws Exception
	 */
	public void overrideMasterSpreadObjects(Map<Rectangle, Rectangle> masterToOverride) throws Exception {
		InDesignDocument doc = (InDesignDocument)getParent().getParent();
	
		// Need to correlate this page to the corresponding master
		// page, which is by index within the list of pages for the
		// spreads.
		
		int myIndex = spread.getPages().indexOf(this);
		MasterSpread masterSpread = this.getMasterSpread();
		if (masterSpread == null) {
			log.warn("overrideMasterSpreadObjects(): No master spread for spread " + spread.getSpreadIndex() + " [" + spread.getId() + "]");
			return;
		}
		Page masterPage = this.getMasterSpread().getPages().get(myIndex);
						
		for (Rectangle rect : masterPage.getRectangles()) {
			if (rect.isOverrideable()) {
				Rectangle clone = (Rectangle)doc.clone(rect);
				clone.setParent(this.getParent()); // Rectangles are held by the spread, not the page.
				if (rect instanceof TextFrame) {
					TextFrame masterFrame = (TextFrame)rect;
					Story masterStory = masterFrame.getParentStory();
					Story clonedStory = null;
					if (masterStory != null) {
						clonedStory = (Story)this.getDocument().clone(masterStory);
					}
					TextFrame overrideFrame = (TextFrame)clone;					
					overrideFrame.setMasterFrame(masterFrame);
					this.addRectangle(overrideFrame);
				}
				this.addRectangle(clone);
				masterToOverride.put(rect, clone);						
			}
		}
		
	}


	/**
	 * Override any overrideable page master items that apply to this
	 * page. Use this form when adding a single page to a spread.
	 * @throws Exception
	 */
	public void overrideMasterSpreadObjects() throws Exception {
	
		// Need to correlate this page to the corresponding master
		// page, which is by index within the list of pages for the
		// spreads.
		
		MasterSpread masterSpread = this.getMasterSpread();
		if (masterSpread == null) {
			log.warn("overrideMasterSpreadObjects(): No master spread for spread " + spread.getSpreadIndex() + " [" + spread.getId() + "]");
			return;
		}
		int myIndex = spread.getPages().indexOf(this);
		Page masterPage = this.getMasterSpread().getPages().get(myIndex);
		
		Map<Rectangle, Rectangle> masterToOverride = new HashMap<Rectangle, Rectangle>();
		
		overrideMasterSpreadObjects(masterToOverride);
				
		InDesignDocument.updateThreadsForOverriddenFrames(masterPage, masterToOverride);
				
	}



}

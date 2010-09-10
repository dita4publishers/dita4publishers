/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;


/**
 * Holds the document-level preferences, such as page size.
 */
public class DocumentPreferences extends InDesignObject {
	
	private static Logger logger = Logger.getLogger(DocumentPreferences.class);

	private double pageHeight;
	private double pageWidth;
	private boolean facingPages;
	private double bleedTopOffset;
	private double bleedBottomOffset;
	private double bleedInsideOffset;
	private double bleedOutsideOffset;
	private boolean bleedUniformSize;
	private double slugBottomOffset;
	private double slugTopOffset;
	private double slugInsideOffset;
	private double slugOutsideOffset;
	private boolean slugUniformSize;
	private Enum<PageBindingOption> pageBinding;

	/**
	 * @param dataSource
	 * @throws InDesignDocumentException 
	 */
	@SuppressWarnings("unchecked")
	public void loadObject(Element dataSource) throws Exception {
		super.loadObject(dataSource);
		/*
		 * <docp phgt="U_2400" pwdt="U_1200" cclr="e_iVlt" mclr="e_iMgn" nump="l_1" 
		 * ppsd="b_t" bldt="U_18" bldb="U_18" bldi="U_18" bldo="U_18" bldu="b_t" 
		 * slgt="U_0" slgb="U_0" slgi="U_0" slgo="U_0" slgu="b_f" PrSl="b_t" Shfl="b_t" 
		 * oprb="b_t" pbin="e_ltrb" cold="e_horz" clok="b_t" MsTx="b_t" Self="rc_ddocp1"/>
		 */
		this.pageHeight = getDoubleProperty("phgt");
		this.pageWidth = getDoubleProperty("pwdt");
		this.bleedTopOffset = getDoubleProperty("bldt");
		this.bleedBottomOffset = getDoubleProperty("bldb");
		this.bleedInsideOffset = getDoubleProperty("bldi");
		this.bleedOutsideOffset = getDoubleProperty("bldi");
		this.facingPages = getBooleanProperty("ppsd");
		this.bleedUniformSize = getBooleanProperty("bldu");
		this.slugTopOffset = getDoubleProperty("slgt");
		this.slugBottomOffset = getDoubleProperty("slgb");
		this.slugInsideOffset = getDoubleProperty("slgi");
		this.slugOutsideOffset = getDoubleProperty("slgi");
		this.slugUniformSize = getBooleanProperty("slgu");
		this.pageBinding = getEnumProperty("pbin");
		// FIXME: Add remaining properties here.
	}



	/**
	 * @return the pageHeight
	 */
	public double getPageHeight() {
		return this.pageHeight;
	}



	/**
	 * @return the pageWidth
	 */
	public double getPageWidth() {
		return this.pageWidth;
	}



	/**
	 * @return the facingPages
	 */
	public boolean isFacingPages() {
		return this.facingPages;
	}



	/**
	 * @return the bleedTopOffset
	 */
	public double getBleedTopOffset() {
		return this.bleedTopOffset;
	}



	/**
	 * @return the bleedBottomOffset
	 */
	public double getBleedBottomOffset() {
		return this.bleedBottomOffset;
	}



	/**
	 * @return the bleedInsideOffset
	 */
	public double getBleedInsideOffset() {
		return this.bleedInsideOffset;
	}



	/**
	 * @return the bleedOutsideOffset
	 */
	public double getBleedOutsideOffset() {
		return this.bleedOutsideOffset;
	}



	/**
	 * @return the bleedUniformSize
	 */
	public boolean isBleedUniformSize() {
		return this.bleedUniformSize;
	}



	/**
	 * @return the slugBottomOffset
	 */
	public double getSlugBottomOffset() {
		return this.slugBottomOffset;
	}



	/**
	 * @return the slugTopOffset
	 */
	public double getSlugTopOffset() {
		return this.slugTopOffset;
	}



	/**
	 * @return the slugInsideOffset
	 */
	public double getSlugInsideOffset() {
		return this.slugInsideOffset;
	}



	/**
	 * @return the slugOutsideOffset
	 */
	public double getSlugOutsideOffset() {
		return this.slugOutsideOffset;
	}



	/**
	 * @return the slugUniformSize
	 */
	public boolean isSlugUniformSize() {
		return this.slugUniformSize;
	}



	/**
	 * @return the pageBinding
	 */
	public Enum<PageBindingOption> getPageBinding() {
		return this.pageBinding;
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		logger.debug("accept(): Accepting visitor " + visitor.getClass().getName());
		visitor.visit(this);
	}



}

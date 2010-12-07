/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;


/**
 * Holds the document-level preferences, such as page size.
 */
public class DocumentPreferences extends DefaultInDesignComponent {
	
	private static Logger logger = Logger.getLogger(DocumentPreferences.class);


	/**
	 * @return the pageHeight
	 * @throws Exception 
	 */
	public double getPageHeight() throws Exception {
		return getDoubleProperty("phgt");
	}



	/**
	 * @return the pageWidth
	 */
	public double getPageWidth()  throws Exception {
		return getDoubleProperty("pwdt");
	}



	/**
	 * @return the facingPages
	 */
	public boolean isFacingPages()  throws Exception {
		return getBooleanProperty("ppsd");
	}



	/**
	 * @return the bleedTopOffset
	 */
	public double getBleedTopOffset()  throws Exception {
		return getDoubleProperty("bldt");
	}



	/**
	 * @return the bleedBottomOffset
	 */
	public double getBleedBottomOffset()  throws Exception {
		return getDoubleProperty("bldb");
		
	}



	/**
	 * @return the bleedInsideOffset
	 */
	public double getBleedInsideOffset()  throws Exception {
		return getDoubleProperty("bldi");
		
	}



	/**
	 * @return the bleedOutsideOffset
	 */
	public double getBleedOutsideOffset()  throws Exception {
		return getDoubleProperty("bldi");
		
	}



	/**
	 * @return the bleedUniformSize
	 */
	public boolean isBleedUniformSize()  throws Exception {
		return getBooleanProperty("bldu");
		
	}



	/**
	 * @return the slugBottomOffset
	 */
	public double getSlugBottomOffset()  throws Exception {
		return getDoubleProperty("slgb");
		
	}



	/**
	 * @return the slugTopOffset
	 */
	public double getSlugTopOffset()  throws Exception {
		return getDoubleProperty("slgt");
		
	}



	/**
	 * @return the slugInsideOffset
	 */
	public double getSlugInsideOffset()  throws Exception {
		return getDoubleProperty("slgi");
		
	}



	/**
	 * @return the slugOutsideOffset
	 */
	public double getSlugOutsideOffset()  throws Exception {
		return getDoubleProperty("slgi");
		
	}



	/**
	 * @return the slugUniformSize
	 */
	public boolean isSlugUniformSize()  throws Exception {
		return getBooleanProperty("slgu");
		
	}



	/**
	 * @return the pageBinding
	 */
	public Enum<PageBindingOption> getPageBinding()  throws Exception {
		return (PageBindingOption)getEnumProperty("pbin");
		
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		logger.debug("accept(): Accepting visitor " + visitor.getClass().getName());
		visitor.visit(this);
	}



	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		// Nothing to do.
	}



}

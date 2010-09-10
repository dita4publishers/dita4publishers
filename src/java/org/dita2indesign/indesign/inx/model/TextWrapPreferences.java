/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Contains the text wrapping preferences for things around which
 * text can wrap.
 */
public class TextWrapPreferences extends InDesignComponent {
	
	boolean applyToMasterPageOnly = false;
	ContourOption contourOption = new ContourOption();
	boolean inverse = false;
	List<Path> paths = new ArrayList<Path>();
    List<InxUnit> textWrapOffset = new ArrayList<InxUnit>();
    TextWrapSideOptions textWrapSideOption = TextWrapSideOptions.BOTH_SIDES;
    TextWrapTypes textWrapType = TextWrapTypes.NONE;
    
    {
    	textWrapOffset.add(new InxUnit(0.0));
    }

	/**
	 * @return the applyToMasterPageOnly
	 */
	public boolean applyToMasterPageOnly() {
		return this.applyToMasterPageOnly;
	}

	/**
	 * @param applyToMasterPageOnly the applyToMasterPageOnly to set
	 */
	public void setApplyToMasterPageOnly(boolean applyToMasterPageOnly) {
		this.applyToMasterPageOnly = applyToMasterPageOnly;
	}

	/**
	 * @return the contourOption
	 */
	public ContourOption getContourOption() {
		return this.contourOption;
	}

	/**
	 * @param contourOption the contourOption to set
	 */
	public void setContourOption(ContourOption contourOption) {
		this.contourOption = contourOption;
	}

	/**
	 * @return the inverse
	 */
	public boolean inverse() {
		return this.inverse;
	}

	/**
	 * @param inverse the inverse to set
	 */
	public void setInverse(boolean inverse) {
		this.inverse = inverse;
	}

	/**
	 * @return the paths
	 */
	public List<Path> getPaths() {
		return this.paths;
	}

	/**
	 * @param paths the paths to set
	 */
	public void setPaths(List<Path> paths) {
		this.paths = paths;
	}

	/**
	 * @return the textWrapOffset
	 */
	public List<InxUnit> getTextWrapOffset() {
		return this.textWrapOffset;
	}

	/**
	 * @param textWrapOffset the textWrapOffset to set
	 */
	public void setTextWrapOffset(List<InxUnit> textWrapOffset) {
		this.textWrapOffset = textWrapOffset;
	}

	/**
	 * @return the textWrapSideOption
	 */
	public TextWrapSideOptions getTextWrapSideOption() {
		return this.textWrapSideOption;
	}

	/**
	 * @param textWrapSideOption the textWrapSideOption to set
	 */
	public void setTextWrapSideOption(TextWrapSideOptions textWrapSideOption) {
		this.textWrapSideOption = textWrapSideOption;
	}

	/**
	 * @return the textWrapType
	 */
	public TextWrapTypes getTextWrapType() {
		return this.textWrapType;
	}

	/**
	 * @param textWrapType the textWrapType to set
	 */
	public void setTextWrapType(TextWrapTypes textWrapType) {
		this.textWrapType = textWrapType;
	}
}

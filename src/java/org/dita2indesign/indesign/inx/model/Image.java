/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;


/**
 * Represents an image container. Images have
 * geometric properties, text wrap properties,
 * and may have a descendant Link object for
 * the graphic data itself.
 */
public class Image extends InDesignGeometryHavingObject {

	/**
	 * @throws Exception
	 */
	public Image() throws Exception {
		super();
	}

	private Link itemLink = null;
	private TextWrapPreferences textWrapPreferences = new TextWrapPreferences();

	/**
	 * @param link Link to the external object for the image (e.g., EPS file, etc.).
	 */
	public void setItemLink(Link link) {
		this.addChild(link);
		this.itemLink = link;
		
	}
	
	public Link getItemLink() {
		return this.itemLink;
	}

	/**
	 * @return
	 */
	public TextWrapPreferences getTextWrapPreferences() {
		return this.textWrapPreferences;
		
	}


}

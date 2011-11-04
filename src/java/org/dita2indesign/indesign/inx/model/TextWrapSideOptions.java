/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

/**
 *
 */
public enum TextWrapSideOptions {
  	BOTH_SIDES				("twbs"), //	Both sides text wrap.			 
 	LEFT_SIDE				("twls"), //	Left side text wrap.			 
 	RIGHT_SIDE				("twrs"), //	Right side text wrap.			 
 	SIDE_TOWARDS_SPINE		("twts"), //	Binding side text wrap.			 
 	SIDE_AWAY_FROM_SPINE	("twas"), //	Away from binding side text wrap.			 
 	LARGEST_AREA			("twLs"); //	Largest side text wrap.	

	private String value;
	private TextWrapSideOptions(String value) {
		this.value = value;
	}
	
	String value() {
		return value;
	}
	
}

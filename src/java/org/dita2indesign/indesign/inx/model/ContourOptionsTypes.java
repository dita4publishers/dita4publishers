/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

/**
 *
 */
public enum ContourOptionsTypes {

	BOUNDING_BOX  		("enbb"), // Sets the text wrap shape to the object's bounding box.
 	PHOTOSHOP_PATH 		("pspt"), // Sets the text wrap shape to the specified Photoshop path. To specify the Photoshop path, see contour path name.
 	DETECT_EDGES 		("dteg"), // Sets the text wrap shape to the edges of the image.
 	ALPHA_CHANNEL 		("aphc"), // Sets the text wrap shape to the edges of the specified alpha channel. To specify the alpha channel, see contour path name.
 	GRAPHIC_FRAME 		("engf"), // Sets the text wrap shape to the wrapped object's graphics frame.
 	SAME_AS_CLIPPING 	("sacp"); // Sets the text wrap shape to the clipping path (if any) defined in Photoshop. Note: A path cannot be specified using 
 	                              // this enumeration. To set the text wrap shape to a specific path, use the photoshop path contour options type enumeration value. 

	private String value;
	private ContourOptionsTypes(String value) {
		this.value = value;
	}
	
	String value() {
		return value;
	}
	

}

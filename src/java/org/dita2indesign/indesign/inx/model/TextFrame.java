/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;


/**
 * A text frame
 */
public class TextFrame extends Rectangle {
	
	private String parentStoryId;
	private Story parentStory;

	/**
	 * @throws Exception
	 */
	public TextFrame() throws Exception {
		super();
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.AbstractInDesignObject#loadObject(org.dita2indesign.indesign.inx.model.InDesignObject)
	 */
	@Override
	public void loadObject(InDesignObject sourceObj) throws Exception {
		super.loadObject(sourceObj);
		TextFrame sourceFrame = (TextFrame)sourceObj;
		Story sourceParentStory = sourceFrame.getParentStory();
		Story myParentStory = (Story)this.getDocument().cloneIfNew(sourceParentStory, this.getDocument());
		this.setParentStory(myParentStory);
	}


	public void loadObject(Element dataSource) throws Exception {
		super.loadObject(dataSource);
		parentStoryId = InxHelper.decodeRawValueToSingleObjectId(dataSource.getAttribute("strp"));
	}
	
	public Story getParentStory() throws Exception {
		if (this.parentStory == null && this.parentStoryId != null)
			this.parentStory = (Story) this.getDocument().getObject(parentStoryId);
		return this.parentStory;
	}
	
	public Story setParentStory(Story parentStory) {
		this.parentStory = parentStory;
		this.parentStoryId = parentStory.getId();
		return parentStory;
	}
	
	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}




}

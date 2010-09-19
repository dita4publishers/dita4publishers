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
	private TextFrame nextInThread = null;
	private TextFrame masterFrame;
	private TextFrame previousInThread = null;

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
	public void loadObject(InDesignObject sourceObj, String newObjectId) throws Exception {
		super.loadObject(sourceObj, newObjectId);
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
	
	public Story setParentStory(Story parentStory) throws Exception {
		this.parentStory = parentStory;
		this.parentStoryId = parentStory.getId();
		TextFrame nextInThread = this.getNextInThread();
		if (nextInThread != null) {
			nextInThread.setParentStory(parentStory);
		}
		return parentStory;
	}
	
	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/**
	 * Sets the master frame for the frame, e.g., because the frame was
	 * created as an override of a master frame.
	 * @param masterFrame
	 */
	public void setMasterFrame(TextFrame masterFrame) {
		this.masterFrame = masterFrame;
	}
	
	/**
	 * Gets the master frame associated with the frame, if any.
	 * @return The master frame, or null if there is no associated master.
	 * @throws Exception
	 */
	public TextFrame getMasterFrame() throws Exception {
		return this.masterFrame;
	}

	/**
	 * Set the next frame in the thread. Automatically
	 * sets this frame as the previous frame on 
	 * the specified text frame.
	 * @param nextTextFrame The frame to which this frame
	 * is to be threaded.
	 */
	public void setNextInThread(TextFrame nextTextFrame) {
		this.nextInThread = nextTextFrame;
		if (nextTextFrame != null) {
			nextTextFrame.setPreviousInThread(this);
		}
	}

	/**
	 * Sets the previous text frame in thread. Should only
	 * be set as a side effect of having set this frame
	 * as the next frame in thread on some other frame.
	 * @param textFrame
	 */
	protected void setPreviousInThread(TextFrame textFrame) {
		this.previousInThread = textFrame;
	}

	/**
	 * Get the frame to which this frame threads, if any.
	 * @return Frame or null if there is no next thread.
	 * @throws Exception 
	 */
	public TextFrame getNextInThread() throws Exception {
		if (nextInThread == null && hasProperty(InDesignDocument.PROP_NTXF)) {
				String objectId = getObjectReferenceProperty(InDesignDocument.PROP_NTXF);
				if (objectId != null) {
					this.nextInThread = (TextFrame)this.getDocument().getObject(objectId);
				}
		}
		return this.nextInThread;
	}

	/**
	 * Get the text frame that is before this frame in the thread this
	 * frame is part of.
	 * @return The previous frame, or null if this is the first or only
	 * frame in the thread.
	 */
	public TextFrame getPreviousInThread() {
		return this.previousInThread;
	}




}

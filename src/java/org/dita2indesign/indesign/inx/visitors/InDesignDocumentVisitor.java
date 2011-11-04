/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.visitors;

import org.dita2indesign.indesign.inx.model.ContourOption;
import org.dita2indesign.indesign.inx.model.DocumentPreferences;
import org.dita2indesign.indesign.inx.model.Image;
import org.dita2indesign.indesign.inx.model.InDesignComponent;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.InDesignObject;
import org.dita2indesign.indesign.inx.model.Link;
import org.dita2indesign.indesign.inx.model.MasterSpread;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.Rectangle;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.Story;
import org.dita2indesign.indesign.inx.model.TextContents;
import org.dita2indesign.indesign.inx.model.TextFrame;
import org.dita2indesign.indesign.inx.model.TextStyleRange;
import org.dita2indesign.indesign.inx.model.TextWrapPreferences;


/**
 * Interface for all InDesign document visitors
 */
public interface InDesignDocumentVisitor {

	/**
	 * Starting method by which users of the visitor initiate the visitation
	 * operation.
	 * @param doc InDesign document instance to be visited.
 	 */
	void visitDocument(InDesignDocument doc) throws Exception;

	/**
	 * @param inDesignDocument
	 * @throws Exception 
	 */
	void visit(InDesignDocument inDesignDocument) throws Exception;

	/**
	 * @param comp
	 */
	void visit(InDesignComponent comp) throws Exception;

	/**
	 * @param obj
	 */
	void visit(InDesignObject obj) throws Exception;

	/**
	 * @param frame
	 */
	void visit(TextFrame frame) throws Exception;

	/**
	 * @param rect
	 */
	void visit(Rectangle rect) throws Exception;

	/**
	 * @param spread
	 */
	void visit(Spread spread) throws Exception;

	/**
	 * @param masterSpread
	 */
	void visit(MasterSpread masterSpread) throws Exception;

	/**
	 * @param page
	 */
	void visit(Page page) throws Exception;

	/**
	 * @param story
	 */
	void visit(Story story) throws Exception;

	/**
	 * @param run
	 */
	void visit(TextStyleRange run) throws Exception;

	/**
	 * @param run
	 */
	void visit(TextContents pcnt) throws Exception;

	/**
	 * @param prefs
	 */
	void visit(DocumentPreferences prefs) throws Exception;

	/**
	 * @param link
	 */
	void visit(Link link) throws Exception;

	/**
	 * @param image
	 */
	void visit(Image image) throws Exception;

	/**
	 * @param contourOption
	 */
	void visit(ContourOption contourOption) throws Exception;

	/**
	 * @param textWrapPrefs
	 */
	void visit(TextWrapPreferences textWrapPrefs) throws Exception;

}

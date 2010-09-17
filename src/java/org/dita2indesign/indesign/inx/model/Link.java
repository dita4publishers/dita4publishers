/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.w3c.dom.Element;


/**
 * Represents a link to another resource, such an InCopy article or
 * graphic.
 */
public class Link extends InDesignObject {
	
	public static final class LinkStatus {
		public static final int LINK_EMBEDDED = 1282237028;
		public static final int LINK_MISSING = 1819109747;
		public static final int LINK_OUT_OF_DATE = 1819242340;
		public static final int NORMAL = 1852797549;
	}
	
	public static final class LinkStockState {
		public static final int LINK_IS_NOT_STOCK = 1819177835;
		public static final int LINK_IS_STOCK_COMP = 1819503459;
		public static final int LINK_IS_STOCK_HIGH_RESOLUITION = 1819503464;
	}
	
	public static final class EditingState {
		public static final int EDITING_CONFLICT = 1986217283;
		public static final int EDITING_LOCALLY = 1986217292;
		public static final int EDITING_LOCALLY_LOCKED = 1986217291;
		public static final int EDITING_NOWHERE = 1986217294;
		public static final int EDITING_REMOTELY = 1986217298;
		public static final int EDITING_UNKNOWN = 1986217301;
		
	}
	
	public static final class VersionState {
		public static final int LOCAL_NEWER = 1986221644;
		public static final int LOCAL_PROJECT_MATCH = 1986221645;
		public static final int NO_RESOURCE = 1986221646;
		public static final int PROJECT_FILE_NEWER = 1986221648;
		public static final int VERSION_CONFLICT = 1986221635;
		public static final int VERSION_UNKNOWN = 1986221653;
	}
	/**
	 * NOTE: These constants are guesses based on instance documents.
	 * Have not been able to find documentation for these values.
	 */
	public static final class LinkFileType {
		public static final int TIFF = 0x0;
		public static final int JPEG = 0x4a504547;
		/**
		 * Note that EPS and Illustrator files are classified as PDF in the file type string.
		 */
		public static final int EPS_PDF_AI = 0x50444620;
		public static final int INCOPY_ARTICLE = 0x49437835;
	}
	
	/**
	 * NOTE: These constants are guesses based on instance documents.
	 * Have not been able to find documentation for these values.
	 */
	public static final class LinkType {
		public static final String TIFF = "TIFF";
		public static final String JPEG = "JPEG";
		public static final String EPS_PDF_AI = "Adobe Portable Document Format (PDF)";
		public static final String INCOPY = "InCopyInterchange";
	}
	
	
	
	/*
	 * These are the values in the LnkI attribute.
	 * See section "p_LinkInfo" in the Working With INX File Format doc
	 * from the CS3 SDK documentation.
	 * 
Link name:                c link_test_01-Article 2This.incx
Link volume (Mac only):   c Macintosh HD
DirID:                    l 786c08
Class ID (invariant):     l 8c01
Link type:                k InCopyInterchange
File type:                l 49437835
MacOS file name:          c Macintosh HD:Users:ekimber:workspace:rsi-inx-util:test:resources:link_test_01 Assignments:content:link_test_01-Article 2This.incx
File size:                L 0~3c40
File timestamp:           T 2008-12-04T12:17:30
Link state:               l 0
IsLinkNeeded:             b f
linkEdited:               b f
	 */
	
	private String windowsFileName;
	private String volume = "Macintosh HD";
	private long dirId;
	private long classId = 0x8c01;
	private String linkType;
	private long fileType;
	private String macFileName;
	private long fileSize;
	private Date date;
	private long editingState;
	private boolean isLinkNeeded;
	private boolean linkEdited;

	public void loadObject(Element dataSource) throws Exception {
		super.loadObject(dataSource);
		this.getDocument().addLink(this);
		if (dataSource.hasAttribute("LnkI")) {
			List<InxValue> values = InxHelper.decodeRawValueToList(dataSource.getAttribute("LnkI"));
			int i = 0;
			// NOTE: For Windows-based files, the name property is the full path, but for Mac-based files
			//       it is only the name part. The macFileName will have a value for Mac files, no value
			//       for Windows files.
			this.windowsFileName = (String)values.get(i++).getValue();
			this.volume = (String)values.get(i++).getValue();
			this.dirId = ((Long)values.get(i++).getValue()).longValue();
			this.classId = ((Long)values.get(i++).getValue()).longValue();
			this.linkType = (String)values.get(i++).getValue();
			this.fileType = ((Long)values.get(i++).getValue()).longValue();
			this.macFileName = (String)values.get(i++).getValue();
			this.fileSize = ((Long)values.get(i++).getValue()).longValue();
			this.date = (Date)values.get(i++).getValue();
			this.editingState = ((Long)values.get(i++).getValue()).longValue();
			this.isLinkNeeded = ((Boolean)values.get(i++).getValue()).booleanValue();
			this.linkEdited = ((Boolean)values.get(i++).getValue()).booleanValue();
		}
	}
	
	public void setDocument(InDesignDocument doc) {
		super.setDocument(doc);
	}

	/**
	 * @return the name
	 */
	public String getWindowsFileName() {
		return this.windowsFileName;
	}

	/**
	 * @param name the name to set
	 */
	public void setWindowsFileName(String name) {
		this.windowsFileName = name;
	}

	/**
	 * @return the volume
	 */
	public String getVolume() {
		return this.volume;
	}

	/**
	 * @param volume the volume to set
	 */
	public void setVolume(String volume) {
		this.volume = volume;
	}

	/**
	 * @return the dirId
	 */
	public long getDirId() {
		return this.dirId;
	}

	/**
	 * @param dirId the dirId to set
	 */
	public void setDirId(long dirId) {
		this.dirId = dirId;
	}

	/**
	 * @return the classId
	 */
	public long getClassId() {
		return this.classId;
	}

	/**
	 * @param classId the classId to set
	 */
	public void setClassId(long classId) {
		this.classId = classId;
	}

	/**
	 * @return the linkType
	 */
	public String getLinkType() {
		return this.linkType;
	}

	/**
	 * @param linkType the linkType to set
	 */
	public void setLinkType(String linkType) {
		this.linkType = linkType;
	}

	/**
	 * @return the fileType
	 */
	public long getFileType() {
		return this.fileType;
	}

	/**
	 * @param fileType the fileType to set
	 */
	public void setFileType(long fileType) {
		this.fileType = fileType;
	}

	/**
	 * @return the macFileName
	 */
	public String getMacFileName() {
		return this.macFileName;
	}

	/**
	 * @param macFileName the macFileName to set
	 */
	public void setMacFileName(String macFileName) {
		this.macFileName = macFileName;
	}

	/**
	 * @return the fileSize
	 */
	public long getFileSize() {
		return this.fileSize;
	}

	/**
	 * @param fileSize the fileSize to set
	 */
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	/**
	 * @return the date
	 */
	public Date getDate() {
		if (date == null) {
			date = Calendar.getInstance().getTime();
		}
		return this.date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(Date date) {
		this.date = date;
	}

	/**
	 * @return the editingState
	 */
	public long getEditingState() {
		return this.editingState;
	}

	/**
	 * @param editingState the editingState to set
	 */
	public void setEditingState(long editingState) {
		this.editingState = editingState;
	}

	/**
	 * @return the isLinkNeeded
	 */
	public boolean isLinkNeeded() {
		return this.isLinkNeeded;
	}

	/**
	 * @param isLinkNeeded the isLinkNeeded to set
	 */
	public void setLinkNeeded(boolean isLinkNeeded) {
		this.isLinkNeeded = isLinkNeeded;
	}

	/**
	 * @return the linkEdited
	 */
	public boolean isLinkEdited() {
		return this.linkEdited;
	}

	/**
	 * @param linkEdited the linkEdited to set
	 */
	public void setLinkEdited(boolean linkEdited) {
		this.linkEdited = linkEdited;
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}


}

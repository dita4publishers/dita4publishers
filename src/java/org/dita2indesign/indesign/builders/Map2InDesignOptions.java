/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.builders;

import java.io.File;
import java.net.URL;

/**
 * Holds options required by the DITA map to InDesign transform.
 */
public class Map2InDesignOptions {

	private String styleCatalogUrl;
	private URL xsltUrl;
	private String debug = String.valueOf(false);
	private String linksPath = "links";
	private File resultFile;
	private URL inDesignTemplate;

	/**
	 * @return the linksPath
	 */
	public String getLinksPath() {
		return this.linksPath;
	}

	/**
	 * @param linksPath the linksPath to set
	 */
	public void setLinksPath(String linksPath) {
		this.linksPath = linksPath;
	}

	/**
	 * @return URL string of the style catalog used by the resulting
	 * InCopy articles.
	 */
	public String getStyleCatalogUrl() {
		return this.styleCatalogUrl;
	}

	/**
	 * @param styleCatalogUrl
	 */
	public void setStyleCatalogUrl(String styleCatalogUrl) {
		this.styleCatalogUrl = styleCatalogUrl;
		
	}

	/**
	 * @param styleCatalogUrl
	 */
	public void setStyleCatalogUrl(URL styleCatalogUrl) {
		this.styleCatalogUrl = styleCatalogUrl.toExternalForm();
	}

	/**
	 * @return URL of the XSLT that generates InCopy articles from a DITA map.
	 */
	public URL getXsltUrl() {
		return xsltUrl;
	}

	/**
	 * @param xsltUrl
	 */
	public void setXsltUrl(URL xsltUrl) {
		this.xsltUrl = xsltUrl;
	}

	/**
	 * @return
	 */
	public String getDebug() {
		return this.debug;
	}
	
	public void setDebug(boolean debug) {
		this.debug = String.valueOf(debug);
	}

	/**
	 * @param inxFile
	 */
	public void setResultFile(File inxFile) {
		this.resultFile = inxFile;
	}

	/**
	 * @return
	 */
	public File getResultFile() {
		return this.resultFile;
	}

	/**
	 * @param xsltUrl
	 * @throws Exception 
	 */
	public void setXsltUrl(String xsltUrl) throws Exception {
		this.xsltUrl = new URL(xsltUrl);
	}

	/**
	 * @param idTemplate
	 */
	public void setInDesignTemplate(URL idTemplate) {
		this.inDesignTemplate = idTemplate;
	}

	/**
	 * @return
	 */
	public URL getInDesignTemplate() {
		return inDesignTemplate;
	}

}

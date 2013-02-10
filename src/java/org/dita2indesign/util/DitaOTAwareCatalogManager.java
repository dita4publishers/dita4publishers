/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

 */
package org.dita2indesign.util;

import java.io.File;

import org.apache.xml.resolver.CatalogManager;

/**
 * Catalog Manager that knows about DITA Open Toolkits and
 * provides ways to find the appropriate OT instance to
 * use as the catalog source.
 * <p>
 * The location of the DITA Open Toolkit can be set one of
 * three ways, in order of precedence:
 * <ul>
 * <li>Specify the path on the constructor</li>
 * <li>Set Java propery dita.ot.home</li>
 * <li>Set environment variable DITAOT_HOME</li>
 * </ul>
 * 
 */
public class DitaOTAwareCatalogManager extends CatalogManager {
	
	private String otHome;

	public DitaOTAwareCatalogManager() {
		String otHome;
		otHome = System.getProperty("dita.ot.home");
		if (otHome == null || "".equals(otHome)) {
			otHome = System.getenv("DITAOT_HOME");
			if (otHome == null || "".equals(otHome)) {
				throw new RuntimeException("Environment variable DITAOT_HOME not set and system property dita.ot.home not set");
			}
		}
		this.setDitaOTHome(otHome);
	}

	/**
	 * 
	 * @param ditaOTHome Path to the DITA Open Toolkit root directory.
	 */
	public DitaOTAwareCatalogManager(String ditaOTHome) {
		this.setDitaOTHome(otHome);
	}

	/**
	 * @param otHome
	 */
	public void setDitaOTHome(String otHome) {
		this.otHome = otHome;
		File otDir = new File(otHome);
		if (!otDir.exists()) {
			throw new RuntimeException("DITA OT directory \"" + otDir.getAbsolutePath() + "\" does not exist.");
		}
		if (!otDir.canRead()) {
			throw new RuntimeException("DITA OT directory \"" + otDir.getAbsolutePath() + "\" exists but is not readable.");
		}
		
		File otCatalog = new File(otDir, "catalog-dita.xml");
		if (!otCatalog.exists()) {
			throw new RuntimeException("DITA OT master catalog \"" + otCatalog.getAbsolutePath() + "\" does not exist.");
		}
		if (!otCatalog.canRead()) {
			throw new RuntimeException("DITA OT master catalog \"" + otCatalog.getAbsolutePath() + "\" exists but is not readable.");
		}
		this.setCatalogFiles(otCatalog.getAbsolutePath());
	}

}

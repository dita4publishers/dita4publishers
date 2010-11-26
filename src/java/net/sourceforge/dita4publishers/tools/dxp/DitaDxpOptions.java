/**
 * Copyright 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.dxp;


import java.util.ArrayList;
import java.util.List;

import net.sourceforge.dita4publishers.tools.common.MapBosProcessorOptions;

/**
 * Holds options that control the packing and unpacking of DXP packages.
 */
public class DitaDxpOptions extends MapBosProcessorOptions {

	/**
	 * Unzip all entries in the DXP package.
	 */
	private boolean unzipAll = true;
	private List<String> rootMaps = new ArrayList<String>();
	/**
	 * Indicates whether or not the entire DXP package should be unzipped.
	 * @return if true, all members of the DXP package should be unzipped.
	 */
	public boolean isUnzipAll() {
		return unzipAll;
	}

	/**
	 * Set to true if all members of the DXP package should be unzipped.
	 * If set to false, only the root map or specified maps (as named
	 * in an explicit manifest) will be unpacked.
	 * @param unzipAll
	 */
	public void setUnzipAll(boolean unzipAll) {
		this.unzipAll = unzipAll;
	}

	/**
	 * Gets the list of root map IDs, as specified in the package manifest,
	 * to be operated on (e.g., unpacked). If not set, then the implicit
	 * root map is used.
	 * @return List, possibly empty, of root maps to process. An empty list
	 * indicates that the package's root map should be used.
	 */
	public List<String> getRootMaps() {
		return this.rootMaps;
	}

	/**
	 * Add a root map ID to the list of root maps to be processed.
	 * @param mapId ID, as defined in the package manifest, to be processed.
	 */
	public void addMapId(String mapId) {
		this.rootMaps.add(mapId);
	}
}

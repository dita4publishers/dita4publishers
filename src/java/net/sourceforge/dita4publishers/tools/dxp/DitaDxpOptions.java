/**
 * Copyright (c) 2010 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.tools.dxp;

import java.util.ArrayList;
import java.util.List;

/**
 * Holds options that control the packing and unpacking of DXP packages.
 */
public class DitaDxpOptions {

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
}

/**
 * 
 */
package net.sourceforge.dita4publishers.tools.common;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;


/**
 * Base class for processor-specific options. Handles
 * generic or common options.
 */
public abstract class MapBosProcessorOptions {

	private boolean quiet = false;
	// Default log in case user doesn't set the log option.
	private Log log = LogFactory.getLog(MapBosProcessorOptions.class);
	private Document rootDoc;

	/**
	 * Sets the "quiet" option to true or false
	 * @param b True means "be quiet" (no informative logging)
	 */
	public void setQuiet(boolean b) {
		this.quiet = b;
	}

	/**
	 * Indicates whether or not the "quiet" option has been set.
	 * @return True if quiet has been set to true.
	 */
	public boolean isQuiet() {
		return this.quiet == true;
	}
	
	/**
	 * @param log
	 */
	public void setLog(Log log) {
		this.log = log;
	}

	/**
	 * @return
	 */
	public Log getLog() {
		return this.log;
	}

	/**
	 */
	public Document getRootDocument() {
		return this.rootDoc;
	}

	/**
	 * @param rootDoc
	 */
	public void setRootDocument(Document rootDoc) {
		this.rootDoc = rootDoc;
	}

}

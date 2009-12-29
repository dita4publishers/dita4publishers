/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.io.PrintStream;

/**
 * Base interface for classes that do reporting to print streams.
 */
public interface Reporter {

	/**
	 * Sets the print stream to write the report to.
	 * @param outStream
	 * @throws DitaApiException
	 */
	void setPrintStream(PrintStream outStream) throws DitaApiException;


}

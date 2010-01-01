/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import net.sourceforge.dita4publishers.api.Reporter;


/**
 * Generates a report of a key space.
 */
public interface KeySpaceReporter extends Reporter {

	/**
	 * Generates a key space report.
	 * @param keyAccessOptions 
	 * @param keySpace Key space to be reported.
	 * @param reportOptions Options that configure the report.
	 * @throws DitaApiException 
	 */
	void report(KeyAccessOptions keyAccessOptions, DitaKeySpace keySpace, KeyReportOptions reportOptions) throws DitaApiException;

}

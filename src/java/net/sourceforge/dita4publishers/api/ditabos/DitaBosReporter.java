/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.ditabos;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet;

/**
 * Interface for DITA BOS reporters
 */
public interface DitaBosReporter extends BosReporter {

	/**
	 * @param mapBos
	 * @param bosReportOptions 
	 */
	void report(DitaBoundedObjectSet mapBos, BosReportOptions bosReportOptions) throws DitaApiException;

}

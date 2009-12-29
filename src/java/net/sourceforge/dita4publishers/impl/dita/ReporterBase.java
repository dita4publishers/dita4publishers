/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.io.PrintStream;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.Reporter;

/**
 * Base implementation class for Reporter instances. All reporters are
 * constructed dynamically and therefore must provide a no-parameter
 * constructor.
 */
public abstract class ReporterBase implements Reporter {
	
	protected PrintStream outStream = System.out;
	
	public ReporterBase() {
		// Nothing to do.
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter#setPrintStream(java.io.PrintStream)
	 */
	public void setPrintStream(PrintStream outStream) throws DitaApiException {
		this.outStream = outStream;
	}



}

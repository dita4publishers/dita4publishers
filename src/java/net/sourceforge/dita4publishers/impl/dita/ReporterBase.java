/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.io.PrintStream;

import net.sourceforge.dita4publishers.api.Reporter;
import net.sourceforge.dita4publishers.api.dita.DitaApiException;

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

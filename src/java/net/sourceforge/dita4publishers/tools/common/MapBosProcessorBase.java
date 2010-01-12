/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.common;

import java.io.File;

import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpOptions;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;

/**
 * Base class for tools that operate on map bounded object sets.
 */
public abstract class MapBosProcessorBase {

	/**
	 * 
	 */
	public static final String QUIET_OPTION_ONE_CHAR = "q";
	/**
	 * 
	 */
	protected static final String OUTPUT_OPTION_ONE_CHAR = "o";
	/**
	 * 
	 */
	protected static final String INPUT_OPTION_ONE_CHAR = "i";
	protected static final String CATALOG_OPTION_ONE_CHAR = "c";
	protected static final String DITAVAL_OPTION_ONE_CHAR = "d";
	protected static final String ADDRESSING_FAILURE_OPTION_ONE_CHAR = "f";
	protected CommandLine commandLine;

	/**
	 * @param bosOptions
	 */
	protected void setupCatalogs(BosConstructionOptions bosOptions) {
		String[] catalogs = new String[1];
		File catalogFile = null;
		
		if (commandLine.hasOption(CATALOG_OPTION_ONE_CHAR)) {
			String catalogPath = commandLine.getOptionValue(CATALOG_OPTION_ONE_CHAR);
			catalogFile = new File(catalogPath);
			
		} else {
			String ditaHome = System.getenv("DITA_HOME");
			if (ditaHome != null && !"".equals(ditaHome.trim())) {
				File ditaDir = new File(ditaHome);
				catalogFile = new File(ditaDir, "catalog-dita.xml");
				
			}
		}
		if (catalogFile != null) {
			try {
				checkExistsAndCanRead(catalogFile);
			} catch (Exception e) {
				System.err.println("Catalog file \"" + catalogFile.getAbsolutePath() + "\" does not exist or cannot be read.");
				System.exit(1);
			}
			catalogs[0] = catalogFile.getAbsolutePath(); 
		}
			
		bosOptions.setCatalogs(catalogs);
		
	}

	protected void handleCommonDxpOptions(DitaDxpOptions options) {
		if (commandLine.hasOption(QUIET_OPTION_ONE_CHAR)) {
			options.setQuiet(true);
		}
	}

	protected static void checkExistsAndCanReadSystemExit(File file) {
		try {
			checkExistsAndCanRead(file);
		} catch(Exception e) {
			System.err.println(e.getMessage());
			System.exit(-1);
		}
	}

	/**
	 * @param file
	 */
	private static void checkExistsAndCanRead(File file) {
		if (!file.exists()) {
			throw new RuntimeException("File " + file.getAbsolutePath() + " does not exist.");
		}
		if (!file.canRead()) {
			throw new RuntimeException("File " + file.getAbsolutePath() + " exists but cannot be read.");
		}
	}
	
	protected static Options configureOptionsBase() {
		Options options = new Options();
		Option opt = null;
		
		options.addOption(INPUT_OPTION_ONE_CHAR, "map", true, "(Input) The root map from which to calculate the map tree or bounded object set");
		opt = options.getOption(INPUT_OPTION_ONE_CHAR);
		opt.setRequired(true);

		options.addOption(OUTPUT_OPTION_ONE_CHAR, "out", true, "(Output) The name of the output directory and, optionally, report file to generate.  " +
				"If not specified, output goes to STDOUT.");
		opt = options.getOption(OUTPUT_OPTION_ONE_CHAR);
		opt.setRequired(true);

		options.addOption(CATALOG_OPTION_ONE_CHAR, "catalog", true, "(Catalog) Path and filename of the XML catalog to use for resolving DTDs (e.g., catalog-dita.xml)");
		opt = options.getOption(OUTPUT_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(DITAVAL_OPTION_ONE_CHAR, "ditaval", true, "(Ditaval) Path and filename of the the Ditaval file to used to determine applicable key definitions and other elements.");
		opt = options.getOption(DITAVAL_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(QUIET_OPTION_ONE_CHAR, "quiet", false, "(Quiet) Turns off logging of actions.");
		opt = options.getOption(QUIET_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(ADDRESSING_FAILURE_OPTION_ONE_CHAR, "addressfailure", false, "(Fail on addressing failure) When specified, addressing failures cause BOS construction to fail.");
		opt = options.getOption(ADDRESSING_FAILURE_OPTION_ONE_CHAR);
		opt.setRequired(false);

		return options;
	}

}

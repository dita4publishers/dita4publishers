/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.util.Date;
import java.util.HashMap;

import net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.api.dita.KeyReportOptions;
import net.sourceforge.dita4publishers.api.dita.KeySpaceReporter;
import net.sourceforge.dita4publishers.api.ditabos.BosReportOptions;
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter;
import net.sourceforge.dita4publishers.impl.dita.TextKeySpaceReporter;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.impl.ditabos.DomUtil;
import net.sourceforge.dita4publishers.impl.ditabos.TextDitaBosReporter;
import net.sourceforge.dita4publishers.util.TimingUtils;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

/**
 * Command-line utility to construct a DITA map BOS and generate
 * a textual BOS report to STDOUT.
 */
public class MapBosReporter {
	
	private static Log log = LogFactory.getLog(MapBosReporter.class);

	/**
	 * 
	 */
	private static final String OUTPUT_OPTION_ONE_CHAR = "o";
	/**
	 * 
	 */
	private static final String INPUT_OPTION_ONE_CHAR = "i";

	private static final String CATALOG_OPTION_ONE_CHAR = "c";

	private static final String MAPTREE_OPTION_ONE_CHAR = "m";

	private CommandLine commandLine;

	/**
	 * @param line
	 */
	public MapBosReporter(CommandLine line) {
		this.commandLine = line;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		Options cmdlineOptions = configureOptions();

		CommandLineParser parser = new PosixParser();
		
	    CommandLine line = null;
		try {
		    // parse the command line arguments
		    line = parser.parse(cmdlineOptions, args );
		}
		catch( ParseException exp ) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(MapBosReporter.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		if (!line.hasOption(INPUT_OPTION_ONE_CHAR)) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(MapBosReporter.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		
		MapBosReporter app = new MapBosReporter(line);
		try {
			app.run();
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}

	}

	/**
	 * @throws Exception 
	 * 
	 */
	private void run() throws Exception {
		String mapFilepath = commandLine.getOptionValue("i");
		File mapFile = new File(mapFilepath);
		checkExistsAndCanReadSystemExit(mapFile);
		System.err.println("Processing map \"" + mapFile.getAbsolutePath() + "\"...");
		
		Document rootMap = null;
		BosConstructionOptions bosOptions = new BosConstructionOptions(log, new HashMap<URI, Document>());
		if (commandLine.hasOption(MAPTREE_OPTION_ONE_CHAR)) {
			bosOptions.setMapTreeOnly(true);
			System.err.println("MapBosReporter: Calculating map tree...");
		} else {
			System.err.println("MapBosReporter: Calculating full map BOS...");
		}
		
		setupCatalogs(bosOptions);
		
		URL rootMapUrl = mapFile.toURL();
		rootMap = DomUtil.getDomForUri(new URI(rootMapUrl.toExternalForm()), bosOptions);
		Date startTime = TimingUtils.getNowTime();
		DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);
		log.info("Map BOS construction took " + TimingUtils.reportElapsedTime(startTime));
		DitaBosReporter bosReporter = new TextDitaBosReporter();
		BosReportOptions bosReportOptions = new BosReportOptions();
		bosReporter.report(mapBos, bosReportOptions);
		
		DitaKeySpace keySpace = mapBos.getKeySpace();
				
		KeySpaceReporter reporter = new TextKeySpaceReporter(System.out);
		KeyReportOptions reportOptions = new KeyReportOptions();
		reportOptions.setAllKeys(true);
		reporter.report(new KeyAccessOptions(), keySpace, reportOptions);

	}

	/**
	 * @param bosOptions
	 */
	private void setupCatalogs(BosConstructionOptions bosOptions) {
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

	/**
	 * @return
	 */
	private static Options configureOptions() {
		Options options = new Options();
		Option opt = null;
		
		options.addOption(INPUT_OPTION_ONE_CHAR, "map", true, "(Input) The root map from which to calculate the map tree or bounded object set");
		opt = options.getOption(INPUT_OPTION_ONE_CHAR);
		opt.setRequired(true);

		options.addOption(OUTPUT_OPTION_ONE_CHAR, "out", true, "(Output) The name of the output directory and, optionally, report file to generate.  " +
				"If not specified, output goes to STDOUT.");
		opt = options.getOption(OUTPUT_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(CATALOG_OPTION_ONE_CHAR, "catalog", true, "(Catalog) Path and filename of the XML catalog to use for resolving DTDs (e.g., catalog-dita.xml)");
		opt = options.getOption(OUTPUT_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(MAPTREE_OPTION_ONE_CHAR, "maptree", false, "(Map tree only) When specified, only calculates the map tree, not the entire DITA BOS.");
		opt = options.getOption(OUTPUT_OPTION_ONE_CHAR);
		opt.setRequired(false);


		return options;
	}

	private static void checkExistsAndCanReadSystemExit(File file) {
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


}

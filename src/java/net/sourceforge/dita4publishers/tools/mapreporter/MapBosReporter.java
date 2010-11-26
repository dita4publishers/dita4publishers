/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.mapreporter;

import java.io.File;
import java.io.PrintStream;
import java.net.URI;
import java.net.URL;
import java.util.Date;
import java.util.HashMap;

import net.sourceforge.dita4publishers.api.bos.BosReportOptions;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.api.dita.KeyReportOptions;
import net.sourceforge.dita4publishers.api.dita.KeySpaceReporter;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorBase;
import net.sourceforge.dita4publishers.util.DomUtil;
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
 * a BOS report to STDOUT.
 * <p>The MapBosReporter can use any DitaBosReporter or KeySpaceReporter
 * implementations to generate the actual report.</p>
 */
public class MapBosReporter extends MapBosProcessorBase {
	
	private static Log log = LogFactory.getLog(MapBosReporter.class);

	private static final String MAPTREE_OPTION_ONE_CHAR = "m";

	private static final String BOS_REPORTER_CLASS_OPTION_ONE_CHAR = "b";

	private static final String KEYSPACE_REPORTER_CLASS_OPTION_ONE_CHAR = "k";

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
		
	    CommandLine cmdline = null;
		try {
		    // parse the command line arguments
		    cmdline = parser.parse(cmdlineOptions, args );
		}
		catch( ParseException exp ) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(MapBosReporter.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		if (!cmdline.hasOption(INPUT_OPTION_ONE_CHAR)) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(MapBosReporter.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		
		MapBosReporter app = new MapBosReporter(cmdline);
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

		PrintStream outStream = System.out;

		if (commandLine.hasOption(OUTPUT_OPTION_ONE_CHAR)) {
			String outputFilepath = commandLine.getOptionValue("o");
			File outputFile = new File(outputFilepath);
			
			if (!outputFile.getParentFile().canWrite()) {
				throw new RuntimeException("File " + outputFile.getAbsolutePath() + " cannot be written to.");
			}
			outStream = new PrintStream(outputFile);
		}
				
		DitaBosReporter bosReporter = getBosReporter(outStream);
		KeySpaceReporter keyreporter = getKeyspaceReporter(outStream);

		Document rootMap = null;
		BosConstructionOptions bosOptions = new BosConstructionOptions(log, new HashMap<URI, Document>());
		if (commandLine.hasOption(MAPTREE_OPTION_ONE_CHAR)) {
			bosOptions.setMapTreeOnly(true);
			System.err.println("MapBosReporter: Calculating map tree...");
		} else {
			System.err.println("MapBosReporter: Calculating full map BOS...");
		}
		
		setupCatalogs(bosOptions);
		
		
		try {
			URL rootMapUrl = mapFile.toURI().toURL();
			rootMap = DomUtil.getDomForUri(new URI(rootMapUrl.toExternalForm()), bosOptions);
			Date startTime = TimingUtils.getNowTime();
			DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);
			System.err.println("Map BOS construction took " + TimingUtils.reportElapsedTime(startTime));
			BosReportOptions bosReportOptions = new BosReportOptions();
			bosReporter.report(mapBos, bosReportOptions);
			
			DitaKeySpace keySpace = mapBos.getKeySpace();
			
			KeyReportOptions reportOptions = new KeyReportOptions();
			reportOptions.setAllKeys(true);
			keyreporter.report(new KeyAccessOptions(), keySpace, reportOptions);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			outStream.close();
		}

	}

	@SuppressWarnings("unchecked")
	protected KeySpaceReporter getKeyspaceReporter(PrintStream outStream) throws Exception {
		String reporterClass = TextKeySpaceReporter.class.getCanonicalName();
		if (commandLine.hasOption(KEYSPACE_REPORTER_CLASS_OPTION_ONE_CHAR))
			reporterClass = commandLine.getOptionValue(KEYSPACE_REPORTER_CLASS_OPTION_ONE_CHAR);
		Class<? extends KeySpaceReporter> clazz;
		try {
			clazz = (Class<? extends KeySpaceReporter>) Class.forName(reporterClass);
		} catch (ClassNotFoundException e) {
			System.err.println("Key space reporter class \"" + reporterClass + "\" not found. Check class name and class path.");
			throw e;
		} 
		KeySpaceReporter reporter;
		try {
			reporter = clazz.newInstance();
		} catch (Exception e) {
			System.err.println("Failed to create instance of key space reporter class \"" + reporterClass + "\": " + e.getMessage());
			throw e;
		}
		reporter.setPrintStream(outStream);
		return reporter;
	}

	@SuppressWarnings("unchecked")
	protected DitaBosReporter getBosReporter(PrintStream outStream) throws Exception {
		String reporterClass = TextDitaBosReporter.class.getCanonicalName();
		if (commandLine.hasOption(BOS_REPORTER_CLASS_OPTION_ONE_CHAR))
			reporterClass = commandLine.getOptionValue(BOS_REPORTER_CLASS_OPTION_ONE_CHAR);
		Class<? extends DitaBosReporter> clazz;
		try {
			clazz = (Class<? extends DitaBosReporter>) Class.forName(reporterClass);
		} catch (ClassNotFoundException e) {
			System.err.println("BOS reporter class \"" + reporterClass + "\" not found. Check class name and class path.");
			throw e;
		} 
		DitaBosReporter reporter;
		try {
			reporter = clazz.newInstance();
		} catch (Exception e) {
			System.err.println("Failed to create instance of BOS reporter class \"" + reporterClass + "\": " + e.getMessage());
			throw e;
		}
		reporter.setPrintStream(outStream);
		return reporter;
	}

	/**
	 * @return
	 */
	protected static Options configureOptions() {
		Options options = configureOptionsBase();
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

		options.addOption(DITAVAL_OPTION_ONE_CHAR, "ditaval", true, "(Ditaval) Path and filename of the the Ditaval file to used to determine applicable key definitions and other elements.");
		opt = options.getOption(DITAVAL_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(BOS_REPORTER_CLASS_OPTION_ONE_CHAR, "bosreporterclass", true, "(BOS reporter class) Fully-qualified class name of the BOS reporter to use. " +
				"If not specified, the built-in text BOS reporter is used.");
		opt = options.getOption(BOS_REPORTER_CLASS_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(KEYSPACE_REPORTER_CLASS_OPTION_ONE_CHAR, "keyspacereporterclass", true, "(Key space reporter class) Fully-qualified class name of the key space reporter to use." +
				" If not specified, the built-in text key space reporter is used.");
		opt = options.getOption(KEYSPACE_REPORTER_CLASS_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(MAPTREE_OPTION_ONE_CHAR, "maptree", false, "(Map tree only) When specified, only calculates the map tree, not the entire DITA BOS.");
		opt = options.getOption(OUTPUT_OPTION_ONE_CHAR);
		opt.setRequired(false);


		return options;
	}


}

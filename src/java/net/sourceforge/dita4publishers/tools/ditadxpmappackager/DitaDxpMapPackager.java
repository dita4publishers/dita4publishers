/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.ditadxpmappackager;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.util.Date;
import java.util.HashMap;

import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorBase;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpHelper;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpOptions;
import net.sourceforge.dita4publishers.util.DomUtil;
import net.sourceforge.dita4publishers.util.TimingUtils;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

/**
 * Command-line utility to create and manage DITA Interchange Packages (DXP).
 * <p>A DITA Interchange Package is a Zip file containing some or all of the
 * dependencies used from a root map.
 * </p>
 */
public class DitaDxpMapPackager extends MapBosProcessorBase {
	
	/**
	 * 
	 */
	public static final String DXP_EXTENSION = ".dxp";
	private static Log log = LogFactory.getLog(DitaDxpMapPackager.class);

	/**
	 * @param line
	 */
	public DitaDxpMapPackager(CommandLine line) {
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
			formatter.printHelp(DitaDxpMapPackager.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		if (!cmdline.hasOption(INPUT_OPTION_ONE_CHAR)) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(DitaDxpMapPackager.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		
		DitaDxpMapPackager app = new DitaDxpMapPackager(cmdline);
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

		DitaDxpOptions dxpOptions = new DitaDxpOptions();
		handleCommonDxpOptions(dxpOptions);

		if (!dxpOptions.isQuiet())
			System.err.println("Processing map \"" + mapFile.getAbsolutePath() + "\"...");



		File outputZipFile = null; 
		String outputFilepath = null;
		if (commandLine.hasOption(OUTPUT_OPTION_ONE_CHAR)) {
			outputFilepath = commandLine.getOptionValue(OUTPUT_OPTION_ONE_CHAR);
			outputZipFile = new File(outputFilepath);
		} else {
			File parentDir = mapFile.getParentFile();
			String nameBase = FilenameUtils.getBaseName(mapFile.getName());
			outputZipFile = new File(parentDir, nameBase + DXP_EXTENSION);
		}
		outputZipFile.getParentFile().mkdirs();
		
		if (!outputZipFile.getParentFile().canWrite()) {
			throw new RuntimeException("File " + outputZipFile.getAbsolutePath() + " cannot be written to.");
		}
				
		Document rootMap = null;
		BosConstructionOptions bosOptions = new BosConstructionOptions(log, new HashMap<URI, Document>());
		bosOptions.setQuiet(dxpOptions.isQuiet());
		setupCatalogs(bosOptions);
		
		
		try {
			URL rootMapUrl = mapFile.toURL();
			rootMap = DomUtil.getDomForUri(new URI(rootMapUrl.toExternalForm()), bosOptions);
			Date startTime = TimingUtils.getNowTime();
			DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);
			if (!dxpOptions.isQuiet())
				System.err.println("Map BOS construction took " + TimingUtils.reportElapsedTime(startTime));
			
			// Do packaging here
			

			DitaDxpHelper.zipMapBos(mapBos, outputZipFile, dxpOptions);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Do final stuff here.
		}

	}

	/**
	 * @return
	 */
	private static Options configureOptions() {
		Options options = configureOptionsBase();
		
		// FIXME: Should provide the ability to zip up a directory, generating a DXP manifest if
		// there are multiple root maps. Should also provide a way to specify multiple input maps and/or
		// add maps an existing package.
		options.getOption(INPUT_OPTION_ONE_CHAR).setDescription("(Input map) Root map to be packaged.");
		options.getOption(OUTPUT_OPTION_ONE_CHAR).setDescription("(Output package) DXP package file.");

		return options;
	}


}

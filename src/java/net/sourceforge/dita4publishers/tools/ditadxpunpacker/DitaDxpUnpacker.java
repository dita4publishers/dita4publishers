/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.ditadxpunpacker;

import java.io.File;

import net.sourceforge.dita4publishers.tools.common.MapBosProcessorBase;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpException;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpHelper;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpOptions;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Command-line utility to unpack DITA Interchange Packages (DXP).
 * <p>A DITA Interchange Package is a Zip file containing some or all of the
 * dependencies used from a root map.
 * </p>
 */
public class DitaDxpUnpacker extends MapBosProcessorBase {
	
	/**
	 * 
	 */
	public static final String MAPS_ID_OPTION_ONE_CHAR = "m";
	/**
	 * 
	 */
	public static final String UNPACK_ALL_OPTION_ONE_CHAR = "a";
	/**
	 * 
	 */
	public static final String DXP_EXTENSION = ".dxp";
	private static Log log = LogFactory.getLog(DitaDxpUnpacker.class);

	/**
	 * @param line
	 */
	public DitaDxpUnpacker(CommandLine line) {
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
			formatter.printHelp(DitaDxpUnpacker.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		if (!cmdline.hasOption(INPUT_OPTION_ONE_CHAR)) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(DitaDxpUnpacker.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		
		DitaDxpUnpacker app = new DitaDxpUnpacker(cmdline);
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
		
		DitaDxpOptions dxpOptions = new DitaDxpOptions();		
		handleCommonBosProcessorOptions(dxpOptions);

		String dxpFilepath = commandLine.getOptionValue(INPUT_OPTION_ONE_CHAR);
		File dxpFile = new File(dxpFilepath);
		checkExistsAndCanReadSystemExit(dxpFile);
		if (!dxpOptions.isQuiet())
			log.info("Processing DXP package \"" + dxpFile.getAbsolutePath() + "\"...");
		
		String outputDirpath = commandLine.getOptionValue(OUTPUT_OPTION_ONE_CHAR);
		File outputDir = new File(outputDirpath);
		if (outputDir.exists() && !outputDir.isDirectory()) {
			System.err.println("Output directory \"" + outputDirpath + "\" is not a directory.");
			System.exit(1);
		}
		
		outputDir.mkdirs();
		if (!outputDir.exists()) {
			System.err.println("Failed to create output directory \"" + outputDirpath + "\".");
			System.exit(1);
		}
		
		if (!outputDir.canWrite()) {
			System.err.println("Cannot write to output directory \"" + outputDirpath + "\".");
			System.exit(1);
		}
		
		
		String[] mapIds = commandLine.getOptionValues(MAPS_ID_OPTION_ONE_CHAR);
		if (mapIds != null && mapIds.length > 0) {
			for (String mapId : mapIds) {
				dxpOptions.addMapId(mapId);
			}
		}
		
		try {
			DitaDxpHelper.unpackDxpPackage(dxpFile, outputDir, dxpOptions, log);
		} catch (DitaDxpException e) {
			System.err.println("DITA DXP Error: " + e.getMessage());
		}

	}

	/**
	 * @return
	 */
	private static Options configureOptions() {
		Options options = configureOptionsBase();
			
		options.getOption(INPUT_OPTION_ONE_CHAR).setDescription("(Package file) DXP file to unpack.");
		options.getOption(INPUT_OPTION_ONE_CHAR).setLongOpt("dxpfile");
		options.getOption(OUTPUT_OPTION_ONE_CHAR).setDescription("(Output dir) Directory the DXP package is unpacked into.");
		
		Option opt = null;
		
		options.addOption(UNPACK_ALL_OPTION_ONE_CHAR, "unpackAll", false, "(Unpack all resources) When specified, indicates that all resources in the package should be unpacked.");
		opt = options.getOption(UNPACK_ALL_OPTION_ONE_CHAR);
		opt.setRequired(false);

		options.addOption(MAPS_ID_OPTION_ONE_CHAR, "mapids", true, "(Map IDs) Specifies the IDs (as defined in the DXP package manifest, of the maps to extract.");
		opt = options.getOption(MAPS_ID_OPTION_ONE_CHAR);
		opt.setRequired(false);
		opt.setArgs(Option.UNLIMITED_VALUES);

		return options;
	}


}

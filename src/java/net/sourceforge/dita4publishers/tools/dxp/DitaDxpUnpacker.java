/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.dxp;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.util.Date;
import java.util.HashMap;

import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorBase;
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
 * Command-line utility to unpack DITA Interchange Packages (DXP).
 * <p>A DITA Interchange Package is a Zip file containing some or all of the
 * dependencies used from a root map.
 * </p>
 */
public class DitaDxpUnpacker extends MapBosProcessorBase {
	
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
		
		String dxpFilepath = commandLine.getOptionValue(INPUT_OPTION_ONE_CHAR);
		File dxpFile = new File(dxpFilepath);
		checkExistsAndCanReadSystemExit(dxpFile);
		System.err.println("Processing DXP package \"" + dxpFile.getAbsolutePath() + "\"...");
		
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
		
		try {
			DitaDxpHelper.unpackDxpPackage(dxpFile, outputDir, new DitaDxpOptions());
		} catch (DitaDxpException e) {
			System.err.println("DITA DXP Error: " + e.getMessage());
		}

	}

	/**
	 * @return
	 */
	private static Options configureOptions() {
		Options options = configureOptionsBase();
			
		options.getOption(INPUT_OPTION_ONE_CHAR).setDescription("DXP file to unpack.");
		options.getOption(OUTPUT_OPTION_ONE_CHAR).setDescription("Directory the DXP package is unpacked into.");

		return options;
	}


}

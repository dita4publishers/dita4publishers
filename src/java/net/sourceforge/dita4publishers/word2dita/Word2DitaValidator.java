/**
 * 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.util.Date;

import net.sourceforge.dita4publishers.api.bos.BosMemberValidationException;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorBase;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorOptions;
import net.sourceforge.dita4publishers.util.DomException;
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
 *
 */
public class Word2DitaValidator extends MapBosProcessorBase {
	


	public static Log log = LogFactory.getLog(Word2DitaValidator.class);


	/**
	 * Path and filename of the Word document from which the map was generated.
	 */
	public static final String WORD_DOC_OPTION_ONE_CHAR = "d";

	/**
	 * @param cmdline
	 */
	public Word2DitaValidator(CommandLine cmdline) {
		this.commandLine = cmdline;
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
			formatter.printHelp(Word2DitaValidator.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		if (!cmdline.hasOption(INPUT_OPTION_ONE_CHAR) || !cmdline.hasOption(WORD_DOC_OPTION_ONE_CHAR)) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp(Word2DitaValidator.class.getSimpleName(), cmdlineOptions);
			System.exit(-1);
		}
		
		
		Word2DitaValidator app = new Word2DitaValidator(cmdline);
		try {
			app.run();
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}


	}

	/**
	 * 
	 */
	private void run() {
		String mapFilepath = commandLine.getOptionValue("i");
		File mapFile = new File(mapFilepath).getAbsoluteFile();
		checkExistsAndCanReadSystemExit(mapFile);
		
		Word2DitaValidatorOptions procOptions = new Word2DitaValidatorOptions();
		handleCommonBosProcessorOptions(procOptions);
		
		String originalWordFilePath = commandLine.getOptionValue(WORD_DOC_OPTION_ONE_CHAR);
		File originalWordFile = new File(originalWordFilePath);
		checkExistsAndCanReadSystemExit(originalWordFile);

		File outputWordFile = null; 
		String outputFilepath = null;
		if (commandLine.hasOption(OUTPUT_OPTION_ONE_CHAR)) {
			outputFilepath = commandLine.getOptionValue(OUTPUT_OPTION_ONE_CHAR);
			outputWordFile = new File(outputFilepath).getAbsoluteFile();
		} else {
			outputWordFile = originalWordFile;
		}
		checkCanWriteSystemExit(outputWordFile);

		procOptions.setOriginalWordFile(originalWordFile);
		procOptions.setOutputWordFile(outputWordFile);
		procOptions.setLog(log);
		
		BosConstructionOptions bosOptions = setupBosOptions(procOptions);
		
		URI rootDocUri = mapFile.toURI();
		try {
			Document rootMap = DomUtil.getDomForUri(rootDocUri, bosOptions);
			procOptions.setRootDocument(rootMap);
		} catch (Exception e) {
			System.err.println("Exception parsing input DITA document: " + e.getClass().getSimpleName() + " - " + e.getMessage());
			System.exit(-1);
		}


		validateMap(mapFile, procOptions, bosOptions);

	}

	/**
	 * @param mapFile
	 * @param procOptions
	 */
	public void validateMap(File mapFile, MapBosProcessorOptions procOptions, BosConstructionOptions bosOptions) {
		Document rootMap = null;
		
		try {
			Date startTime = TimingUtils.getNowTime();
			DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);
			if (!procOptions.isQuiet())
				System.err.println("Map BOS construction took " + TimingUtils.reportElapsedTime(startTime));

			// Do validation and comment writing here.
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Do final stuff here.
		}
	}

	/**
	 * @param outputWordFile
	 */
	public static void checkCanWriteSystemExit(File file) {
		try {
			checkCanWrite(file);
		} catch(Exception e) {
			System.err.println(e.getMessage());
			System.exit(-1);
		}
	}

	/**
	 * Throws a runtime exception if the file exists but is not writable, can't create the parent dirs,
	 * or the parent dir exists but is not writable.
	 * @param file
	 */
	private static void checkCanWrite(File file) {
		if (file.exists()) {
			if (!file.canWrite()) {
				throw new RuntimeException("File " + file.getAbsolutePath() + " exists but cannot be written to.");
			}
		} else {
			File parent = file.getParentFile();
			if (!parent.exists()) {
				if (!parent.mkdirs()) {
					throw new RuntimeException("Failed to created parent directories for file " + file.getAbsolutePath() + ".");
				}
			}
			if (parent.exists()) {
				if (!parent.canWrite()) {
					throw new RuntimeException("Cannot write to directory that will contain file " + file.getAbsolutePath() + ".");
				}
			} else {
				// Should never get here but you never know.
				throw new RuntimeException("Failed to created parent directories for file " + file.getAbsolutePath() + ".");
			}
		}
	}

	/**
	 * @return
	 */
	private static Options configureOptions() {
		Options options = configureOptionsBase();
		
		options.addOption(WORD_DOC_OPTION_ONE_CHAR, "docx", true, "(Original Word doc) The Word document from which the DITA map was generated.");
		Option opt = options.getOption(WORD_DOC_OPTION_ONE_CHAR);
		opt.setRequired(true);

		
		options.getOption(INPUT_OPTION_ONE_CHAR).setDescription("(Input map or topic) Root map or single topic to be validated.");
		options.getOption(OUTPUT_OPTION_ONE_CHAR).setDescription("(Annotated Word doc) Word document that will contain validation messages as comments." +
				" If not set, original Word doc will be updated with the messages.");
		options.getOption(OUTPUT_OPTION_ONE_CHAR).setRequired(false); // Will be same as input Word doc if not specified.

		return options;
	}

}

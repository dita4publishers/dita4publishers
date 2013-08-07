package net.sourceforge.dita4publishers.slideset;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmAtomicValue;

import org.apache.commons.cli.BasicParser;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.io.FilenameUtils;

/**
 * Command-line utility for generation PPTX files from resolved DITA maps.
 * The input to this process should be the result of e.g., the Open Toolkit's
 * map-pull preprocess.
 *
 */
public class DITA2PPTX {

    /**
     * @param args
     */
    public static
            void main(
                    String[] args) {

        Options options = new Options();
        Option option;

        option = new Option("i", true, 
                "(Required) The path and filename of the DITA map file to process.");
        option.setArgName("mapFilePath");
        options.addOption(option);

        option = new Option("b", true, 
                "(Required) The path and filename of the PPTX file to use as the basis for the generated presentation.");
        option.setArgName("basePPTXPath");
        options.addOption(option);

        option = new Option("o", true, 
                "(optional) The output file. If an extension is not specified, the extension will be '.pptx'. " +
                "If not specified, the input map filename is used for the output, with the extension '.pptx'.");
        option.setArgName("basePPTXPath");
        options.addOption(option);

        option = new Option("otdir", true, 
                "(optional) The directory containing the DITA Open Toolkit to use (e.g., c:\\DITA-OT)." +
                " If not specified, uses the environment variable DITA_HOME.");
        option.setArgName("otdir");
        options.addOption(option);

        CommandLineParser parser = new BasicParser();
        CommandLine cmd = null;
        try {
            cmd = parser.parse(options, args);
        } catch (ParseException e) {
            System.err.println(e.getClass().getSimpleName() + " processing command-line arguments: " + e.getMessage());
            System.exit(-1);
        }
        if (!cmd.hasOption("i") || !cmd.hasOption("b")) {
            HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp("DITA2PPTX", options);
            System.exit(-1);
        }
        String mapPath = cmd.getOptionValue("i");
        String basePPTXPath = cmd.getOptionValue("b");
        String resultPPTXPath = null;
        if (cmd.hasOption("o")) {
            resultPPTXPath = cmd.getOptionValue("o");            
        }
        String otPath = null;
        if (cmd.hasOption("otdir")) {
            otPath = cmd.getOptionValue("otdir");            
        }
        
        String ditaHomePath = otPath;
        if (otPath == null) {
            otPath = System.getenv("DITA_HOME");
            if (ditaHomePath == null || "".equals(ditaHomePath.trim())) {
                System.err.println("Environment variable DITA_HOME not set and -otdir parameter not specified, cannot continue.");
                System.exit(-1);
            }
            
        }
        
        // Now validate the arguments:
        String userDirStr = System.getProperty("user.dir");
        File userDir = new File(userDirStr);

        File mapFile = new File(mapPath);
        if (!mapFile.isAbsolute()) {
            mapFile = new File(userDir, mapFile.getPath());
        }
        if (!mapFile.exists()) {
            System.err.println("Cannot find map file \"" + mapFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }
        if (!mapFile.canRead()) {
            System.err.println("Cannot read map file \"" + mapFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }
        if (mapFile.isDirectory()) {
            System.err.println("Map file \"" + mapFile.getAbsolutePath() + "\" is a directory");
            System.exit(-1);
        }

        File basePPTXFile = new File(basePPTXPath);
        if (!basePPTXFile.isAbsolute()) {
            basePPTXFile = new File(userDir, basePPTXFile.getPath());
        }
        if (!basePPTXFile.exists()) {
            System.err.println("Cannot find base PPTX file \"" + basePPTXFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }
        if (!basePPTXFile.canRead()) {
            System.err.println("Cannot read base PPTX file \"" + basePPTXFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }
        if (basePPTXFile.isDirectory()) {
            System.err.println("Base PPTX file \"" + mapFile.getAbsolutePath() + "\" is a directory");
            System.exit(-1);
        }
        
        File resultPPTXFile = null;
        if (resultPPTXPath == null) {
            File resultPPTXDir = mapFile.getParentFile();
            resultPPTXFile = 
                    new File(
                            resultPPTXDir, 
                            FilenameUtils.getBaseName(mapFile.getName()) + ".pptx");
        } else {
            resultPPTXFile = new File(resultPPTXPath);
            if (!resultPPTXFile.isAbsolute()) {
                resultPPTXFile = new File(userDir, resultPPTXFile.getPath());
            }
            resultPPTXFile.mkdirs();
            if (resultPPTXFile.isDirectory()) {
                resultPPTXFile = 
                        new File(
                                resultPPTXFile, 
                                FilenameUtils.getBaseName(mapFile.getName()) + ".pptx");                
            }
        }
        if (!basePPTXFile.canWrite()) {
            System.err.println("Do not have write permission for base PPTX file \"" + basePPTXFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }
        
        basePPTXFile.getParentFile().mkdirs();
        if (!basePPTXFile.getParentFile().exists()) {
            System.err.println("Was unable to create output directory \"" + basePPTXFile.getParent() + "\"");
            System.exit(-1);
        }
        
        File ditaHomeDir = new File(ditaHomePath);
        if (!ditaHomeDir.exists()) {
            System.err.println("DITA Open Toolkit directory (from DITA_HOME environment variable) \"" + ditaHomeDir.getAbsolutePath() + "\" does not exist.");
            System.exit(-1);
        }

        // Set up the default transform:
        // FIXME: Allow this to be set on the command line
        File ditaToSlideSetXsltFile = 
                new File(
                  new File(
                    new File(
                      new File(ditaHomeDir, "plugins"),  
                      "net.sourceforge.dita4publishers.slideset"),
                    "xsl"), 
                 "map2slidesetImpl.xsl");

        if (!ditaToSlideSetXsltFile.exists()) {
            System.err.println("Cannot find map-to-slideset XSLT file \"" + ditaToSlideSetXsltFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }
        if (!ditaToSlideSetXsltFile.canRead()) {
            System.err.println("Cannot read map-to-slideset XSLT file \"" + ditaToSlideSetXsltFile.getAbsolutePath() + "\"");
            System.exit(-1);
        }

        
        System.out.println("+ [INFO] DITA2PPTX: Processing map:       \"" + mapFile.getAbsolutePath() + "\".");
        System.out.println("+ [INFO] DITA2PPTX: Using base PPTX file: \"" + basePPTXFile.getAbsolutePath() + "\".");
        System.out.println("+ [INFO] DITA2PPTX: To result PPTX file:  \"" + resultPPTXFile.getAbsolutePath() + "\".");
        System.out.println("+ [INFO] DITA2PPTX: Using Open Toolkit:   \"" + ditaHomePath + "\".");
        System.out.println("+ [INFO] DITA2PPTX: Using XSLT transform: \"" + ditaToSlideSetXsltFile.getAbsolutePath() + "\".");
        
        try {
            doPPTXGeneration(
                    mapFile, 
                    basePPTXFile, 
                    resultPPTXFile, 
                    ditaToSlideSetXsltFile,
                    ditaHomeDir);
        } catch (Exception e) {
            System.err.println(e.getClass().getSimpleName() + " generating PPTX: " + e.getMessage());
            e.printStackTrace(System.err);
            System.exit(-1);
        }

    }

    private static
            void
            doPPTXGeneration(
                    File mapFile,
                    File basePPTXFile,
                    File resultPPTXFile,
                    File ditaToSlideSetXsltFile,
                    File ditaOtDir) throws Exception {
        
        Source mapSource = new StreamSource(mapFile);
        InputStream basePresentationStream = new FileInputStream(basePPTXFile);
        Source xsltSource = new StreamSource(ditaToSlideSetXsltFile);
        
        
        SlideSetTransformerBase transformer = 
                new PPTXSlideSetTransformer(
                        mapSource, 
                        basePresentationStream);
        transformer.setResultStream(new FileOutputStream(resultPPTXFile));
        Map<QName, XdmAtomicValue> params = new HashMap<QName, XdmAtomicValue>();
        params.put(
                new QName("outdir"), 
                new XdmAtomicValue(resultPPTXFile.getParentFile().getAbsolutePath()));

        transformer.setSlideSetTransformSource(xsltSource, params);
        String masterDitaCatalogPath = ((new File(ditaOtDir, "catalog-dita.xml")).getAbsolutePath());
        String[] catalogs = {masterDitaCatalogPath};
        transformer.setCatalogs(catalogs);
        transformer.transform();
        
    }

}

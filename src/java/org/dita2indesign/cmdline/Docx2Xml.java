/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.cmdline;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URL;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Command-line utility for transforming DOCX files into DITA-based XML
 * using XSLT transforms.
 */
public class Docx2Xml {
	
	private static Log log = LogFactory.getLog(Docx2Xml.class);


	/**
	 *
	 */
	public class Options {

		private String xslt;
		private Object styleMapUri;

		/**
		 * @param xsltUri
		 */
		public void setXslt(String xsltUri) {
			log.debug("Setting XSLT to \"" + xsltUri + "\"");
			this.xslt = xsltUri;
			
		}

		/**
		 * @return the xslt
		 */
		public String getXslt() {
			return this.xslt;
		}

		/**
		 * @return
		 */
		public Object getStyleMapUri() {
			return this.styleMapUri;
		}

		/**
		 * @param styleMapUri the styleMapUri to set
		 */
		public void setStyleMapUri(Object styleMapUri) {
			this.styleMapUri = styleMapUri;
		}

	}

	/**
	 * 
	 */
	private static void printUsage() {
		String usage = "Usage:\n\n" +
						"\t" + Docx2Xml.class.getSimpleName() + " " +
						" docxFile " +
						" {resultXmlFile}" +
						"\n\n" +
						"Where:\n\n" +
						" docxFile: The Word DOCX file to be transformed.\n" +
						" resultXmlFile: The path, and optionally, filename to use for the output XML file. By default, uses the DOCX filename.\n" +
						"\n" +
						"NOTE: Existing result files are silently overwritten.";
			
		System.err.println(usage);
		
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		if (args.length < 1) {
			printUsage();
			System.exit(-1);
		}
		
		String docxFilename = args[0];		
		File docxFile = new File(docxFilename);
		
		checkExistsAndCanReadSystemExit(docxFile);
		
		File resultDir = null;
		File resultFile = null;
		String resultFilename = null;
		String namePart = docxFile.getName();
		namePart = namePart.substring(0, namePart.lastIndexOf("."));
		resultFilename = namePart + ".xml";
		
		if (args.length >= 2) {
			String temp = args[1];
			File tempFile = new File(temp);
			checkExistsAndCanReadSystemExit(tempFile);
			if (tempFile.isDirectory()) {
				resultDir = tempFile;
				if (!resultDir.canWrite()) {
					System.err.println("Output directory \"" + resultDir.getAbsolutePath() + "\" is not writable");
					System.exit(-1);
				}
				resultFile = new File(resultDir, resultFilename);
			} else {
				resultFile = tempFile;
			}
		} else {
			resultFile = new File(docxFile.getParentFile(), resultFilename);
		}
		
		Docx2Xml app = new Docx2Xml();
		
		Options options = app.new Options();
		options.setXslt("file:///Users/ekimber/workspace/astd/src/xslt/word2xml/docx2article.xsl");
		options.setStyleMapUri("file:///Users/ekimber/workspace/astd/src/xslt/word2xml/article-style2tagmap.xml");
		
		try {
			app.generateXml(docxFile, resultFile, options);
			System.out.println("XML generation complete, result is in \"" + resultFile.getAbsolutePath() + "\"");
		} catch (Exception e) {
			System.err.println("XML generation failed: " + e.getClass().getSimpleName() + ": " + e.getMessage());
		}
		

	}

	/**
	 * @param docxFile
	 * @param resultFile
	 * @param options 
	 * @throws Exception 
	 */
	private void generateXml(File docxFile, File resultFile, Options options) throws Exception {
		File tempDir = getTempDir(true); 
		
//		log.debug("Unzipping docxfile to \"" + tempDir.getAbsolutePath() + "\"...");
		unzip(docxFile, tempDir);

		File documentXml = new File(new File(tempDir, "word"), "document.xml");
		if (!documentXml.exists()) {
			throw new RuntimeException("Failed to find document.xml within DOCX package. This should not happen.");
		}
		
		URL xsltUrl = new URL(options.getXslt());
//		log.debug("xsltUrl=" + xsltUrl.toExternalForm());
		
	    TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl(); // TransformerFactory.newInstance();
	    
	    
        Source style = new StreamSource(xsltUrl.openStream());
        style.setSystemId(xsltUrl.toExternalForm());

        Transformer trans = factory.newTransformer(style);
        
        trans.setParameter("styleMapUri", options.getStyleMapUri());
//        log.debug("Got a transformer.:");
        
        Source xmlSource = new StreamSource(new FileInputStream(documentXml));
        xmlSource.setSystemId(documentXml.getAbsolutePath());
//        log.debug("xmlSource.systemId=\"" + xmlSource.getSystemId() + "\"");
        Result result = new StreamResult(new FileOutputStream(resultFile));
        log.debug("Calling transform()...");
		trans.transform(xmlSource, result);
		log.debug("Transformation complete.");
		FileUtils.deleteDirectory(tempDir);
	}
	
	/**
	 * Gets a temporary directory.
	 * @param deleteOnExit If set to true, directory will be deleted on exit.
	 * @return
	 * @throws Exception 
	 */
	protected File getTempDir(boolean deleteOnExit) throws Exception {
		File tempFile = File.createTempFile(this.getClass().getSimpleName() + "_", "trash");
		File tempDir = new File(tempFile.getAbsolutePath() + "_dir");
		tempDir.mkdirs();
		tempFile.delete();
		if (deleteOnExit) tempDir.deleteOnExit();	
		return tempDir;
	}



	private static void checkExistsAndCanReadSystemExit(File docxFile) {
		try {
			checkExistsAndCanRead(docxFile);
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

	/**
	* @param zipInFile
	*            Zip file to be unzipped
	* @param outputDir
	*            Directory to which the zipped files will be unpacked.
	* @throws Exception 
	* @throws ZipException 
	*/
	public static void unzip(File zipInFile, File outputDir) throws Exception {
	

		Enumeration<? extends ZipEntry> entries;
		ZipFile zipFile = new ZipFile(zipInFile);
		ZipInputStream zipInputStream = new ZipInputStream(new FileInputStream(zipInFile));
		ZipEntry entry = (ZipEntry) zipInputStream.getNextEntry();
		
		File curOutDir = outputDir;
		while (entry != null) {
		
			if (entry.isDirectory()) {
				// This is not robust, just for demonstration purposes.
				curOutDir = new File(curOutDir, entry.getName());
				curOutDir.mkdirs();
				continue;
			}
			
			File outFile = new File(curOutDir, entry.getName());
			File tempDir = outFile.getParentFile();
			if (!tempDir.exists()) tempDir.mkdirs();
			outFile.createNewFile();
			BufferedOutputStream outstream = new BufferedOutputStream(new FileOutputStream(outFile));

			int n;
		 	byte[] buf = new byte[1024];
			while ((n = zipInputStream.read(buf, 0, 1024)) > -1)
                outstream.write(buf, 0, n);
			outstream.flush();
			outstream.close();
			zipInputStream.closeEntry();
			entry = zipInputStream.getNextEntry();
		}
		zipInputStream.close();
			
		zipFile.close();
	}
	


}

package org.dita4publishers.rsuite.workflow.actions.beans;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;

import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.rsuite.api.xml.LoggingSaxonMessageListener;

public class Docx2XmlBean extends TransformSupportBean {

	
	private String styleMapUri;
	private String rootMapUrl;
	public Docx2XmlBean(WorkflowExecutionContext context, String xsltUriString, String styleMapUriString, String rootMapUrl) throws RSuiteException{
		super(context, xsltUriString);
		
		this.styleMapUri = styleMapUriString;		
		this.rootMapUrl = rootMapUrl;
	}


	private void unzip(File zipInFile, File outputDir) throws IOException{
		
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
	
	/**
	 * Returns the SaxonLogger used to capture the transformation log. From the
	 * logger you can get the log string.
	 * @param docxFile
	 * @param resultFile
	 * @param logger 
	 * @param userParams Optional parameters to pass to the style sheet.
	 * @return
	 * @throws Exception
	 */
	public void generateXmlS9Api(File docxFile, File resultFile, LoggingSaxonMessageListener logger, Map<String, String> userParams) throws RSuiteException {
		Log wfLog = context.getWorkflowLog();
		
		File tempDir = null;
		try {
			tempDir = getTempDir("generateXmlS9Api", false);
		} catch (Exception e) {
			String msg = "Failed to get a temporary directory: " + e.getMessage(); 
			logAndThrowRSuiteException(wfLog, e, msg);
		} 
		
		try {
			unzip(docxFile, tempDir);
		} catch (IOException e) {
			String msg = "Failed to unzip the DOCX file" + docxFile.getAbsolutePath() + "\": " + e.getMessage();			
			logAndThrowRSuiteException(wfLog, e, msg);
		}

		File documentXml = new File(new File(tempDir, "word"), "document.xml");
		if (!documentXml.exists()) {
			String msg = "Failed to find document.xml within DOCX package. This should not happen.";
			logAndThrowRSuiteException(wfLog, null, msg);
		}
		
		Map<String, String> params = new HashMap<String, String>();
		File resultDir = resultFile.getParentFile();
		File topicsDir = new File(resultDir, "topics");
		topicsDir.mkdirs();

		// Copy the media folder from the DocX to the generated topics directory
		File mediaSrcDir = new File(new File(tempDir, "word"), "media");
		if (mediaSrcDir.exists()) {
			// FIXME: Parameterize this directory
			File mediaTargetDir = new File(topicsDir, "media");
			try {
				FileUtils.copyDirectory(mediaSrcDir, mediaTargetDir);
			} catch (IOException e) {
				String msg = "Failed to copy media subfolder from DOCX file" + docxFile.getAbsolutePath() + "\": " + e.getMessage();			
				logAndThrowRSuiteException(wfLog, e, msg);
			}
			try {
				params.put("mediaDirUri", mediaTargetDir.toURL().toExternalForm());
			} catch (MalformedURLException e) {
				throw new RuntimeException("Unexpected MalformedURLException:  " + e.getMessage());
			}
		}
		

		params.put("styleMapUri", styleMapUri);
		try {
			params.put("outputDir", resultDir.toURL().toExternalForm());
		} catch (MalformedURLException e) {
			throw new RuntimeException("Unexpected MalformedURLException:  " + e.getMessage());
		}
		params.put("rootMapUrl", rootMapUrl);
		if (userParams != null)
			params.putAll(userParams);
		
		applyTransform(documentXml, resultFile, params, logger, wfLog, tempDir);
   }


}

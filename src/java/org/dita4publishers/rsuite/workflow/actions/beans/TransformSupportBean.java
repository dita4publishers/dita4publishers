/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions.beans;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Map;

import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXSource;

import net.sf.saxon.s9api.Destination;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XsltTransformer;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import com.reallysi.rsuite.api.ManagedObject;
import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.rsuite.api.workflow.WorkflowJobContext;
import com.reallysi.rsuite.api.xml.LoggingSaxonMessageListener;

/**
 *
 */
public class TransformSupportBean {

	protected URI xsltUri;
	protected WorkflowExecutionContext context;

	/**
	 * @param context
	 * @throws RSuiteException 
	 * 
	 */
	public TransformSupportBean(WorkflowExecutionContext context, String xsltUrlString) throws RSuiteException {
		this.context = context;
		try {
			xsltUri = new URI(xsltUrlString);
		} catch (URISyntaxException e) {
			String msg = "Failed to construct URI from URI string\"" + xsltUrlString + "\": " + e.getMessage();			
			logAndThrowRSuiteException(context.getWorkflowLog(), e, msg);
		}
		
	}

	public void logAndThrowRSuiteException(Log wfLog, Exception e,
			String msg) throws RSuiteException {
		wfLog.error(msg);
		throw new RSuiteException(0, msg, e);
	}

	/**
	 * @param xsltUrl 
	 * @param doc
	 * @param resultFile
	 * @param params
	 * @param logger
	 * @param wfLog
	 * @param tempDir
	 */
	public void applyTransform(ManagedObject mo, File resultFile, Map<String, String> params,
			LoggingSaxonMessageListener logger, Log wfLog, File tempDir) throws RSuiteException {
		Element element = mo.getElement();
		if (element == null) {
			throw new RSuiteException(0, "Managed object " + mo.getDisplayName() + "[" + mo.getId() + "] returned null for getElement() method.");
		}
		Document doc = element.getOwnerDocument();
		Source source = new DOMSource(doc);
		Serializer result = new Serializer();
		result.setOutputFile(resultFile);
		applyTransform(source, result, params, logger, wfLog, tempDir);
	}

	/**
	 * @param xsltUrl 
	 * @param doc
	 * @param resultFile
	 * @param params
	 * @param logger
	 * @param wfLog
	 * @param tempDir
	 */
	public void applyTransform(Document doc, File resultFile, Map<String, String> params,
			LoggingSaxonMessageListener logger, Log wfLog, File tempDir) throws RSuiteException {
		Source source = new DOMSource(doc);
		Serializer result = new Serializer();
		result.setOutputFile(resultFile);
		applyTransform(source, result, params, logger, wfLog, tempDir);
	}

	public void applyTransform(File inputXmlFile, File resultFile, Map<String, String> params,
			LoggingSaxonMessageListener logger, Log log, File tempDir)  throws RSuiteException {
	    SAXSource saxSource = null;
	    try {
			InputSource inSource = new InputSource(new FileInputStream(inputXmlFile));
			// FIXME: Set validation to true to force a failure for testing the logging:
			XMLReader reader = context.getXmlApiManager().getLoggingXMLReader(log, true);
			
			 saxSource = new SAXSource(reader, inSource);
		} catch (FileNotFoundException e) {
			String msg = "File not found exception: " + e.getMessage();			
			logAndThrowRSuiteException(log, e, msg);
		}
	    saxSource.setSystemId(inputXmlFile.getAbsolutePath());

	    Serializer result = new Serializer();
		result.setOutputFile(resultFile);
		
		applyTransform(saxSource, result, params, logger, log, tempDir);
		
	}


	public void applyTransform(Source xmlSource, Destination result, Map<String, String> params,
			LoggingSaxonMessageListener logger, Log wfLog, File tempDir) throws RSuiteException {
				
	    XsltTransformer trans = context.getXmlApiManager().getSaxonXsltTransformer(xsltUri, logger);
	    
	    for (String name : params.keySet()) {
	    	String value = params.get(name);
	    	wfLog.info("Setting XSLT parameter \"" + name + "\" to \"" + value + "\"");
	        trans.setParameter(new QName(name), new XdmAtomicValue(value));
	    }
	
	    try {
			trans.setSource(xmlSource);
		} catch (SaxonApiException e) {
			String msg = "Exception setting transform source: " + e.getMessage();			
			logAndThrowRSuiteException(wfLog, e, msg);
		}
	    trans.setDestination(result);
	
	    wfLog.info("Applying XSLT transform \"" + xsltUri.toString() + "\" to input source " + xmlSource.getSystemId());
	    try {
			trans.transform();
		} catch (SaxonApiException e) {
			String msg = "Exception from XSLT transform: " + e.getMessage();
			logAndThrowRSuiteException(wfLog, e, msg);
		}
		wfLog.info("Transformation complete.");
		
//				try {
//					FileUtils.deleteDirectory(tempDir);
//				} catch (IOException e) {
//					wfLog.warn("Failed to delete temporary directory: " + e.getMessage());
//				}
	}

	/**
	 * Gets a temporary directory.
	 * @param deleteOnExit If set to true, directory will be deleted on exit.
	 * @return
	 * @throws Exception 
	 */
	protected static File getTempDir(String prefix, boolean deleteOnExit) throws Exception {
		File tempFile = File.createTempFile(prefix, "trash");
		File tempDir = new File(tempFile.getAbsolutePath() + "_dir");
		tempDir.mkdirs();
		tempFile.delete();
		if (deleteOnExit) tempDir.deleteOnExit();	
		return tempDir;
	}
	
	public File getWorkingDir()
	throws Exception {
		return getWorkingDir(true);
	}
	
	/**
	 * Returns the appropriate working directory, either the working directory
	 * for the workflow job context or a random temporary directory if there
	 * is no workflow job context.
	 * @param deleteOnExit
	 * @return
	 * @throws Exception
	 */
	public File getWorkingDir(boolean deleteOnExit)
	throws Exception {
		WorkflowJobContext wjc = context.getWorkflowJobContext();
		
		File workDir = null;
		if (wjc == null) {
			workDir = getTempDir("workflowProcess_" + context.getProcessInstanceId() + "_", deleteOnExit);
		} else {
			workDir = new File(wjc.getWorkFolderPath());
			if (!workDir.exists())
				workDir.mkdirs();
		}
		return workDir;
	}
		

}
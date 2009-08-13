/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.commons.logging.Log;

import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.BusinessRuleException;
import com.reallysi.rsuite.api.workflow.FileWorkflowObject;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.rsuite.api.xml.DitaOpenToolkit;

/**
 * Sets up all the DITA Open Toolkit parameters needed to run Toolkit processes.
 */
public class DitaOtXhtmlTaskRunningActionHandler extends AntTaskRunningActionHandlerBase {

	/**
	 * The name of the configured Open Toolkit to use. Default is "default".
	 * Open Toolkits are configured in the DITA Open Toolkit properties file
	 * in the RSuite conf/ directory.
	 * <p>
	 * The maps to be processed are listed in the workflow variable "exportedMapFiles", 
	 * which is a list of WorkflowFileObjects, one for each map.
	 * </p>
	 */
	public static final String OPEN_TOOLKIT_NAME_PARAM = "openToolkitName";

	/**
	 * The path to which the generated output is put.
	 */
	public static final String OUTPUT_PATH_PARAM = "outputPath";

	public static final String MAP_FILES_VARNAME = "mapFiles";

	/**
	 * transtype parameter, e.g. "xhtml", "pdf", "scorm", etc.
	 */
	public static final String TRANSTYPE_PARAM = "transtype";
	private static final long serialVersionUID = 1L;

	
	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.workflow.AbstractBaseNonLeavingActionHandler#execute(com.reallysi.rsuite.api.workflow.WorkflowExecutionContext)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void execute(WorkflowExecutionContext context) throws Exception {
		Log wfLog = context.getWorkflowLog();
		
		checkParamsNotEmptyOrNull(OUTPUT_PATH_PARAM);
		
		String outputPath = getParameter(OUTPUT_PATH_PARAM);
//		checkParamsNotEmptyOrNull(TRANSTYPE_PARAM);
//		
		String transtype = "xhtml";
		
		String otName = getParameterWithDefault(OPEN_TOOLKIT_NAME_PARAM,"default");
		wfLog.info("Using Open Toolkit named \"" + otName + "\"");
		DitaOpenToolkit toolkit = context.getXmlApiManager().getDitaOpenToolkitManager().getToolkit(otName);
		if (toolkit == null) {
			throw new RSuiteException(0, "No DITA Open Toolkit named \"" + otName + "\" provided by Open Toolkit Manager. Cannot continue.");
		}
		
		File buildFile;
		try {
			buildFile = toolkit.getBuildFile();
		} catch (Exception e) {
			String msg = "Failed to get build file for Open Toolkit \"" + otName + "\". Make sure the Toolkit configuration is correct.";
			throw new RSuiteException(0, msg, e);
		}
		
		wfLog.info("Got a build file for the Toolkit");
		
		
		Properties props = setBaseTaskProperties(context, transtype, toolkit);

		Object mapFilesObj = context.getVariableAsObject(MAP_FILES_VARNAME);
		if (mapFilesObj == null) {
			throw new BusinessRuleException("Variable \"" + MAP_FILES_VARNAME + "\" returned a null value. It should be set to the set of map files to process.");
		}
		
		ArrayList<FileWorkflowObject> mapFiles = null;
		try {
			mapFiles = (ArrayList<FileWorkflowObject>)mapFilesObj;
		} catch (ClassCastException e) {
			throw new RSuiteException(0, "Expected variable \"" + MAP_FILES_VARNAME + "\" to be of type ArrayList<FileWorkflowObject>, got " + mapFiles.getClass().getCanonicalName());
		}
		
		for (FileWorkflowObject fileObj : mapFiles) {
			String resolvedOutputPath  = resolveVariablesAndExpressions(context, outputPath, fileObj.getName());

			String mapFilePath = fileObj.getFile().getAbsolutePath();
			wfLog.info("Processing map file \"" + mapFilePath + "\"");
			
			props.setProperty("args.input", mapFilePath); // The map or topic document to process
			props.setProperty("output.dir", resolvedOutputPath);
			props.setProperty("basedir.dir", fileObj.getFile().getParent()); // Base directory containing the map to be processed.

			String reportId = "dita2" + transtype + "_mo_" + fileObj.getFile().getName() + "_" + context.getProcessInstanceId() + "_" + getNowString();

			setupAndRunAntProject(context, wfLog, buildFile, reportId, props);
					
		}

		
    }

	private Properties setBaseTaskProperties(WorkflowExecutionContext context,
			String transtype, DitaOpenToolkit toolkit) throws IOException {
		Properties props = new Properties();
		
		File tempDir = new File(File.createTempFile("dita-ot-xhtml", "").getParentFile(), context.getProcessInstanceId());
		tempDir.mkdirs();
//		tempDir.deleteOnExit();
		File logDir = new File(File.createTempFile("dita-ot-xhtml_log", "").getParentFile(), context.getProcessInstanceId());
		
		props.setProperty("transtype", transtype);
		props.setProperty("dita.temp.dir", tempDir.getAbsolutePath()); 
		props.setProperty("args.outext", "html");
		props.setProperty("args.xhtml.toc", "index");
		props.setProperty("dita.dir", toolkit.getDir().getAbsolutePath());
//		props.setProperty("outer.control", "");
//		props.setProperty("generate.copy.outer", "");
//		props.setProperty("args.copycss", "");
//		props.setProperty("args.css", "");
//		props.setProperty("args.cssroot", "");
//		props.setProperty("args.csspath", "");
//		props.setProperty("args.hdf", "");
//		props.setProperty("args.ftr", "");
//		props.setProperty("args.hdr", "");
		props.setProperty("args.logdir", logDir.getAbsolutePath());
		return props;
	}

	public void setTranstype(String transtype) {
		this.setParameter(TRANSTYPE_PARAM, transtype);
	}
    
	public void setOutputPath(String outputPath) {
		this.setParameter(OUTPUT_PATH_PARAM, outputPath);
	}
	
	public void setOpenToolkitName(String openToolkitName) {
		this.setParameter(OPEN_TOOLKIT_NAME_PARAM, openToolkitName);
	}
}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.AbstractBaseActionHandler;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.rsuite.api.workflow.WorkflowJobContext;

/**
 *
 */
@SuppressWarnings("serial")
public abstract class Dita4PublishersActionHandlerBase extends
		AbstractBaseActionHandler {

	/**
	 * Variable to hold exception message for use in task descriptions and elsewhere.
	 */
	public static final String EXCEPTION_MESSAGE_VAR = "exceptionMessage";
	public static final String DATE_FORMAT_STRING = "yyyyMMdd-HHmmss";
	public static final DateFormat DATE_FORMAT = new SimpleDateFormat(DATE_FORMAT_STRING);

	/**
	 * Gets a temporary directory.
	 * @param deleteOnExit If set to true, directory will be deleted on exit.
	 * @return
	 * @throws Exception 
	 */
	protected static File getTempDir(String prefix, boolean deleteOnExit)
			throws Exception {
				File tempFile = File.createTempFile(prefix, "trash");
				File tempDir = new File(tempFile.getAbsolutePath() + "_dir");
				tempDir.mkdirs();
				tempFile.delete();
				if (deleteOnExit) tempDir.deleteOnExit();	
				return tempDir;
			}

	public static String getNowString() {
		String timeStr = DATE_FORMAT.format(new Date());
		return timeStr;
	}

	protected void reportAndThrowRSuiteException(WorkflowExecutionContext context, String msg)
			throws RSuiteException {
				context.setVariable(EXCEPTION_MESSAGE_VAR, msg);
				String label = resolveVariables(context, getParameterWithDefault(COMMENT_STREAM_MESSAGE_LABEL_PARAM, "RSuite"));
				createWorkflowComment(context, label, DEFAULT_WORKFLOW_COMMENT_STREAM_NAME, "Error: " + msg);
				throw new RSuiteException(0, msg);
			}

	/**
	 * Returns the appropriate working directory, either the working directory
	 * for the workflow job context or a random temporary directory if there
	 * is no workflow job context.
	 * @param deleteOnExit
	 * @return
	 * @throws Exception
	 */
	public File getWorkingDir(WorkflowExecutionContext context, boolean deleteOnExit) throws Exception {
		WorkflowJobContext wjc = context.getWorkflowJobContext();
		
		File workDir = null;
		if (wjc == null) {
			workDir = getTempDir("workflowProcess_" + context.getProcessInstanceId() + "_at_", deleteOnExit);
		} else {
			workDir = new File(wjc.getWorkFolderPath());
			if (!workDir.exists())
				workDir.mkdirs();
		}
		return workDir;
	}

	
	/**
	 * 
	 */
	public Dita4PublishersActionHandlerBase() {
		super();
	}

}
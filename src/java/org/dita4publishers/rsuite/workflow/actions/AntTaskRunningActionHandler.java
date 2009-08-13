/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.io.File;
import java.util.Properties;

import org.apache.commons.logging.Log;

import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;

/**
 *
 */
public class AntTaskRunningActionHandler extends AntTaskRunningActionHandlerBase {

	private static final long serialVersionUID = 1L;

	
	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.workflow.AbstractBaseNonLeavingActionHandler#execute(com.reallysi.rsuite.api.workflow.WorkflowExecutionContext)
	 */
	@Override
	public void execute(WorkflowExecutionContext context) throws Exception {
		Log wfLog = context.getWorkflowLog();
		File buildFile = getBuildFile(context, wfLog);		
	
		this.checkParamsNotEmptyOrNull(BUILD_FILE_PATH_PARAM);
		String buildTarget = getParameter(BUILD_TARGET_PARAM);
		buildTarget = resolveVariablesAndExpressions(context, buildTarget);
		
		String buildProperties = getParameter(BUILD_PROPERTIES_PARAM);
		buildProperties = resolveVariablesAndExpressions(context, buildProperties);

		String reportId = "ant-task-" + context.getProcessInstanceId() + "-" + getNowString() + ".log";

		// Set up the Ant project then run it:
		
		Properties props = new Properties();
		
		props = parseBuildPropertiesString(wfLog, buildProperties);

		setupAndRunAntProject(context, wfLog, buildFile, reportId, props);
    }


    
}

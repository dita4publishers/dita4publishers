/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package com.reallysi.rsuite.system.workflow.actions;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.dita4publishers.rsuite.workflow.actions.Dita4PublishersActionHandlerBase;

import com.reallysi.rsuite.api.ManagedObject;
import com.reallysi.rsuite.api.workflow.MoListWorkflowObject;
import com.reallysi.rsuite.api.workflow.MoWorkflowObject;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;

/**
 * Capture basic info about the first or only MO in the workflow
 * into workflow variables so they can be used, e.g., in
 * task details. Intended to be used in workflows started
 * from context menus.
 */
@SuppressWarnings("serial")
public class SetVariablesFromMoDetails extends
		Dita4PublishersActionHandlerBase {

	/**
	 * 
	 */
	public static final String MO_BASE_NAME_VARNAME = "moBaseName";
	/**
	 * 
	 */
	public static final String MO_CONTENT_TYPE_VARNAME = "moContentType";
	/**
	 * 
	 */
	public static final String MO_ALIAS_VARNAME = "moAlias";
	/**
	 * 
	 */
	public static final String MO_DISPLAY_NAME_VARNAME = "moDisplayName";

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.workflow.AbstractBaseNonLeavingActionHandler#execute(com.reallysi.rsuite.api.workflow.WorkflowExecutionContext)
	 */
	@Override
	public void execute(WorkflowExecutionContext context) throws Exception {
		Log wfLog = context.getWorkflowLog();
		MoListWorkflowObject moList = context.getMoListWorkflowObject();
		if (moList == null || moList.isEmpty()) {
			String msg = "No managed objects in the workflow context. Nothing to do";
			reportAndThrowRSuiteException(context, msg);
		} 
		MoWorkflowObject moObject = moList.getMoList().get(0); // First item in list should be course script MO.
		ManagedObject mo = context.getManagedObjectService().getManagedObject(getSystemUser(), moObject.getMoid());

		context.setVariable(MO_DISPLAY_NAME_VARNAME, mo.getDisplayName());
		wfLog.info("Set " + MO_DISPLAY_NAME_VARNAME + " to \"" + context.getVariable(MO_DISPLAY_NAME_VARNAME) + "\"");
		
		String[] aliases = mo.getAliases();
		if (aliases != null && aliases.length > 0) {
			context.setVariable(MO_ALIAS_VARNAME, aliases[0]);
			wfLog.info("Set " + MO_ALIAS_VARNAME + " to \"" + context.getVariable(MO_ALIAS_VARNAME) + "\"");
			
			// Assume first alias is a filename, for now:
			String fileName = aliases[0]; 
			String baseName = FilenameUtils.getBaseName(fileName);
			context.setVariable(MO_BASE_NAME_VARNAME, baseName);
			wfLog.info("Set " + MO_BASE_NAME_VARNAME + " to \"" + context.getVariable(MO_BASE_NAME_VARNAME) + "\"");
			
		}
		
		if (mo.isNonXml()) {
			String fileName = mo.getDisplayName(); // For non-XML MOs, display name is the original file name
			String baseName = FilenameUtils.getBaseName(fileName);
			context.setVariable(MO_BASE_NAME_VARNAME, baseName);
			wfLog.info("Set " + MO_BASE_NAME_VARNAME + " to \"" + context.getVariable(MO_BASE_NAME_VARNAME) + "\"");

			context.setVariable(MO_CONTENT_TYPE_VARNAME, mo.getContentType());
			wfLog.info("Set " + MO_CONTENT_TYPE_VARNAME + " to \"" + context.getVariable(MO_CONTENT_TYPE_VARNAME) + "\"");
		}
		
	}


}
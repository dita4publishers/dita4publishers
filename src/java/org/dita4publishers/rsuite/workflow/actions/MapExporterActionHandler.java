/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.io.File;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.w3c.dom.Element;

import com.reallysi.rsuite.api.ManagedObject;
import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.AbstractBaseActionHandler;
import com.reallysi.rsuite.api.workflow.BusinessRuleException;
import com.reallysi.rsuite.api.workflow.FileWorkflowObject;
import com.reallysi.rsuite.api.workflow.MoListWorkflowObject;
import com.reallysi.rsuite.api.workflow.MoWorkflowObject;
import com.reallysi.rsuite.api.workflow.ProcessedWorkflowObject;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.rsuite.service.ManagedObjectService;
import com.reallysi.tools.dita.BosVisitor;
import com.reallysi.tools.dita.BoundedObjectSet;
import com.reallysi.tools.dita.DitaUtil;
import com.reallysi.tools.dita.ExportingBosVisitor;
import com.reallysi.tools.dita.RSuiteDitaHelper;
import com.reallysi.tools.dita.TreeGeneratingOutputFilenameSettingBosVisitor;

/**
 * Takes one or more DITA map managed objects and exports the map and its dependencies to
 * the file system. 
 */
public class MapExporterActionHandler extends AbstractBaseActionHandler {

	/**
	 * 
	 */
	public static final String EXPORTED_MAP_FILES_VARNAME = "mapFiles";
	/**
	 * Directory to put the output into. Each map will be in a directory below the output path.
	 */
	public static final String OUTPUT_PATH_PARAM = "outputPath";
	private static final long serialVersionUID = 1L;

	
	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.workflow.AbstractBaseNonLeavingActionHandler#execute(com.reallysi.rsuite.api.workflow.WorkflowExecutionContext)
	 */
	@Override
	public void execute(WorkflowExecutionContext context) throws Exception {
		Log wfLog = context.getWorkflowLog();
		
		File tempDir = new File(File.createTempFile("gargage", ""), "mapExporter_" + context.getProcessInstanceId());
		FileUtils.deleteQuietly(tempDir);
		tempDir.mkdirs(); // Assume this succeeds
		
		String outputPath = getParameterWithDefault(OUTPUT_PATH_PARAM, tempDir.getAbsolutePath());
		outputPath = resolveVariablesAndExpressions(context, outputPath);
		
		wfLog.info("Output path is \"" + outputPath + "\"");
		
		MoListWorkflowObject mos = context.getMoListWorkflowObject();
		if (mos == null) {
			wfLog.warn("No managed objects in the workflow context. Nothing to do");
			return;
		}
		
		ManagedObjectService moSvc = getManagedObjectService();
		
		boolean errorOccured = false;
		String errorMessage = "";
		ArrayList<ProcessedWorkflowObject> errorMos = new ArrayList<ProcessedWorkflowObject>();
		ArrayList<ProcessedWorkflowObject> exportedMaps = new ArrayList<ProcessedWorkflowObject>();
		
		
		for (MoWorkflowObject moObj : mos.getMoList()) {
			ManagedObject mo = moSvc.getManagedObject(getSystemUser(), moObj.getMoid());
			Element root = mo.getElement();
			if (DitaUtil.isDitaMap(root)) {
				try {
					FileWorkflowObject exportedMapFile = exportMap(context, outputPath, mo);
					exportedMaps.add(exportedMapFile);
				} catch (Exception e) {
					errorOccured = true;
					errorMessage = errorMessage + "Failed MO: [" + moObj.getMoid() + "]\r\n" + e + "\r\n\r\n";
					errorMos.add(moObj);
					e.printStackTrace();
					wfLog.error(e);
				}
			} else {
				wfLog.info("Managed object [" + mo.getId() + "] " + mo.getDisplayName() + " does not appear to be a DITA map, skipping.");
			}
		}
		
		context.setVariable(EXPORTED_MAP_FILES_VARNAME, exportedMaps);
		
		if(errorOccured) {
			wfLog.error("Errors occurred during map export, throwing exception");
			context.setAttribute("errorMos", errorMos.toString());
			wfLog.error("Errors from map exports");
			// FIXME: This next bit is just a placeholder for more complete error handling.
			BusinessRuleException e = new BusinessRuleException(errorMos);
			e.setFailureDetail(getFailDetail());
			e.setTaskname("Export DITA maps");
			throw e;
		} else {
			wfLog.info("Maps exported successfully");
		}

		
		wfLog.info("Done");
    }


	/**
	 * @param context
	 * @param outputPath 
	 * @param mo
	 */
	private FileWorkflowObject exportMap(WorkflowExecutionContext context, String outputPath, ManagedObject mo) throws RSuiteException {
		Log wfLog = context.getWorkflowLog();
		
		wfLog.info("Exporting DITA map [" + mo.getId() + "] " + mo.getDisplayName() + "...");
		
		wfLog.info("Calculating the map's bounded object set of dependencies...");
		BoundedObjectSet bos = RSuiteDitaHelper.calculateMapBos(context, wfLog, mo);
		bos.reportBos(wfLog);
		
		// Process the BOS members to set their paths as exported
		
		Properties filenameSettingOptions = new Properties();
		filenameSettingOptions.setProperty(TreeGeneratingOutputFilenameSettingBosVisitor.ROOT_DIR_PATH_OPTION, outputPath);
		filenameSettingOptions.setProperty(TreeGeneratingOutputFilenameSettingBosVisitor.MAPS_TO_NEW_DIRS_OPTION, "true");
		filenameSettingOptions.setProperty(TreeGeneratingOutputFilenameSettingBosVisitor.GRAPHICS_DIR_NAME_OPTION, "images");
		// Would be useful to have topic type-to-directory-name map that
		// specifies what directory name each kind of thing goes into.
		
		
		wfLog.info("Setting export paths for BOS members... ");
		BosVisitor outputFilenameSettingBosVisitor = new TreeGeneratingOutputFilenameSettingBosVisitor(filenameSettingOptions, wfLog);
		bos.accept(outputFilenameSettingBosVisitor);
		
		wfLog.info("*** After associating file names to BOS:");
		bos.reportBos(wfLog);

		wfLog.info("Exporting map BOS to the file system...");
		
		context.getManagedObjectService();
		
		BosVisitor exportingBosVisitor = new ExportingBosVisitor(context, wfLog);
		bos.accept(exportingBosVisitor);		
		
		File exportedFile = bos.getRoot().getFile();
		if (exportedFile == null) {
			throw new RSuiteException(0, "Null file from root member following export. This should not happen.");
		}

		FileWorkflowObject fwo = new FileWorkflowObject(exportedFile);
		fwo.setSource(new MoWorkflowObject(mo));
		
		wfLog.info("Map exported");

		return fwo;
	}

	public void setOutputPath(String outputPath) {
		this.setParameter(OUTPUT_PATH_PARAM, outputPath);
	}

    
}

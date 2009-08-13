/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.io.File;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;

import com.reallysi.rsuite.api.ManagedObject;
import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.AbstractBaseActionHandler;
import com.reallysi.rsuite.api.workflow.BusinessRuleException;
import com.reallysi.rsuite.api.workflow.FileWorkflowObject;
import com.reallysi.rsuite.api.workflow.MoListWorkflowObject;
import com.reallysi.rsuite.api.workflow.MoWorkflowObject;
import com.reallysi.rsuite.api.workflow.ProcessedWorkflowObject;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.rsuite.api.xml.DitaOpenToolkit;
import com.reallysi.tools.dita.BosVisitor;
import com.reallysi.tools.dita.BoundedObjectSet;
import com.reallysi.tools.dita.BrowseTreeConstructingBosVisitor;
import com.reallysi.tools.dita.DitaUtil;
import com.reallysi.tools.dita.DomUtil;
import com.reallysi.tools.dita.FileToMoPointerRewritingBosVisitor;
import com.reallysi.tools.dita.MoAssociatingBosVisitor;
import com.reallysi.tools.dita.RSuiteDitaHelper;

/**
 * Takes one or more DITA map files and imports each map and its dependencies
 * to RSuite.
 */
public class MapImporterActionHandler extends AbstractBaseActionHandler {

	/**
	 * Path of the root map to process. Use if map roots are not in FileWorkflowObject.
	 */
	public static final String ROOT_MAP_PATH_PARAM = "rootMapPath";
	
	/**
	 * Filename of the map. Will be looked for in the working directory.
	 */
	public static final String MAP_FILENAME = "mapFileName";
	
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
	 * The absolute path of the browse tree folder into which the map is
	 * imported. e.g. "/maps/mystuff"
	 */
	public static final String PARENT_BROWSE_TREE_FOLDER_PARAM = "parentBrowseTreeFolder";
	
	/**
	 * The path of the content assembly or node within the parent folder
	 * into which the map is imported, e.g. "books/reference" to create CA "books", CA Node "reference".
	 */
	public static final String PARENT_CA_NODE_PARAM = "parentCaNode";

	private static final long serialVersionUID = 1L;

	
	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.workflow.AbstractBaseNonLeavingActionHandler#execute(com.reallysi.rsuite.api.workflow.WorkflowExecutionContext)
	 */
	@Override
	public void execute(WorkflowExecutionContext context) throws Exception {
		Log wfLog = context.getWorkflowLog();
		
		this.checkParamsNotEmptyOrNull(PARENT_BROWSE_TREE_FOLDER_PARAM, PARENT_CA_NODE_PARAM);
		
		// We need the Open Toolkit because we use its catalog to parse the incoming files.
		String otName = getParameterWithDefault(OPEN_TOOLKIT_NAME_PARAM,"default");
		wfLog.info("Using Open Toolkit named \"" + otName + "\"");
		DitaOpenToolkit toolkit = context.getXmlApiManager().getDitaOpenToolkitManager().getToolkit(otName);
		if (toolkit == null) {
			throw new RSuiteException(0, "No DITA Open Toolkit named \"" + otName + "\" provided by Open Toolkit Manager. Cannot continue.");
		}
		
		String[] catalogs = new String[1];
		catalogs[0] = toolkit.getCatalogPath();

		
		
		File mapFile = null;

		mapFile = findMapDoc(context, wfLog);
		if (mapFile == null || !mapFile.exists()) {
			throw new RSuiteException(0, "Cannot find map file.");
		}
		
		boolean errorOccured = false;
		String errorMessage = "";
		ArrayList<ProcessedWorkflowObject> errorFiles = new ArrayList<ProcessedWorkflowObject>();
		ArrayList<MoWorkflowObject> importedMaps = new ArrayList<MoWorkflowObject>();
		
		Document doc;
		try {
			doc = DomUtil.getDomForDocument(mapFile, catalogs);
		} catch (Exception e) {
			throw new BusinessRuleException(0, "Exception parsing file \"" + mapFile.getAbsolutePath() + "\"");
		}
		if (DitaUtil.isDitaMap(doc.getDocumentElement())) {
			try {
				MoWorkflowObject importedMapMo = importMap(context, doc, catalogs);
				importedMaps.add(importedMapMo);
			} catch (Exception e) {
				errorOccured = true;
				errorMessage = errorMessage + "Failed File: [" + mapFile.getName() + "]\r\n" + e + "\r\n\r\n";
				errorFiles.add(new FileWorkflowObject(mapFile));
				e.printStackTrace();
				wfLog.error(e);
			}
		} else {
			wfLog.info("File " + mapFile.getName() + " does not appear to be a DITA map, skipping.");
		}
		
		context.setMoListWorkflowObject(new MoListWorkflowObject(importedMaps));
		
		if(errorOccured) {
			wfLog.error("Errors occurred during map import, throwing exception");
			context.setAttribute("errorFiles", errorFiles.toString());
			wfLog.error("Errors from map imports");
			// FIXME: This next bit is just a placeholder for more complete error handling.
			BusinessRuleException e = new BusinessRuleException(errorFiles);
			e.setFailureDetail(getFailDetail());
			e.setTaskname("Import DITA maps");
			throw e;
		} else {
			wfLog.info("Maps imported successfully");
		}

		
		wfLog.info("Done");
    }


	/**
	 * If the input is in the file workflow object, it very likely
	 * came from a zip file, and the root map could be below the root path,
	 * so look for it, otherwise, just do the import.
	 * @param context
	 * @param wfLog
	 * @return
	 * @throws RSuiteException
	 */
	protected File findMapDoc(WorkflowExecutionContext context, Log wfLog)
			throws RSuiteException {
		File mapFile = null;
		String rootMapPath = getParameter(ROOT_MAP_PATH_PARAM);
		rootMapPath = resolveVariablesAndExpressions(context, rootMapPath);
		
		if (rootMapPath == null || "".equals(rootMapPath.trim())) {
			FileWorkflowObject fileWFO = context.getFileWorkflowObject();
			if (fileWFO == null) {
				wfLog.warn("No file in the workflow context. Nothing to do");
				return null;
			}
			File candFile = fileWFO.getFile();
			if (candFile.getName().endsWith(".ditamap"))
				return candFile;
			
			if (candFile.isDirectory()) {
				candFile = candFile.getParentFile(); // Look in the work directory first, in case the zip didn't have a root directory.
				String mapFileName = this.getParameter(MAP_FILENAME);
				mapFileName = resolveVariablesAndExpressions(context, mapFileName);
				if (mapFileName == null || "".equals(mapFileName.trim())) {
					throw new RSuiteException(0, "Must specify " + MAP_FILENAME + " parameter if " + ROOT_MAP_PATH_PARAM + " parameter not specified.");
				}
				mapFile = lookForFilenameInDirTree(candFile, mapFileName);
				// Search the directory for the target file.
			}
		} else {
			mapFile = new File(rootMapPath);
			if (!mapFile.exists()) {
				throw new RSuiteException(0,"Specified root map file \"" + rootMapPath + "\" does not exist. Nothing ");
			}
		}
		
		return mapFile;
	}


	/**
	 * @param dir
	 * @param fileName
	 * @return
	 */
	private File lookForFilenameInDirTree(File dir, String fileName) {
		File result = null;
		File cand = new File(dir, fileName);
		File[] files = dir.listFiles();
		for (File file : files) {
			if (file.isFile()) {
				if (file.equals(cand))
					return file;
			}
		}
		for (File file : files) {		
			if (file.isDirectory()) {
				cand = lookForFilenameInDirTree(file, fileName);
				if (cand != null)
					return cand;
			}
		}
		return result;
	}


	/**
	 * @param context
	 * @param catalogs 
	 * @param outputPath 
	 * @param mo
	 */
	private MoWorkflowObject importMap(WorkflowExecutionContext context, Document mapDoc, String[] catalogs) throws RSuiteException {
		Log wfLog = context.getWorkflowLog();
		
		wfLog.info("Importing DITA map " + mapDoc.getDocumentURI() + "...");
		
		wfLog.info("Calculating the map's bounded object set of dependencies...");
		BoundedObjectSet bos = RSuiteDitaHelper.calculateMapBos(context, wfLog, mapDoc, catalogs);
		bos.reportBos(wfLog);
		
		// Process the BOS members to set their paths as exported
		
		Properties importOptions = new Properties();
		
		BosVisitor visitor;
		
		// NOTE: The process as implemented here reflects the fact that RSuite as of V3.13
		// has no "sandbox" or other way to allocate MO IDs without actually creating the MOs
		// in RSuite, so the "associate MOs" step here is doing the initial content load,
		// when all it should really be doing is geting the MO IDs of the MOs to which the
		// BOS members *will be* loaded. This means that the "construct browse tree components
		// step should be the point at which the MOs are committed to RSuite, but for now it
		// is just doing an update on the MOs as already loaded and creating the browe tree
		// components to which they are added.

		// Associate BOS members to ManagedObjects:
		importOptions.setProperty(MoAssociatingBosVisitor.MISSING_GRAPHIC_URI_OPTION, "/eduneering/images/missing-graphic");
		
		visitor = new MoAssociatingBosVisitor(context, importOptions, wfLog);
		
		wfLog.info("Associating MOs to BOS members...");
		bos.accept(visitor);

		wfLog.info("*** After MO association:");
		bos.reportBos(wfLog);

		// Rewrite pointers:
		wfLog.info("Rewriting pointers...");
		
		visitor = new FileToMoPointerRewritingBosVisitor(context, importOptions, wfLog);
		bos.accept(visitor);
		
		// Construct browse tree components for the map and bind
		// MOs to it.
		
		wfLog.info("Creating browse tree components for map and exposing MOs through it...");
		
		importOptions.setProperty(BrowseTreeConstructingBosVisitor.ROOT_FOLDER_OPTION, getParameter(PARENT_BROWSE_TREE_FOLDER_PARAM));
		importOptions.setProperty(BrowseTreeConstructingBosVisitor.ROOT_CA_PATH_OPTION, getParameter(PARENT_CA_NODE_PARAM));		
		
		visitor = new BrowseTreeConstructingBosVisitor(context, importOptions, wfLog);
		bos.accept(visitor);

		ManagedObject mapMo = bos.getRoot().getManagedObject();
		
		MoWorkflowObject moWFO = new MoWorkflowObject(mapMo);
		wfLog.info("Map imported");

		return moWFO;
	}
	
	public void setRootMapPath(String rootMapPath) {
		this.setParameter(ROOT_MAP_PATH_PARAM, rootMapPath);
	}
    
	public void setMapFileName(String mapFileName) {
		this.setParameter(MAP_FILENAME, mapFileName);
	}
    
	public void setParentBrowseTreeFolder(String parentBrowseTreeFolder) {
		this.setParameter(PARENT_BROWSE_TREE_FOLDER_PARAM, parentBrowseTreeFolder);
	}
    
	public void setParentCaNode(String parentCaNode) {
		this.setParameter(PARENT_CA_NODE_PARAM, parentCaNode);
	}
    
}

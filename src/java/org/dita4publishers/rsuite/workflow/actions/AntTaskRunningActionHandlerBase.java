/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.tools.ant.BuildLogger;
import org.apache.tools.ant.MagicNames;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;
import org.dita4publishers.rsuite.workflow.actions.loggers.RSuiteReportBuildLogger;
import org.dita4publishers.rsuite.workflow.actions.loggers.WorkflowBuildLogger;

import com.reallysi.rsuite.api.RSuiteException;
import com.reallysi.rsuite.api.workflow.AbstractBaseActionHandler;
import com.reallysi.rsuite.api.workflow.WorkflowExecutionContext;
import com.reallysi.tools.StringUtil;

/**
 *
 */
public abstract class AntTaskRunningActionHandlerBase extends
		AbstractBaseActionHandler {

	/**
	 * Specifies the name of the workflow variable to hold the ID of RSuite-managed
	 * report holding the Ant process log. If not specified, defaults to 
	 * the value of the ANT_REPROT_ID_VARNAME constant.
	 */
	public static final String ANT_REPORT_ID_VAR_NAME_PARAM = "antReportIdVarName";
	/**
	 * The name of the workflow variable to hold the Ant report ID so it can
	 * be retrieved later.
	 */
	public static final String ANT_REPORT_ID_VARNAME = "antReportId";
	public static final String DATE_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
	public static final DateFormat DATE_FORMAT = new SimpleDateFormat(DATE_FORMAT_STRING);
	/**
	 * Pipe ("|")-delimited list of name/value pairs, where each pair is
	 * a property name, a colon, and the property value:
	 * <p><code>prop1:value1|prop2:value2</code></p>
	 */
	public static final String BUILD_PROPERTIES_PARAM = "buildProperties";
	/**
	 * The Ant target to run. If unspecified, default target configured
	 * for the project is used.
	 */
	public static final String BUILD_TARGET_PARAM = "buildTarget";
	/**
	 * Absolute path of the Ant build file to process. Required.
	 */
	public static final String BUILD_FILE_PATH_PARAM = "buildFilePath";

	public static String getNowString() {
		String timeStr = DATE_FORMAT.format(new Date());
		return timeStr.substring(0, timeStr.length()-2) + ":00";
	}

	public void setBuildFilePath(String buildFilePath) {
		setParameter(BUILD_FILE_PATH_PARAM, buildFilePath);
	}

	public void setBuildTarget(String buildTarget) {
		setParameter(BUILD_TARGET_PARAM, buildTarget);
	}

	public void setBuildProperties(String buildProperties) {
		setParameter(BUILD_PROPERTIES_PARAM, buildProperties);
	}

	public void setAntReportIdVarName(String antReportIdVarName) {
		setParameter(ANT_REPORT_ID_VAR_NAME_PARAM, antReportIdVarName);
	}

	protected File getBuildFile(WorkflowExecutionContext context, Log wfLog)
			throws RSuiteException {
				File buildFile = null;
				String buildFilePath = getParameter(BUILD_FILE_PATH_PARAM);
				buildFilePath = resolveVariablesAndExpressions(context, buildFilePath);
				
				if (!StringUtil.isNullOrEmptyOrSpace(buildFilePath)) {
					buildFile = new File(buildFilePath);
					if (!buildFile.exists()) {
						String msg = "Build file \"" + buildFile.getAbsolutePath() + "\" does not exist."; 
						wfLog.error(msg);
						throw new RSuiteException(0, msg);
					}
					if (!buildFile.canRead()) {
						String msg = "Build file \"" + buildFile.getAbsolutePath() + "\" exists but cannot be read."; 
						wfLog.error(msg);
						throw new RSuiteException(0, msg);
					}
				}
				return buildFile;
			}

	protected void setBuildProperties(Log wfLog, Project project, Properties props)
			throws RSuiteException {
		for (Object key : props.keySet()) {
			String keyStr = (String)key;
			String value = (String)props.getProperty((String)key);
			wfLog.info("Setting project property \"" + keyStr + "\" to value \"" + value +"\"");
			project.setProperty(keyStr, value);
		}
	}

	public void startAnt(Project project, File buildFile, List<BuildLogger> buildLoggers)
			throws RSuiteException {
			
				RSuiteException error = null;
			
			    project.init();
				try {
					for (BuildLogger logger : buildLoggers) {
						project.addBuildListener(logger);				
					}
					project.setKeepGoingMode(true);
			        project.fireBuildStarted();
			        project.setUserProperty(MagicNames.ANT_FILE,
			                buildFile.getAbsolutePath());
					ProjectHelper.configureProject(project, buildFile);
					project.executeTarget("init");
				} catch (Throwable e) {
					error = new RSuiteException(0, "Exception processing build file \"" + buildFile.getAbsolutePath() + "\"", e);
				} finally {
			        project.fireBuildFinished(error);
				}
				
				if (error != null)
					throw error;
				
			}

	/**
	 * @param buildProperties
	 * @return
	 * @throws RSuiteException 
	 */
	protected Properties parseBuildPropertiesString(Log wfLog, String buildProperties)
			throws RSuiteException {
				Properties props = new Properties();
				if (!StringUtil.isNullOrEmptyOrSpace(buildProperties)) {
					wfLog.info("Parsing build properties using parameter value \"" + buildProperties + "\"...");
					StringTokenizer tokenizer = new StringTokenizer(buildProperties, "|");
					while (tokenizer.hasMoreTokens()) {
						String token = tokenizer.nextToken();
						if (!token.contains("=")) {
							throw new RSuiteException(0, "build properties property item did not contain expected equals (=) character, value was \"" + token + "\"");
						}
						String propName = token.substring(0, token.indexOf("=") - 1);
						String propValue = token.substring(token.indexOf("=") + 1);
						wfLog.info("  Property: " + propName);
						wfLog.info("     Value: " + propValue);
						props.setProperty(propName, propValue);
					}
				}
				return props;
			}

	protected void setupAndRunAntProject(WorkflowExecutionContext context, Log wfLog,
			File buildFile, String reportId, Properties props)
			throws RSuiteException {
				Project project = new Project();
		
				setBuildProperties(wfLog, project, props);
			
				List<BuildLogger> buildLoggers = new ArrayList<BuildLogger>();
				WorkflowBuildLogger wfBuilderLogger = new WorkflowBuildLogger(wfLog);
				wfBuilderLogger.setMessageOutputLevel(Project.MSG_VERBOSE);
				
				buildLoggers.add(wfBuilderLogger);
				// To get Ant <diagnostics/> output in the RSuite console log
				// if a <diagnostics> task has been added to the Ant script:
//				buildLoggers.add(new DefaultLogger());
				
				wfLog.info("Ant log will be report with ID \"" + reportId + "\"");
				
				String antReportIdVarName = getParameterWithDefault(ANT_REPORT_ID_VAR_NAME_PARAM, ANT_REPORT_ID_VARNAME);
				antReportIdVarName = resolveVariablesAndExpressions(context, antReportIdVarName);
				
				context.setVariable(antReportIdVarName, reportId);
				RSuiteReportBuildLogger reportBuildLogger = new RSuiteReportBuildLogger();
				
				buildLoggers.add(reportBuildLogger);
				
				wfLog.info("Invoking the Ant process....");
				
			    try {
					startAnt(project, buildFile, buildLoggers);
				} catch (Exception e) {
					wfLog.info("Exception from Ant process: " + e.getMessage());
				}
			    context.getReportManager().saveReport(reportId, reportBuildLogger.getReportString());
			}

	/**
	 * 
	 */
	public AntTaskRunningActionHandlerBase() {
		super();
	}

}
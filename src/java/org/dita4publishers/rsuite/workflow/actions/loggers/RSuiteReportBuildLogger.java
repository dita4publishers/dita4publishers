/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions.loggers;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.io.StringWriter;

import org.apache.commons.io.IOUtils;
import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildLogger;
import org.apache.tools.ant.DefaultLogger;

import com.reallysi.rsuite.api.RSuiteException;

/**
 *
 */
public class RSuiteReportBuildLogger implements BuildLogger {
	
	private DefaultLogger logger;
	private ByteArrayOutputStream baos;

	public RSuiteReportBuildLogger() {
		this.logger = new DefaultLogger();
		
		
		this.baos = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(baos);
		
		// Set the default output streams for the logger implementation:
		this.logger.setErrorPrintStream(ps);
		this.logger.setOutputPrintStream(ps);

	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setEmacsMode(boolean)
	 */
	public void setEmacsMode(boolean emacsMode) {
		logger.setEmacsMode(emacsMode);

	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setErrorPrintStream(java.io.PrintStream)
	 */
	public void setErrorPrintStream(PrintStream arg0) {
		logger.setErrorPrintStream(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setMessageOutputLevel(int)
	 */
	public void setMessageOutputLevel(int arg0) {
		logger.setMessageOutputLevel(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setOutputPrintStream(java.io.PrintStream)
	 */
	public void setOutputPrintStream(PrintStream arg0) {
		throw new RuntimeException("Cannot change printstream on this type of logger, set in constructor");
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#buildFinished(org.apache.tools.ant.BuildEvent)
	 */
	public void buildFinished(BuildEvent arg0) {
		logger.buildFinished(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#buildStarted(org.apache.tools.ant.BuildEvent)
	 */
	public void buildStarted(BuildEvent arg0) {
		logger.buildStarted(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#messageLogged(org.apache.tools.ant.BuildEvent)
	 */
	public void messageLogged(BuildEvent arg0) {	
		logger.messageLogged(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#targetFinished(org.apache.tools.ant.BuildEvent)
	 */
	public void targetFinished(BuildEvent arg0) {
		logger.targetFinished(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#targetStarted(org.apache.tools.ant.BuildEvent)
	 */
	public void targetStarted(BuildEvent arg0) {
		logger.targetStarted(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#taskFinished(org.apache.tools.ant.BuildEvent)
	 */
	public void taskFinished(BuildEvent arg0) {
		logger.taskFinished(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#taskStarted(org.apache.tools.ant.BuildEvent)
	 */
	public void taskStarted(BuildEvent arg0) {
		logger.taskStarted(arg0);
	}

	/**
	 * @return
	 * @throws RSuiteException 
	 */
	public String getReportString() throws RSuiteException {
		StringWriter sw = new StringWriter();
		try {
			IOUtils.copy(new ByteArrayInputStream(baos.toByteArray()), sw, "utf-8");
		} catch (IOException e) {
			throw new RSuiteException(0, "Failed to copy report bytes to StringWriter: " + e.getMessage(), e);
		}
		return sw.toString();
    }

}

/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions.loggers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.StringReader;

import org.apache.commons.logging.Log;
import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildLogger;
import org.apache.tools.ant.DefaultLogger;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.util.DateUtils;
import org.apache.tools.ant.util.StringUtils;

/**
 * Ant build logger that logs to a workflow log.
 */
public class WorkflowBuildLogger implements BuildLogger {

	private int messageOutputLevel = Project.MSG_ERR;
	private Log wfLog;
	private DefaultLogger logger;
	private long startTime;
	private Object lastTarget = null;
    public static final int LEFT_COLUMN_SIZE = 12;    

	/**
	 * @param wfLog
	 */
	public WorkflowBuildLogger(Log wfLog) {
		this.wfLog = wfLog;
//		this.logger = new DefaultLogger();
		
		// Set the default output streams for the logger implementation:
//		this.logger.setErrorPrintStream(System.err);
//		this.logger.setOutputPrintStream(System.out);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setEmacsMode(boolean)
	 */
	public void setEmacsMode(boolean arg0) {
//		this.logger.setEmacsMode(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setErrorPrintStream(java.io.PrintStream)
	 */
	public void setErrorPrintStream(PrintStream arg0) {
//		this.logger.setErrorPrintStream(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setMessageOutputLevel(int)
	 */
	public void setMessageOutputLevel(int arg0) {
		this.messageOutputLevel = arg0;
//		this.logger.setMessageOutputLevel(arg0);

	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildLogger#setOutputPrintStream(java.io.PrintStream)
	 */
	public void setOutputPrintStream(PrintStream arg0) {
//		this.logger.setOutputPrintStream(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#buildFinished(org.apache.tools.ant.BuildEvent)
	 */
	public void buildFinished(BuildEvent event) {
        Throwable error = event.getException();
        StringBuilder message = new StringBuilder();
        if (error == null) {
            wfLog.info("BUILD SUCCESSFUL");
        } else {
            wfLog.error("");
            wfLog.error("BUILD FAILED");

            if (Project.MSG_VERBOSE <= this.messageOutputLevel
                || !(error instanceof BuildException)) {
                message.append(StringUtils.getStackTrace(error));
                wfLog.error(message.toString());
            } else {
            	writeMessageToLogField(message.toString());
            }
        }
        wfLog.info("Total time: " + formatTime(System.currentTimeMillis() - startTime));

//		this.logger.buildFinished(event);		

	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#buildStarted(org.apache.tools.ant.BuildEvent)
	 */
	public void buildStarted(BuildEvent arg0) {
        startTime = System.currentTimeMillis();
//		this.logger.buildStarted(arg0);		

	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#messageLogged(org.apache.tools.ant.BuildEvent)
	 */
	public void messageLogged(BuildEvent event) {
        int priority = event.getPriority();
        // Filter out messages based on priority
        if (priority <= messageOutputLevel) {
            StringBuilder message = new StringBuilder();
            if (event.getTask() != null) {
                // Print out the name of the task if we're in one
                String name = event.getTask().getTaskName();
                String label = "    [" + name + "] ";
                int size = LEFT_COLUMN_SIZE - label.length();
                StringBuilder tmp = new StringBuilder();
                for (int i = 0; i < size; i++) {
                    tmp.append(" ");
                }
                tmp.append(label);
                label = tmp.toString();
                try {
                    BufferedReader r =
                        new BufferedReader(
                            new StringReader(event.getMessage()));
                    String line = r.readLine();
                    do {
                    	writeMessageToLogField(label + line);
                        message = new StringBuilder();
                        line = r.readLine();
                    } while (line != null);
                } catch (IOException e) {
                    message.append(event.getMessage());
                }
            } else {
                message.append(event.getMessage());
            }
            Throwable ex = event.getException();
            if (Project.MSG_DEBUG <= messageOutputLevel && ex != null) {
                    message.append(StringUtils.getStackTrace(ex));
            }
        	writeMessageToLogField(message.toString());
        }
//		this.logger.messageLogged(event);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#targetFinished(org.apache.tools.ant.BuildEvent)
	 */
	public void targetFinished(BuildEvent arg0) {
//		logger.targetFinished(arg0);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#targetStarted(org.apache.tools.ant.BuildEvent)
	 */
	public void targetStarted(BuildEvent event) {
        if (event.getPriority() <= messageOutputLevel) {
        	Task task = event.getTask();
        	if (task != null)
        		writeMessageToLogField("    [" + event.getTask().getTaskName() + "] ");
        }
//		logger.targetStarted(event);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#taskFinished(org.apache.tools.ant.BuildEvent)
	 */
	public void taskFinished(BuildEvent event) {
        if (event.getPriority() <= messageOutputLevel) {
        	writeMessageToLogField("");
        }
//		logger.targetFinished(event);
	}

	/* (non-Javadoc)
	 * @see org.apache.tools.ant.BuildListener#taskStarted(org.apache.tools.ant.BuildEvent)
	 */
	public void taskStarted(BuildEvent event) {
		String targetName = event.getTarget().getName();
		if (targetName.equals(this.lastTarget))
			return;
		lastTarget = targetName;
        if (Project.MSG_INFO <= messageOutputLevel
                && !event.getTarget().getName().equals("")) {
        	wfLog.info("");
        	writeMessageToLogField(targetName + ":");
        	wfLog.info("");
        }
//		logger.targetStarted(event);
	}
	protected static String formatTime(final long millis) {
        return DateUtils.formatElapsedTime(millis);
    }


	protected void writeMessageToLogField(String msg) {
		if ("".equals(msg.trim()))
			return;
		this.wfLog.info(msg);
	}


}

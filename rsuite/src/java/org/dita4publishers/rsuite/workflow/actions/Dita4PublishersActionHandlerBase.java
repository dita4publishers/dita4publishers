/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita4publishers.rsuite.workflow.actions;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.reallysi.rsuite.api.workflow.AbstractBaseActionHandler;

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
	 * 
	 */
	public Dita4PublishersActionHandlerBase() {
		super();
	}

}
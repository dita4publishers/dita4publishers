/**
 * Copyright (c) 2010 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.tools.dxp;


/**
 * Violation of some DITA Interchange Package rule or processing failure.
 */
public class DitaDxpException extends Exception {

	/**
	 * @param msg
	 * @param e
	 */
	public DitaDxpException(String msg, Exception e) {
		super(msg, e);
	}

	/**
	 * @param msg
	 */
	public DitaDxpException(String msg) {
		super(msg);
	}

	private static final long serialVersionUID = 1L;

}

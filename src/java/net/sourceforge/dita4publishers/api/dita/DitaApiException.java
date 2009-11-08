/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

/**
 * Exceptions from the DITA API.
 */
public class DitaApiException extends Exception {

	private static final long serialVersionUID = 1L;

	/**
	 * 
	 */
	public DitaApiException() {
		super();
	}

	/**
	 * @param message
	 */
	public DitaApiException(String message) {
		super(message);
	}

	/**
	 * @param cause
	 */
	public DitaApiException(Throwable cause) {
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public DitaApiException(String message, Throwable cause) {
		super(message, cause);
	}

}

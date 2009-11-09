/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.dita;

/**
 * Violation of DITA-defined rules or DITA-specific
 * processing failure.
 * <p>NOTE: Extends runtime exception so that 
 * instances can be constructed statically.</p>
 */
public class DitaException extends RuntimeException {

	private static final long serialVersionUID = -1L;

	/**
	 * @param message
	 */
	public DitaException(String message) {
		super(message);
	}

}

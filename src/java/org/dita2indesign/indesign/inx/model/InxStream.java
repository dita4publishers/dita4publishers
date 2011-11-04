/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

/**
 * Represents a stream object.
 * 
 * NOTE: Cannot find documentation on what this value is, so holding it as a string.
 */
public class InxStream extends InxString {

	/**
	 * @param rawValue
	 */
	public InxStream(String rawValue) {
		super(rawValue);
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#toEncodedString()
	 */
	@Override
	public String toEncodedString() {
		return "m_" + this.getValue();
	}

}

/**
 * 
 */
package org.dita2indesign.indesign.inx.model;

/**
 * Base clase for 32- and 64-bit Long values.
 */
public abstract class InxLongBase extends InxValue {

	protected long value;

	public Long getValue() {
		return new Long(value);
	}


}

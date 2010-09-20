/**
 * 
 */
package org.dita2indesign.indesign.inx.model;

/**
 *
 */
public class InxEnumeration extends InxString {

	/**
	 * @param rawValue
	 */
	public InxEnumeration(String rawValue) {
		super(rawValue);
	}
	
	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#toEncodedString()
	 */
	@Override
	public String toEncodedString() {
		return "e_" + this.getValue().replace("_", "~sep~");
	}


}

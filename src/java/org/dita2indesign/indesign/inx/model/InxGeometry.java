/**
 * 
 */
package org.dita2indesign.indesign.inx.model;

/**
 *
 */
public class InxGeometry extends InxValue {

	private Geometry geometry = null;

	/**
	 * @param geometry
	 */
	public InxGeometry(Geometry geometry) {
		this.geometry = geometry;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#getValue()
	 */
	@Override
	public Object getValue() {
		return this.geometry;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InxValue#toEncodedString()
	 */
	@Override
	public String toEncodedString() {
		return InxHelper.encodeGeometry(this.geometry);
	}

}

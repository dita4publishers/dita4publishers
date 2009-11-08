package net.sourceforge.dita4publishers.impl.ditabos;

import org.w3c.dom.Element;

/**
 *
 */
public class KeySpaceEntry {

	private Element keydef;
	private String key;
	private Object resource;

	/**
	 * @param keydef
	 */
	public KeySpaceEntry(String key, Element keydef) {
		this.key = key;
		this.keydef = keydef;
	}
	
	public String getKey() {
		return this.key;
	}
	
	public Element getKeyDef() {
		return this.keydef;
	}
	
	public Object getResource() {
		return this.resource;
	}

	/**
	 * @param resource
	 */
	public void setResource(Object resource) {
		this.resource = resource;
	}

}
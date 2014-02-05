package net.sourceforge.dita4publishers.util.conversion;

import org.w3c.dom.Element;

/**
 * A conversion configuration value that is a single string.
 *
 */
public class StringConfigValue extends ConversionConfigValueBase {

	private String value;

	public StringConfigValue(Element valueNode) {
		this.value = valueNode.getTextContent();
	}

	public String getString() {
		return this.value;
	}

}

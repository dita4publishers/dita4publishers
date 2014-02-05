package net.sourceforge.dita4publishers.util.conversion;

import org.w3c.dom.Element;


/**
 * Manages the construction of conversion configuration
 * values from configuration file elements.
 *
 */
public class ConversionConfigValueFactory {

	public static ConversionConfigValue newValue(Element valueNode) throws Exception {
		if (valueNode == null) return null;
		String classAttValue = valueNode.getAttribute("class");
		if (classAttValue.contains(" conversion_configuration/optionValue ")) {
			return new StringConfigValue(valueNode);
		}

		if (classAttValue.contains(" conversion_configuration/optionValueMap ")) {
			return new ConversionConfigValueMap(valueNode);
		}
		
		throw new Exception("Unrecognized configuration value element \"" + valueNode.getNodeName() + ", class=\"" + classAttValue + "\"");
	}

}

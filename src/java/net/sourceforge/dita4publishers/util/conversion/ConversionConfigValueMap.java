package net.sourceforge.dita4publishers.util.conversion;

import java.util.HashMap;
import java.util.Map;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sf.saxon.xpath.XPathFactoryImpl;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * A map of names to values.
 *
 */
public class ConversionConfigValueMap extends ConversionConfigValueBase {

	private  Map<String, ConversionConfigValue> map = new HashMap<String, ConversionConfigValue>();

	public ConversionConfigValueMap(Element valueNode) throws Exception {
		this.map = constructValueMap(valueNode);
	}

	private Map<String, ConversionConfigValue> constructValueMap(Element valueMap) throws Exception {
		Map<String, ConversionConfigValue> value = new HashMap<String, ConversionConfigValue>();
		XPathFactoryImpl xpathFactory = new net.sf.saxon.xpath.XPathFactoryImpl();
		String xpath = "*[contains(@class, ' conversion_configuration/valueMap ')]/*[contains(@class, ' conversion_configuration/valueMapEntry ')]";
		try {
			// Get the map items
			NodeList entryNodes = (NodeList)xpathFactory.newXPath().evaluate(xpath, valueMap, XPathConstants.NODESET);
			if (entryNodes != null && entryNodes.getLength() > 0) {
				for (int i = 0; i < entryNodes.getLength(); i++) {
					Node entryNode = entryNodes.item(i);
					xpath = "*[contains(@class, ' conversion_configuration/valueKey ')]";
					String key = (String)xpathFactory.newXPath().evaluate(xpath, entryNode, XPathConstants.STRING);
					if (key != null && !"".equals(key.trim())) {
						xpath = "*[contains(@class, ' conversion_configuration/optionValue ')] | *[contains(@class, ' conversion_configuration/optionValueMap ')]";
						Node valueNode = (Node)xpathFactory.newXPath().evaluate(xpath, entryNode, XPathConstants.NODE);
						if (valueNode != null) {
							ConversionConfigValue entryValue = ConversionConfigValueFactory.newValue((Element)valueNode);
						    value.put(key, entryValue);
						} else {
							throw new Exception("No map for parameter with name \"" + key + "\". This indicates a problem with the configuration file.");
						}
					}
				}
			}
		} catch (XPathExpressionException e) {
			throw new Exception("Exception evaluating XPath \"" + xpath + "\"", e);
		}
		return value;
	}

	public ConversionConfigValue get(String key) {
		return map.get(key);
	}

	public String getStringValue(String key) {
		ConversionConfigValue value = map.get(key);
		if (value == null) {
			return null;
		}
		if (value instanceof StringConfigValue) {
			return ((StringConfigValue)value).getString();
		}
		throw new RuntimeException("Map entry \"" + key + "\" is not string value, got " + value.getClass().getSimpleName());
	}

}

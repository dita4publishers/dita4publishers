package net.sourceforge.dita4publishers.util.conversion;

import java.util.HashMap;
import java.util.Map;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sf.saxon.xpath.XPathFactoryImpl;

import org.w3c.dom.Element;
import org.w3c.dom.Node;


/**
 * Conversion Config backed by a conversion_config XML MO.
 *
 */
public class ConversionConfigImpl implements ConversionConfig {

	private Element element;
	private Map<String, String> parameters = new HashMap<String, String>();
	private String id;

	public ConversionConfigImpl(Element element, String configId) {
		this.element = element;
		this.id = configId;
	}

	@Override
	public String getStringParameter(String paramName) throws Exception {
		String value = null;
		String xpath = "//*[contains(@class, ' conversion_configuration/optionName ')][normalize-space(.) = '" + paramName + "']/../" +
				"*[contains(@class, ' conversion_configuration/optionValue ')]";
		XPathFactoryImpl xpathFactory = new net.sf.saxon.xpath.XPathFactoryImpl();
		try {
			value = (String)xpathFactory.newXPath().evaluate(xpath, element, XPathConstants.STRING);
		} catch (XPathExpressionException e) {
			throw new Exception("Exception evaluating XPath \"" + xpath + "\"", e);
		}
		if (value != null && !"".equals(value.trim())) {
			this.parameters.put(paramName, value);
		}
		return value;
	}

	@Override
	public String getId() {
		return this.id;
	}

	@Override
	public ConversionConfigValueMap getValueMapParameter(String paramName) throws Exception {
		String xpath = "//*[contains(@class, ' conversion_configuration/optionName ')][normalize-space(.) = '" + paramName + "']/../" +
				"*[contains(@class, ' conversion_configuration/optionValueMap ')]";
		XPathFactoryImpl xpathFactory = new net.sf.saxon.xpath.XPathFactoryImpl();
		Node valueMapNode = null;
		try {
			valueMapNode = (Node)xpathFactory.newXPath().evaluate(xpath, element, XPathConstants.NODE);
			return (ConversionConfigValueMap)ConversionConfigValueFactory.newValue((Element)valueMapNode);
		} catch (XPathExpressionException e) {
			throw new Exception("Exception evaluating XPath \"" + xpath + "\"", e);
		}
	}

}

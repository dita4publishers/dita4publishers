/**
 * Copyright (c) 2010 DITA for Publishers
 */
package net.sourceforge.dita4publishers.util.xml;

import java.util.Stack;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.Attributes;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLFilterImpl;

/**
 * SAX error handler that saves the messages as an XML document.
 */
public class XmlFormatSaxErrorHandlingXMLFilter extends XMLFilterImpl implements ErrorHandler {

	private Document logDom;
	private Stack<Node> nodeStack = new Stack<Node>();
	// Stack of the actual @xtrc values from each element. Values
	// may be null.
	private Stack<String> xtrcAttStack = new Stack<String>();
	// Stack of non-null values, used to get value
	// to use for messages:
	private Stack<String> xtrcValueStack = new Stack<String>();
	
	// Holds ancestry of current element
	private Stack<String> ancestorStack = new Stack<String>();
	
	
	private Log log;

	/**
	 * @param log
	 */
	public XmlFormatSaxErrorHandlingXMLFilter(XMLReader parentReader, Log log, Document logDom) {
		super(parentReader);
		
		this.log = log;
		this.logDom = logDom;
		this.nodeStack .push(logDom);
		Element root = logDom.createElement("parserMessages");
		logDom.appendChild(root);
		nodeStack.push(root);
	}
	
	/**
	 * @throws SAXException
	 */
	public void startElement(String uri,
            String localName,
            String qName,
            Attributes atts) throws SAXException {
		ancestorStack.push(localName);
		String xtrc = atts.getValue("xtrc");
		xtrcAttStack.push(xtrc);
		if (xtrc != null) {
			xtrcValueStack.push(xtrc);
		}
		// The xtrf value will be the same for all elements because there is 
		// only ever a single document.xml file in a Word package, so we only
		// need to capture the first non-null value we find.
		if (!logDom.getDocumentElement().hasAttribute("xtrf")) {
			String xtrfValue = atts.getValue("xtrf");
			if (xtrfValue != null) {
				logDom.getDocumentElement().setAttribute("xtrf", xtrfValue);
			}
		}
		super.startElement(uri, localName, qName, atts);
	}
	
	public void endElement(String uri,
                String localName,
                String qName) throws SAXException {
		String attValue = xtrcAttStack.pop();
		if (attValue != null) {
			xtrcValueStack.pop();
		}
		ancestorStack.pop();
		super.endElement(uri, localName, qName);
	}

	/* (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#error(org.xml.sax.SAXParseException)
	 */
	public void error(SAXParseException e) throws SAXException {
		Element elem = logException(e);
		elem.setAttribute("severity","ERROR");

	}

	protected Element logException(SAXParseException e) {
		log.error(formatMessage(e));
		
		Element elem = logDom.createElement("message");
		elem.setAttribute("line", String.valueOf(e.getLineNumber()));
		elem.setAttribute("column", String.valueOf(e.getColumnNumber()));
		if (!xtrcValueStack.isEmpty()) {
			elem.setAttribute("wordParaXPath", xtrcValueStack.peek());
		}
		elem.setAttribute("tagname", this.ancestorStack.peek());
		elem.setTextContent(e.getMessage());
		nodeStack.peek().appendChild(elem);
		return elem;
	}

	protected String formatMessage(SAXParseException e) {
		String msg = e.getSystemId() + ": " + formatLocString(e) + e.getMessage();
		return msg;
	}

	/* (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#fatalError(org.xml.sax.SAXParseException)
	 */
	public void fatalError(SAXParseException e) throws SAXException {
		log.error("[FATAL] " + formatMessage(e));
		e.printStackTrace();
		Element elem = logException(e);
		elem.setAttribute("severity","FATAL");

	}

	/* (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#warning(org.xml.sax.SAXParseException)
	 */
	public void warning(SAXParseException e) throws SAXException {
		log.warn(formatMessage(e));
		Element elem = logException(e);
		elem.setAttribute("severity","WARN");

	}
	
	public String formatLocString(SAXParseException e) {
		long lineNum = e.getLineNumber();
		int colNum = e.getColumnNumber();
	
		String locStr = "";
		if (lineNum > 0 && colNum >= 0) {
			locStr = "Line " + lineNum + ":" + colNum + " - ";
		}
		return locStr;
	}


}

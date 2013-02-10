/**
 * Copyright (c) 2010 DITA for Publishers
 */
package net.sourceforge.dita4publishers.util.xml;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.ErrorHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.ext.DefaultHandler2;
import org.xml.sax.ext.Locator2Impl;
import org.xml.sax.helpers.AttributesImpl;

/**
 * Handles errors and maintains location information for the current element
 * context in order be able to report it with the error reports. The validation
 * report is an XML document.
 */
public class ContextTrackingErrorHandler extends DefaultHandler2 implements
		ContentHandler, ErrorHandler {

	/**
	 * 
	 */
	public static final int CONTENT_TRUNCATION_LENGTH = 60;

	/**
	 *
	 */
	public class ParsingContext {

		private String uri;
		private String localName;
		private String qName;
		private Attributes atts;
		private StringBuilder charbuf = new StringBuilder();
		private Locator locator;
		private List<ParsingContext> children = new ArrayList<ParsingContext>();
		private List<SAXParseException> pendingErrors = new ArrayList<SAXParseException>();

		/**
		 * @param uri
		 * @param localName
		 * @param qName
		 * @param atts
		 * @param locator 
		 */
		public ParsingContext(String uri, String localName, String qName,
				Attributes atts, Locator locator) {
			this.uri = uri;
			this.localName = localName;
			this.qName = qName;
			this.atts = new AttributesImpl(atts);
			this.locator = locator;
		}

		/**
		 * 
		 */
		public ParsingContext() {
			
		}

		/**
		 * @param ch
		 */
		public void append(char[] ch) {
			this.charbuf.append(ch);
		}

		/**
		 * @return
		 */
		public int getLineNumber() {
			if (this.locator != null)
				return this.locator.getLineNumber();
			return -1;
		}

		/**
		 * @return
		 */
		public int getColumnNumber() {
			if (this.locator != null)
				return this.locator.getColumnNumber();
			return -1;
		}

		/**
		 * @return
		 */
		public String getLocalName() {
			return this.localName;
		}

		/**
		 * @return
		 */
		public Attributes getAttributes() {
			return this.atts;
		}

		/**
		 * @return
		 */
		public String getCharacters() {
			return this.charbuf.toString();
		}

		/**
		 * @param c
		 */
		public void append(char c) {
			this.charbuf.append(c);
		}

		/**
		 * @param context
		 */
		public void addChild(ParsingContext context) {
			this.children .add(context);
		}

		/**
		 * @return
		 */
		public List<ParsingContext> getChildren() {
			return this.children;
		}

		/**
		 * @param pendingErrors
		 */
		public void setPendingErrors(List<SAXParseException> pendingErrors) {
			this.pendingErrors .addAll(pendingErrors);
		}

		/**
		 * @return
		 */
		public List<SAXParseException> getPendingErrors() {
			return this.pendingErrors;
		}


	}

	private Log log;
	private StringBuilder charbuf = new StringBuilder();
	private Stack<ParsingContext> contextStack = new Stack<ParsingContext>();
	private ParsingContext context = new ParsingContext();
	private Locator locator;
	private boolean isValid = true;
	private Document validationReport;
	private Element currentElement;
    // Holds errors issued before the start tag is handled.
	private List<SAXParseException> pendingErrors = new ArrayList<SAXParseException>();

	/**
	 * @param log
	 * @throws Exception 
	 */
	public ContextTrackingErrorHandler(Log log) throws Exception {
		if (log.isDebugEnabled())
			log.debug("Constructing new ContextTrackingErrorHandler with a log");
		this.log = log;
		this.validationReport = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		this.currentElement = this.validationReport.createElement("validationReport");
		this.validationReport.appendChild(currentElement);
	}
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		if (log.isDebugEnabled())
			log.debug("characters(): " + start + ", " + length);
		for (int i = start;i < start + length;i++) {
			context.append(ch[i]);
		}
	}
	
	public void startElement(String uri, String localName, String qName, Attributes atts) throws SAXException {
		if (log.isDebugEnabled())
			log.debug("startElement(): " + localName + ", qName=" + qName);
		contextStack.push(this.context);
		Locator locator = new Locator2Impl(this.locator);
		this.context = new ParsingContext(uri, localName, qName, atts, locator);
		contextStack.peek().addChild(this.context);
		if (this.pendingErrors.size() > 0) {
			this.context.setPendingErrors(this.pendingErrors);
			this.pendingErrors.clear();
		}
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException{
		if (log.isDebugEnabled())
			log.debug("endElement(): " + localName + ", qName=" + qName);
		for (SAXParseException e : this.context.getPendingErrors()) {
			reportParseException(e, e.getLineNumber(), e.getColumnNumber(), localName);
		}
		this.context = contextStack.pop();
	}
	
	public void setDocumentLocator(Locator locator) {
		if (log.isDebugEnabled())
			log.debug("setDocumentLocator(): " + locator);
		this.locator = locator;
	}
	
	public void warning(SAXParseException e) throws SAXException {
		log.warn(context.getLineNumber() + ":" + context.getColumnNumber() + " - " + e.getMessage());
		// FIXME: Construct context element in result DOM.
	}

	public void error(SAXParseException e) throws SAXException {
		int lineNum = context.getLineNumber();
		int colNum = context.getColumnNumber();
		if (lineNum < 1) lineNum = e.getLineNumber();
		if (colNum < 1) colNum = e.getColumnNumber();
		
		log.error(lineNum + ":" + colNum + " - " + e.getMessage());
		String localName = context.getLocalName();
		this.isValid = false;

		if (localName == null) {
			// Must be an issue with the document element's
			// start tag.
			this.pendingErrors .add(e);
			return;
		}

		reportParseException(e, lineNum, colNum, localName);
		
	}

	protected void reportParseException(SAXParseException e, int lineNum,
			int colNum, String localName) {
		Element elem = createErrorElement(e, lineNum, colNum);
		// FIXME: Ignoring namespaces for now since DITA doesn't use namespaces except
		// for foreign elements.
		Element child = this.validationReport.createElement("context");
		elem.appendChild(child);
		elem = child;
			
		child = this.validationReport.createElement(localName);
		elem.appendChild(child);
		Attributes atts = context.getAttributes();
		for (int i = 0; i < atts.getLength(); i++) {			
			child.setAttribute(atts.getLocalName(i), atts.getValue(i));
		}
		String chars = this.context.getCharacters();
		if (chars.length() > CONTENT_TRUNCATION_LENGTH)
			chars = chars.substring(0, CONTENT_TRUNCATION_LENGTH) + "...";
		child.setTextContent(chars);
		for (ParsingContext childContext : this.context.getChildren()) {
			Element subChild = this.validationReport.createElement(childContext.getLocalName());
			String content = childContext.getCharacters();
			if (content.length() > CONTENT_TRUNCATION_LENGTH)
				content = content.substring(0, CONTENT_TRUNCATION_LENGTH) + "...";
			subChild.setTextContent(content);
			child.appendChild(subChild);
		}
	}

	protected Element createErrorElement(SAXParseException e, int lineNum,
			int colNum) {
		Element elem = this.validationReport.createElement("error");
		elem.setAttribute("line", String.valueOf(lineNum));
		elem.setAttribute("col", String.valueOf(colNum));
		elem.setAttribute("message", e.getMessage());
		elem.setAttribute("docuri", e.getSystemId());
		this.currentElement.appendChild(elem);
		return elem;
	}

	public void fatalError(SAXParseException e) throws SAXException {
		int lineNum = context.getLineNumber();
		int colNum = context.getColumnNumber();
		if (lineNum < 1) lineNum = e.getLineNumber();
		if (colNum < 1) colNum = e.getColumnNumber();
		
		log.error(lineNum + ":" + colNum + " - " + e.getMessage());
		this.isValid = false;
		
		if (context.getLocalName() == null) {
			// Must be an error in the prolog
			Element elem = createErrorElement(e, lineNum, colNum);
			Element child = this.validationReport.createElement("context");
			elem.appendChild(child);
			elem = child;
			child = this.validationReport.createElement("errorInProlog");
			child.setTextContent("Error is before the root element start tag (in the document prolog) or after the end tag");
			elem.appendChild(child);
		} else {
			reportParseException(e, lineNum, colNum, context.getLocalName());
		}
		
	}

	public boolean isValid() {
		return this.isValid;
	}

	/**
	 * @return
	 */
	public Document getValidationReportDocument() {
		return this.validationReport;
	}

}

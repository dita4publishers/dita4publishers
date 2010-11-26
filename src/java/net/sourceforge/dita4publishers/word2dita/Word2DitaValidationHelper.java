/**
 * Copyright (c) 2010 DITA for Publishers. Licensed under Apache License 2. 
 * See license files for details.
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import net.sourceforge.dita4publishers.api.bos.BosMemberValidationException;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.util.DataUtil;
import net.sourceforge.dita4publishers.util.DomException;
import net.sourceforge.dita4publishers.util.DomUtil;
import net.sourceforge.dita4publishers.util.SaxUtil;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

/**
 * Helper class to validate the XML generated from Word and push
 * validation messages back into the Word document.
 */
public class Word2DitaValidationHelper {
	
    public static final String wNs = DocxConstants.nsByPrefix.get("w");

	public static SimpleDateFormat timestampFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH':'mm':'ssZ");

	public static final Log log = LogFactory.getLog(Word2DitaValidationHelper.class);


	/**
	 * @param zipComponents 
	 * @param logDoc
	 * @param documentDom
	 * @param commentsDom
	 * @param commentTemplate
	 * @throws XPathExpressionException
	 */
	static void addMessagesToDocxXml(Document logDoc, Document documentDom,
			Document commentsDom, Element commentTemplate)
			throws XPathExpressionException {
		NodeList messagesNl = logDoc.getDocumentElement().getElementsByTagName("message");
		
		for (int i = 0; i < messagesNl.getLength(); i++) {
			Element message = (Element)messagesNl.item(i);
			
			NodeList existingComments = commentsDom.getDocumentElement().getElementsByTagNameNS(wNs, "comment"); 
			String commentId = String.valueOf(existingComments.getLength());
			String messageText = message.getTextContent();
	
			addCommentToComments(commentsDom, commentTemplate, messageText,
					commentId);
	
			
			String xpath = message.getAttribute("wordParaXPath");
			// System.err.println("xpath=" + xpath);
			if (xpath == null || "".equals(xpath.trim())) {
				xpath = "/w:document/w:body[1]/w:p[1]";
			}
	
			addCommentRefToParaForXPath(documentDom, commentId, xpath);
				
		}
	}

	/**
	 * Given a set of validation messages and a DOCX file to which those messages apply, 
	 * creates a Word comment for each message, attached either to the paragraph the
	 * message points to (by XPath) or to the first paragraph of the document if there
	 * is not XPath for the message.
	 * @param docxFile The DOCX file to be updated.
	 * @param newDocxFile New DOCX file that will be a copy of the input DOCX with comments added.
	 * @param logDoc The messages document as a DOM.
	 * @throws ZipException
	 * @throws IOException
	 * @throws BosMemberValidationException
	 * @throws DomException
	 * @throws Exception
	 * @throws XPathExpressionException
	 * @throws FileNotFoundException
	 */
	public static void addValidationMessagesToDocxFile(File docxFile,
			File newDocxFile, Document logDoc) throws ZipException,
			IOException, BosMemberValidationException, DomException, Exception,
			XPathExpressionException, FileNotFoundException {
		String[] catalogs = new String[0];
		Document documentDom = null;
		Document commentsDom = null;
		
		Map<URI, Document> domCache = new HashMap<URI, Document>();
		BosConstructionOptions bosOptions = new BosConstructionOptions(log, domCache);
		bosOptions.setCatalogs(catalogs);
		
		ZipFile docxZip = new ZipFile(docxFile);
		ZipComponents zipComponents = new ZipComponents(docxZip);
	
		ZipComponent documentXml = zipComponents.getEntry(DocxConstants.DOCUMENT_XML_PATH);
		
		// Load comments template doc:
	
		URL commentsTemplateUrl = DocxConstants.class.getResource("resources/comments.xml");
		Element commentTemplate = Word2DitaValidationHelper.getCommentTemplate(commentsTemplateUrl, bosOptions);
		commentsDom = Word2DitaValidationHelper.getCommentsDom(bosOptions, zipComponents, commentsTemplateUrl);		
		
		documentDom = zipComponents.getDomForZipComponent(bosOptions, DocxConstants.DOCUMENT_XML_PATH);
		addMessagesToDocxXml(logDoc, documentDom, commentsDom, commentTemplate);
		Word2DitaValidationHelper.saveDomToZipComponent(documentDom, documentXml);	
		
		ZipComponent comments = zipComponents.getEntry(DocxConstants.COMMENTS_XML_PATH);
		if (comments == null) {
			comments = zipComponents.createZipComponent(DocxConstants.COMMENTS_XML_PATH);
		}
		// System.out.println("[1] Comments.xml: " + IOUtils.toString(DomUtil.serializeToInputStream(commentsDom)));
		Word2DitaValidationHelper.saveDomToZipComponent(commentsDom, zipComponents.getEntry(DocxConstants.COMMENTS_XML_PATH));	
		
		Word2DitaValidationHelper.addCommentFileRelationship(zipComponents, bosOptions);
		Word2DitaValidationHelper.addCommentFileContentType(zipComponents, bosOptions);
		
		Word2DitaValidationHelper.saveZipComponents(zipComponents, newDocxFile);
	}

	/**
	 * @return
	 * @throws IOException 
	 * @throws DomException 
	 * @throws BosMemberValidationException 
	 */
	static Element getCommentTemplate(URL commentsUrl, BosConstructionOptions bosOptions) throws IOException, BosMemberValidationException, DomException {
		InputSource commentsTemplateXmlSource = new InputSource(commentsUrl.openStream());			
		commentsTemplateXmlSource.setSystemId(DocxConstants.COMMENTS_XML_PATH);			
		Document commentsTemplateDom = DomUtil.getDomForSource(commentsTemplateXmlSource, bosOptions, false, false);
		NodeList comments = commentsTemplateDom.getDocumentElement()
		  .getElementsByTagNameNS(DocxConstants.nsByPrefix.get("w"), "comment");
		Element commentTemplate = (Element)comments.item(0);
		return commentTemplate;
	}

	/**
	 * @param bosOptions
	 * @param docxZip
	 * @param commentsTemplateUrl
	 * @return
	 * @throws Exception 
	 */
	static Document getCommentsDom(BosConstructionOptions bosOptions,
			ZipComponents zipComponents, URL commentsTemplateUrl)
			throws Exception {
		Document commentsDom;
		NodeList comments;
		ZipComponent commentsXml = zipComponents.getEntry(DocxConstants.COMMENTS_XML_PATH);
		if (commentsXml == null) {
			System.err.println("No comments.xml file");
			commentsXml = zipComponents.createZipComponent(DocxConstants.COMMENTS_XML_PATH);
			
			// Use the template as the base for new comments.xml DOM:
			InputSource templateSource = new InputSource(commentsTemplateUrl.openStream());
			templateSource.setSystemId(commentsTemplateUrl.toExternalForm());
			commentsDom = DomUtil.getDomForSource(templateSource, bosOptions, false, false);
			comments = commentsDom.getDocumentElement()
			   .getElementsByTagNameNS(DocxConstants.nsByPrefix.get("w"), "comment");
			
			// Remove any existing comments that were in the template:
			for (int i = 0; i < comments.getLength(); i++) {
				Element comment = (Element)comments.item(i);
				commentsDom.getDocumentElement().removeChild(comment);			
			}
			zipComponents.createZipComponent(DocxConstants.COMMENTS_XML_PATH, commentsDom);
			
		} else {
			commentsDom = zipComponents.getDomForZipComponent(bosOptions, DocxConstants.COMMENTS_XML_PATH);
		}
		return commentsDom;
	}

	/**
	 * @param doc
	 * @param zipComponent
	 * @throws IOException
	 * @throws Exception
	 */
	static void saveDomToZipComponent(Document doc,
			ZipComponent zipComponent) throws IOException, Exception {
		if (zipComponent == null) {
			throw new IOException("zipComponent is null");
		}
		zipComponent.setDom(doc);
	}

	/**
	 * @param commentsDom
	 * @param commentTemplate
	 * @param messageText
	 * @param commentId
	 */
	static void addCommentToComments(Document commentsDom,
			Element commentTemplate, String messageText, String commentId) {
		Element comment = (Element)commentsDom.importNode(commentTemplate, true);
		commentsDom.getDocumentElement().appendChild(comment);
		comment.setAttributeNS(wNs, "w:id", commentId);
		comment.setAttributeNS(wNs, "w:author", "XML Validator");
		comment.setAttributeNS(wNs, "w:initials", "XMLVal");
		comment.setAttributeNS(wNs, "w:date", timestampFormatter.format(Calendar.getInstance().getTime()));
		Element elem = DataUtil.getElementNS(comment, wNs, "p");
		NodeList nl = elem.getElementsByTagNameNS(wNs, "r");
		elem = (Element)nl.item(nl.getLength() - 1);
		Element text = DataUtil.getElementNS(elem, wNs, "t");
		text.setTextContent(messageText);
	}

	/**
	 * @param documentDom
	 * @param xpath
	 * @return
	 * @throws XPathExpressionException
	 */
	static Node getWordParaForXPath(Document documentDom, String xpath)
			throws XPathExpressionException {
		XPathFactory xpathFactory = DomUtil.getXPathFactory();
		XPath xpathObj = xpathFactory.newXPath();
		xpathObj.setNamespaceContext(DocxConstants.docxNamespaceContext);
		Object result = xpathObj.evaluate(xpath, documentDom, XPathConstants.NODE);
		Node node = null;
		if(result!=null) {
			 node = (Node) result;
			
		}
		return node;
	}

	/**
	 * @param documentDom
	 * @param commentId
	 * @param xpath
	 * @throws XPathExpressionException
	 */
	static void addCommentRefToParaForXPath(Document documentDom,
			String commentId, String xpath) throws XPathExpressionException {
		/**
	  <w:r>
	    <w:rPr>
	      <w:rStyle
	        w:val="CommentReference"/>
	    </w:rPr>
	    <w:commentReference
	      w:id="14"/>
	  </w:r>
		 
		 */
		Node node = getWordParaForXPath(documentDom, xpath);
		
		Element p = (Element)node;
		Element commentRef = documentDom.createElementNS(wNs, "w:r");
		Element elem = (Element)commentRef.appendChild(documentDom.createElementNS(wNs, "w:rPr"));
		elem = (Element)elem.appendChild(documentDom.createElementNS(wNs, "w:rStyle"));
		elem.setAttributeNS(wNs, "w:val", "CommentReference");
		elem = (Element)commentRef.appendChild(documentDom.createElementNS(wNs, "w:commentReference"));
		elem.setAttributeNS(wNs, "w:id", commentId);
		p.appendChild(commentRef);
	}

	/**
	 * @param pkg
	 * @param bosOptions
	 * @throws Exception 
	 */
	static void addCommentFileRelationship(ZipComponents zipComponents,
			BosConstructionOptions bosOptions) throws Exception {
		ZipComponent comp = zipComponents.getEntry(DocxConstants.DOCUMENT_XML_RELS_PATH);
		Document doc = zipComponents.getDomForZipComponent(bosOptions, comp);
		Element docElem = doc.getDocumentElement();
		NodeList nl = docElem.getElementsByTagNameNS(DocxConstants.RELS_NS, "Relationship");
		boolean foundCommentRel = false;
		for (int i =0; i < nl.getLength(); i++) {
			Element elem = (Element)nl.item(i);
			String type = elem.getAttribute("Type");
			if (DocxConstants.COMMENT_REL_TYPE.equals(type)) {
				foundCommentRel = true;
				break;
			}
		}
		if (!foundCommentRel) {
			Element elem = doc.createElementNS(DocxConstants.RELS_NS, "Relationship");
			elem.setAttribute("Type", DocxConstants.COMMENT_REL_TYPE);
			elem.setAttribute("Id", "rId" + (nl.getLength() + 1));
			elem.setAttribute("Target", "comments.xml");
			docElem.appendChild(elem);
			// System.out.println(IOUtils.toString(DomUtil.serializeToInputStream(doc, "utf-8")));
	        comp.setDom(doc);
		}
		
		
	}

	/**
	 * Validates an XML document, capturing the messages into an XML document that includes
	 * any @xtrc values pointing back into the original DOCX file from which the XML was
	 * generated. The resulting document can be used to then annotate the original DOCX
	 * file with messages bound to the original source paragraphs.
	 * @param messageFile The file to hold the XML message log.
	 * @param inputUrl The URL of the document to be validated.
	 * @param catalogs List of entity resolution catalogs to be used by the parser (as for the Resolver class).
	 * @return DOM document containing the log messages. Also saves the messages to the specified file.
	 * @throws IOException
	 * @throws ParserConfigurationException
	 * @throws Exception
	 * @throws SAXException
	 * @throws FileNotFoundException
	 */
	public static Document validateXml(File messageFile, URL inputUrl, String[] catalogs)
			throws IOException, ParserConfigurationException, Exception,
			SAXException, FileNotFoundException {
		InputSource source = new InputSource(inputUrl.openStream());
		Document logDoc = DomUtil.getNewDom();
		XMLReader reader = SaxUtil.getXMLFormatLoggingXMLReader(log, logDoc, true, catalogs);
		reader.parse(source);
		InputStream logStream = DomUtil.serializeToInputStream(logDoc, "utf-8");
		System.out.println("Creating message file \"" + messageFile.getAbsolutePath() + "\"...");
		OutputStream fos = new FileOutputStream(messageFile);
		IOUtils.copy(logStream, fos);
		return logDoc;
	}

	/**
	 * @param zipComponents
	 * @param bosOptions
	 * @throws Exception 
	 */
	public static void addCommentFileContentType(ZipComponents zipComponents,
			BosConstructionOptions bosOptions) throws Exception {
	
		/*
		 *   <Override
	PartName="/word/comments.xml"
	ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.comments+xml"/>
	
		 */
		
		ZipComponent comp = zipComponents.getEntry("[Content_Types].xml");
		Document doc = zipComponents.getDomForZipComponent(bosOptions, comp);
		Element docElem = doc.getDocumentElement();
		String contentTypesNs = "http://schemas.openxmlformats.org/package/2006/content-types";
		NodeList nl = docElem.getElementsByTagNameNS(contentTypesNs, "Override");
		boolean foundCommentType = false;
		for (int i =0; i < nl.getLength(); i++) {
			Element elem = (Element)nl.item(i);
			String partName = elem.getAttribute("PartName");
			if (DocxConstants.COMMENTS_PARTNAME.equals(partName)) {
				foundCommentType = true;
				break;
			}
		}
		if (!foundCommentType) {
			Element elem = doc.createElementNS(contentTypesNs, "Override");
			elem.setAttribute("PartName", DocxConstants.COMMENTS_PARTNAME);
			elem.setAttribute("ContentType", DocxConstants.COMMENTS_CONTENT_TYPE);
			docElem.appendChild(elem);
	        comp.setDom(doc);
		}
	}

	/**
	 * @param documentDom
	 * @param commentsDom
	 * @param docxZip
	 * @param zipFile
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws Exception
	 */
	public static void saveZipComponents(ZipComponents zipComponents, File zipFile) throws FileNotFoundException,
			IOException, Exception {
		ZipOutputStream zipOutStream = new ZipOutputStream(new FileOutputStream(zipFile));		
		for (ZipComponent comp : zipComponents.getComponents()) {
			ZipEntry newEntry = new ZipEntry(comp.getName());
			zipOutStream.putNextEntry(newEntry);
			if (comp.isDirectory()) {
				// Nothing to do.
			} else {
				// System.out.println(" + [DEBUG] saving component \"" + comp.getName() + "\"");
				if (comp.getName().endsWith("document.xml") || comp.getName().endsWith("document.xml.rels")) {
					// System.out.println("Handling a file of interest.");
				}
				InputStream inputStream = comp.getInputStream();
				IOUtils.copy(inputStream, zipOutStream);
				inputStream.close();
			}
		}		
		zipOutStream.close();
	}

}

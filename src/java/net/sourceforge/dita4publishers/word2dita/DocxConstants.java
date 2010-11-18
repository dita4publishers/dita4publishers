/**
 * 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.NamespaceContext;


/**
 * Constants for DOCX documents.
 */
public class DocxConstants {

	public static final NamespaceContext docxNamespaceContext = new DocxNamespaceContext();

	public static final Map<String, String> nsByPrefix = new HashMap<String, String>();
	public static final Map<String, String> prefixByUri = new HashMap<String, String>();
	
	static {
		      nsByPrefix.put("mo","http://schemas.microsoft.com/office/mac/office/2008/main");
			  nsByPrefix.put("ve","http://schemas.openxmlformats.org/markup-compatibility/2006");
			  nsByPrefix.put("mv","urn:schemas-microsoft-com:mac:vml");
			  nsByPrefix.put("o","urn:schemas-microsoft-com:office:office");
			  nsByPrefix.put("r","http://schemas.openxmlformats.org/officeDocument/2006/relationships");
			  nsByPrefix.put("m","http://schemas.openxmlformats.org/officeDocument/2006/math");
			  nsByPrefix.put("v","urn:schemas-microsoft-com:vml");
			  nsByPrefix.put("wp","http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing");
			  nsByPrefix.put("w10","urn:schemas-microsoft-com:office:word");
			  nsByPrefix.put("w","http://schemas.openxmlformats.org/wordprocessingml/2006/main");
			  nsByPrefix.put("wne","http://schemas.microsoft.com/office/word/2006/wordml");
			  
			  prefixByUri.put("http://schemas.microsoft.com/office/mac/office/2008/main","mo");
			  prefixByUri.put("http://schemas.openxmlformats.org/markup-compatibility/2006","ve");
			  prefixByUri.put("urn:schemas-microsoft-com:mac:vml","mv");
			  prefixByUri.put("urn:schemas-microsoft-com:office:office","o");
			  prefixByUri.put("http://schemas.openxmlformats.org/officeDocument/2006/relationships","r");
			  prefixByUri.put("http://schemas.openxmlformats.org/officeDocument/2006/math","m");
			  prefixByUri.put("urn:schemas-microsoft-com:vml","v");
			  prefixByUri.put("http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing","wp");
			  prefixByUri.put("urn:schemas-microsoft-com:office:word","w10");
			  prefixByUri.put("http://schemas.openxmlformats.org/wordprocessingml/2006/main","w");
			  prefixByUri.put("http://schemas.microsoft.com/office/word/2006/wordml","wne");

	}

	/**
	 * 
	 */
	public static final String DOCUMENT_XML_PATH = "word/document.xml";

	/**
	 * 
	 */
	public static final String COMMENTS_XML_PATH = "word/comments.xml";

}

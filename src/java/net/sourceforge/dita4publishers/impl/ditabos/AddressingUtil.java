package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Map;

import net.sourceforge.dita4publishers.api.ditabos.AddressingException;
import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosMemberValidationException;

import org.apache.commons.io.FilenameUtils;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;


/**
 * Utilities for doing address resolution and management.
 * 
 * Holds the knowledge of how to resolve particular addressing elements or attributes
 * to their targets.
 * 
 * FIXME: Not sure this is the best way to organize this functionality. WEK.
 */
public class AddressingUtil {

	static Logger logger = Logger.getLogger(AddressingUtil.class);

    /**
	 * Resolves the href= attribute of an XInclude <include> element to
	 * it's target file.
	 * @param elem
	 * @return
	 */
	public static File getHrefTargetDocument(Element elem, File baseFile) throws AddressingException {
		if (!elem.hasAttribute("href")) {
			return baseFile;
		}
		String fileUrlStr = elem.getAttribute("href");
        return getFileForUrlString(baseFile, fileUrlStr);
	}

    private static File getFileForUrlString(File baseFile, String fileUrlStr)
        throws AddressingException {
        File resultFile = null;
        try {
        	URL baseUrl = baseFile.toURL();
        	URL targetUrl = new URL(baseUrl, fileUrlStr);
        	resultFile = new File(targetUrl.getFile());
        } catch (Throwable e) {
        	throw new AddressingException("href value failure for href '" + fileUrlStr + "'", e);			
        }
        return resultFile;
    }

	/**
	 * Constructs an XPath to an element.
	 * 
	 * Assumes that attributes named "id" are ID-type attributes.
	 * @param inElem
	 * @return
	 */
	public static String constructXPathForElement(Element inElem) {
		return constructXPathForElement(inElem, "");
	}
	
	public static String constructXPathForElement(Element inElem, String xPathRest) {		
		// Start at the node, walk up its ancestry. 
		// NOTE: We are using qualified names to make sure we have appropriate
		// namespace prefixes. These prefixes are specific to the original
		// document content in which the element exists and can only be
		// reliably resolved in that context.
		String xpathPart = "/" + inElem.getNodeName();
		if (inElem.hasAttribute("id")) {
			xpathPart = "/" + xpathPart + "[@id = '" + inElem.getAttribute("id") + "']";
		} else {
			xpathPart +=  "[" + countPrecedingSiblingsOfType(inElem) + "]";
			if (inElem.getParentNode() != null) {
				if (inElem.getParentNode().getNodeType() == Node.ELEMENT_NODE) {
					return constructXPathForElement((Element)(inElem.getParentNode()), xpathPart + xPathRest);					
				}
			}
		}
		return xpathPart + xPathRest;
	}

    /**
     * @param inElem
     * @return
     */
    private static int countPrecedingSiblingsOfType(Element inElem) {
        int cnt = 1; // Elements are 1-indexed in XPath
        Node node = inElem.getPreviousSibling();
        String typeName = inElem.getNodeName();
        while (node != null) {
        	while (node.getNodeType() != Node.ELEMENT_NODE) {
        		node = node.getPreviousSibling();
        		if (node == null) {
        			break;
        		}
        	}
        	if (node != null) {
        		if (((Element)node).getNodeName().equals(typeName)) {
        			cnt++;
        		}
				node = node.getPreviousSibling();
        	} 
        }
        return cnt;
    }
    
	/**
	 * @param topicRef
	 * @param href
	 * @return
	 * @throws URISyntaxException 
	 * @throws IOException 
	 * @throws DomException 
	 * @throws MalformedURLException 
	 */
	public static File resolveHrefToFile(Element topicRef, String href, boolean failOnAddressResolutionFailure)
			throws AddressingException {
				File targetFile = null;
				if (href.startsWith("#"))
					return new File(topicRef.getOwnerDocument().getDocumentURI());
				String baseUriStr = topicRef.getOwnerDocument().getBaseURI();
				try {
					if (href.contains("#"))
						href = href.substring(0,href.indexOf("#"));
					URI baseUri = new URI(baseUriStr);
					URI targetUri = baseUri.resolve(href);
					targetFile = new File(targetUri);
				} catch (Exception e) {
					if (failOnAddressResolutionFailure) {
						throw new AddressingException("Failed to resolve href \"" + href + "\": " + e.getClass().getSimpleName() + ": " + e.getMessage());
					}
				}
				return targetFile;
			}


	/**
	 * @param refElem
	 * @param href
	 * @return
	 * @throws BosException 
	 * @throws URISyntaxException 
	 * @throws IOException 
	 * @throws DomException 
	 * @throws MalformedURLException 
	 */
	public static Document resolveHrefToDoc(Element refElem, String href, BosConstructionOptions domOptions, boolean failOnAddressResolutionFailure)
			throws AddressingException {
				Document targetDoc = null;
				if (href.startsWith("#"))
					return refElem.getOwnerDocument();
				String baseUriStr = refElem.getOwnerDocument().getBaseURI();
				try {
					URI baseUri = new URI(baseUriStr);
					URI targetUri = baseUri.resolve(href);
					Map<URI, Document>domCache = domOptions.getDomCache();
					if (domCache.containsKey(targetUri))
						return domCache.get(targetUri);
					try {
						targetDoc = DomUtil.getDomForUri(targetUri, domOptions);
					} catch (DomException e) {
						throw new AddressingException("Parsing error for document " + targetUri.toString() + ": " + e.getMessage());
					} catch (BosMemberValidationException e) {
						throw new AddressingException("Validation error for document " + targetUri.toString() + ": " + e.getMessage());
					}
					domCache.put(targetUri, targetDoc);
				} catch (IOException e) {
					if (failOnAddressResolutionFailure) {
						throw new AddressingException("Failed to resolve href \"" + href + "\": " + e.getClass().getSimpleName() + ": " + e.getMessage());
					}
				} catch (URISyntaxException e) {
					if (failOnAddressResolutionFailure) {
						throw new AddressingException("Failed to resolve href \"" + href + "\": " + e.getClass().getSimpleName() + ": " + e.getMessage());
					}
				}
				return targetDoc;
			}

	/**
	 * Resolves the @data attribute of an object element to its resource, if @data
	 * is specified and the absolute URL of the object is relative to the URL of
	 * the referencing element.
	 * @param objectElem
	 * @param failOnAddressResolutionFailure
	 * @return
	 * @throws AddressingException 
	 */
	public static File resolveObjectDataToFile(Element objectElem,
			boolean failOnAddressResolutionFailure) throws AddressingException {
		if (!objectElem.hasAttribute("data"))
			return null;
		
		File result = null;

		String dataUrlStr = objectElem.getAttribute("data");
		String baseUrlStr = objectElem.getOwnerDocument().getBaseURI();
		if (objectElem.hasAttribute("codebase")) {
			baseUrlStr = objectElem.getAttribute("codebase");
		}
		URL baseUrl = null;
		try {			
			
			baseUrl = new URL(baseUrlStr);
			// If baseUrl appears to point to a file, get its parent.
			if (!baseUrlStr.endsWith("/")) {
				String ext = FilenameUtils.getExtension(baseUrl.getPath());
				if (ext == null || "".equals(ext.trim())) {
					baseUrl = new URL(baseUrlStr + "/foo.garbage");
				}
			}
			
		} catch (MalformedURLException e) {
			throw new AddressingException("Malformed URL: " + baseUrlStr, e);
		} 
		
		URL dataUrl;
		try {
			// NOTE: URL(base, rest) always strips the last path component off the baseUrl.
			dataUrl = new URL(baseUrl, dataUrlStr);
		} catch (MalformedURLException e) {
			throw new AddressingException("Malformed URL: " + dataUrlStr, e);
		}
		
		try {
			URI data = dataUrl.toURI();
			URI base = getParent(baseUrl.toURI());
			URI relative = base.relativize(data);
			if (relative.isAbsolute())
				return null; // Not relative to the base URI, not a local/peer resource.
		} catch (URISyntaxException e) {
			throw new AddressingException("URI syntax exception: " + e.getMessage(), e);
		}
		
		result = new File(dataUrl.getFile());
		
		if (failOnAddressResolutionFailure && !result.exists()) {
			throw new AddressingException("Failed to resolve @data value \"" + dataUrlStr + " to a file using absolute URL \"" + dataUrl.toExternalForm() + "\"");
		}
		
		return result;
	}
	
	public static URI getParent(URI uri) throws URISyntaxException {

        String parentPath = new File(uri.getPath()).getParent();

        if(parentPath == null) {
            return new URI("../");
        }

        return new URI(uri.getScheme(), uri.getUserInfo(), uri.getHost(), uri.getPort(), parentPath.replace('\\', '/'), uri.getQuery(), uri.getFragment());
    }


}

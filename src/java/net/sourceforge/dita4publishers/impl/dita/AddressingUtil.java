package net.sourceforge.dita4publishers.impl.dita;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.JarURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Map;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMemberValidationException;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.util.DitaUtil;
import net.sourceforge.dita4publishers.util.DomException;
import net.sourceforge.dita4publishers.util.DomUtil;

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
	 * @throws URISyntaxException 
	 * @throws IOException 
	 * @throws DomException 
	 * @throws MalformedURLException 
	 */
	public static URI resolveHrefToUri(Element topicRef, String href, boolean failOnAddressResolutionFailure)
			throws AddressingException {
				URI targetUri = null;
				if (href.startsWith("#"))
					try {
						return new URI(topicRef.getOwnerDocument().getDocumentURI());
					} catch (URISyntaxException e) {
						throw new AddressingException("URISyntaxException from document URI \"" + topicRef.getOwnerDocument().getDocumentURI() + "\": " + e.getMessage(), e);
					}
				String baseUriStr = topicRef.getOwnerDocument().getBaseURI();
				try {
					if (href.contains("#"))
						href = href.substring(0,href.indexOf("#"));
					URI baseUri = new URI(baseUriStr);
					targetUri = resolveUri(baseUri, href);
				} catch (Exception e) {
					if (failOnAddressResolutionFailure) {
						throw new AddressingException("Failed to resolve href \"" + href + "\": " + e.getClass().getSimpleName() + ": " + e.getMessage());
					}
				}
				return targetUri;
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
				String resourceUriStr = null;
				if (href.contains("#"))
					resourceUriStr = href.substring(0,href.indexOf("#"));
				else
					resourceUriStr = href;
				if (resourceUriStr.contains("\\")) {
					logger.warn("Found href value with backslashes: \"" + resourceUriStr + "\". Converting to '/', may still not work.");
					resourceUriStr = resourceUriStr.replace("\\", "/");
				}
				try {
					URI baseUri = AddressingUtil.getParent(new URI(baseUriStr));
					
					URI targetUri = resolveUri(baseUri, resourceUriStr);
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

	public static URI resolveUri(URI baseUri, String resourceUriStr)
			throws URISyntaxException, MalformedURLException {
		URI targetUri = null;
		if (baseUri.toString().startsWith("jar:")) {
			URI temp = new URI(resourceUriStr);
			if (temp.isAbsolute()) {
				targetUri = temp;
			} else {
				URL targetUrl = new URL(baseUri.toURL(), resourceUriStr);
				targetUri = targetUrl.toURI();
			}
		} else {
			targetUri = baseUri.resolve(resourceUriStr);
		}
		return targetUri;
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
	public static URI resolveObjectDataToUri(Element objectElem,
			boolean failOnAddressResolutionFailure) throws AddressingException {
		if (!objectElem.hasAttribute("data"))
			return null;
		
		URI result = null;

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
		} catch (MalformedURLException e) {
			throw new AddressingException("Malformed URL exception: " + e.getMessage(), e);
		} catch (IOException e) {
			throw new AddressingException("IO exception: " + e.getMessage(), e);
		}
		
		boolean exists = true;
		URLConnection connection = null;
		InputStream stream = null;
		try {			
		    connection = dataUrl.openConnection();
		    connection.setConnectTimeout(1);
		    connection.setReadTimeout(1);
			stream = connection.getInputStream();
		} catch (IOException e) {
			logger.debug("resolveObjectDataToUri(): IOException openning connection to URL \"" + dataUrl + "\"");
			exists = false;
		} catch (Exception e) {
			logger.info("Unexpected exception: " + e.getClass().getSimpleName() + " = " + e.getMessage());
			exists = false;
		} finally {
			try {
				stream.close();
			} catch (IOException e) {
				// Don't care.
			}
		}
		
		if (failOnAddressResolutionFailure && !exists) {
			throw new AddressingException("Failed to resolve @data value \"" + dataUrlStr + " to an accessible resource using absolute URL \"" + dataUrl.toExternalForm() + "\"");
		}
		
		return result;
	}
	
	/**
	 * Gets the URI of the directory that contains the resource. 
	 * @param uri URI to get the parent of.
	 * @return URI of the parent. Note that the path always ends in "/".
	 * @throws URISyntaxException
	 * @throws IOException 
	 * @throws MalformedURLException 
	 */
	public static URI getParent(URI uri) throws URISyntaxException, MalformedURLException, IOException {
		
		if (uri.toString().startsWith("jar:")) {
			JarURLConnection jarConn = (JarURLConnection)(uri.toURL().openConnection());
			String entryName = jarConn.getEntryName();
			String parentPath = "";

			if (entryName != null) {
				parentPath = (new File(entryName)).getParent();				
			}
			String jarUrlStr = "jar:" + jarConn.getJarFileURL().toExternalForm() + "!/";
			URL jarUrl = new URL(jarUrlStr);
			URL parentUrl = null;
			if (parentPath != null)
				parentUrl = new URL(jarUrl, parentPath + "/");
			else 
				parentUrl = jarUrl;
			return parentUrl.toURI();
			
		} else {		
			String parentPath = null;
			File baseFile = null;
			String path = uri.getPath();
			if (path != null) {
				baseFile = new File(path);
			} else {
				throw new RuntimeException("getPath() on URI \"" + uri + "\" returned null"); 
			}
	        parentPath = baseFile.getParent();
	        if(parentPath == null) {
	            return new URI("../");
	        }
	        if (!"/".equals(parentPath)) {
	        	parentPath += "/";
	        }

	        return new URI(uri.getScheme(), uri.getUserInfo(), uri.getHost(), uri.getPort(), parentPath.replace('\\', '/'), uri.getQuery(), uri.getFragment());
		}


    }

	/**
	 * Finds the relative path from the baseUri to the target URI.
	 * @param targetUri The URI of the resource to get the relative path to.
	 * @param baseUri URI of the directory the path should be relative to. 
	 * @return
	 */
	 public static String getRelativePath(URI targetUri, URI baseUri) {
	
		 //  We need the -1 argument to split to make sure we get a trailing 
		 //  "" token if the base ends in the path separator and is therefore
		 //  a directory. We require directory paths to end in the path
		 //  separator -- otherwise they are indistinguishable from files.
		 String pathSeparator = "/";
		 String targetPath = targetUri.getPath();
		 String[] base; 
		 String[] target;
		 if (baseUri.toString().startsWith("jar:")) {
			 try {
				JarURLConnection conn = (JarURLConnection)(baseUri.toURL().openConnection());
				String entryName = conn.getEntryName();
				if (entryName == null)
					entryName = pathSeparator;
				base = entryName.split(pathSeparator);
				if (!targetUri.toString().startsWith("jar:")) {
					throw new RuntimeException("Base URI is a jar URI but target URI is not, got \"" + targetUri.toString() + "\"");
				}
				conn = (JarURLConnection)(targetUri.toURL().openConnection());
				entryName = conn.getEntryName();
				if (entryName == null)
					entryName = pathSeparator;
				targetPath = entryName;
				target = conn.getEntryName().split(pathSeparator);
			} catch (Exception e) {
				throw new RuntimeException("Unexpected exception from jar: URL: " + e.getMessage());
			}
			 
		 } else {
			 base = baseUri.getPath().split(pathSeparator);
			 target = targetPath.split(pathSeparator);
		 }
		
		 //  First get all the common elements. Store them as a string,
		 //  and also count how many of them there are. 
		 String common = "";
		 int commonIndex = 0;
		 for (int i = 0; i < target.length && i < base.length; i++) {
		     if (target[i].equals(base[i])) {
		         common += target[i] + pathSeparator;
		         commonIndex++;
		     }
		     else break;
		 }
		
		 if (commonIndex == 0)
		 {
		     //  Whoops -- not even a single common path element. This most
		     //  likely indicates differing drive letters, like C: and D:. 
		     //  These paths cannot be relativized. Return the target path.
		     return targetPath;
		 }
		
		 String relative = "";
		 if (base.length == commonIndex) {
			 // Do nothing.
		 }
		 else {
		     int numDirsUp = base.length - commonIndex; 
		     //  The number of directories we have to backtrack is the length of 
		     //  the base path MINUS the number of common path elements, minus
		     //  one because the last element in the path isn't a directory.
		     for (int i = 1; i <= (numDirsUp); i++) {
		         relative += ".." + pathSeparator;
		     }
		 }
		 //if we are comparing directories then we 
		 if (targetPath.length() > common.length()) {
		  //it's OK, it isn't a directory
		  relative += targetPath.substring(common.length());
		 }
		
		 return relative;
	 }

	/**
	 * @param keyrefElem
	 * @return Key name part of a key reference value.
	 */
	public static String getKeyNameFromKeyref(Element keyrefElem) {
		String keyName = keyrefElem.getAttribute(DitaUtil.DITA_KEYREF_ATTNAME);
		if (keyName.contains("/")) {
			String[] parts = keyName.split("/");
			keyName = parts[0];
		}
		return keyName;
	}

 
}

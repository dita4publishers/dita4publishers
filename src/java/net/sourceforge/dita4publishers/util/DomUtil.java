package net.sourceforge.dita4publishers.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Collection;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeSet;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import net.sourceforge.dita4publishers.api.bos.BosMemberValidationException;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;

import org.apache.log4j.Logger;
import org.apache.xerces.jaxp.DocumentBuilderFactoryImpl;
import org.apache.xerces.parsers.DOMParser;
import org.apache.xerces.parsers.XIncludeAwareParserConfiguration;
import org.apache.xerces.util.XMLCatalogResolver;
import org.apache.xerces.xni.grammars.XMLGrammarPool;
import org.apache.xerces.xni.parser.XMLParserConfiguration;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentType;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;


/**
 * Utilities for constructing W3C DOMs.
 */
public class DomUtil {

	static Logger logger = Logger.getLogger(DomUtil.class);
	

	/**
	 * Constructs a DOM from the specified XML document file.
	 * @param xmlFile Document entity of the file to load.
	 * @param throwExceptionIfInvalid 
	 * @return The DOM Document object for the document.
	 * @throws DomException
	 * @throws FileNotFoundException 
	 * @throws BosMemberValidationException 
	 */
	public static Document getDomForDocument(File xmlFile, BosConstructionOptions domOptions, boolean throwExceptionIfInvalid) throws DomException, FileNotFoundException, BosMemberValidationException {
		InputSource source = new InputSource(new FileInputStream(xmlFile));
		source.setSystemId(xmlFile.toURI().toString());
		return getDomForSource(source, domOptions, throwExceptionIfInvalid);
	}

	public static Document getDomForDocument(File xmlFile, BosConstructionOptions domOptions) throws DomException, FileNotFoundException, BosMemberValidationException {
		return getDomForDocument(xmlFile, domOptions, false);
	}

	/**
	 * Constructs a DOM from the specified XML document file.
	 * @param xmlResource Document entity of the file to load.
	 * @param bosOptions
	 * @return The DOM Document object for the document.
	 * @throws DomException
	 * @throws IOException 
	 * @throws MalformedURLException 
	 * @throws BosMemberValidationException 
	 * @throws FileNotFoundException 
	 */
	public static Document getDomForUri(URI xmlResource, BosConstructionOptions bosOptions) throws DomException, MalformedURLException, IOException, BosMemberValidationException {
		InputSource source = new InputSource(xmlResource.toURL().openStream());
		source.setSystemId(xmlResource.toString());
		return getDomForSource(source, bosOptions, false);
	}

	/**
	 * Constructs a DOM from the specified XML document file.
	 * @param stream InputStream containing the document data to be parsed.
	 * @param bosOptions
	 * @return The DOM Document object for the document.
	 * @throws DomException
	 * @throws BosMemberValidationException 
	 */
	public static Document getDomForStream(InputStream stream, BosConstructionOptions bosOptions) throws DomException, BosMemberValidationException {
		return getDomForSource(new InputSource(stream), bosOptions, false);
	}

	/**
	 * Constructs a DOM from the specified XML document file.
	 * @param throwExceptionIfInvalid 
	 * @param source InputSource containing the data to be parsed.
	 * @param bosOptions
	 * @return The DOM Document object for the document.
	 * @throws DomException
	 * @throws BosMemberValidationException 
	 */
	public static Document getDomForSource(InputSource source, BosConstructionOptions bosOptions, boolean throwExceptionIfInvalid) throws DomException, BosMemberValidationException {
		URI docUri = null;
		try {
			docUri = new URI(source.getSystemId());
		} catch (URISyntaxException e) {
			throw new DomException("Exception constructing URI from system ID \"" + source.getSystemId() + "\" for document source: " + e.getMessage(), e);
		}
		
		if (bosOptions.getDomCache().containsKey(docUri)) {
			logger.debug("getDomForSource(): Found DOM for \"" + source.getSystemId() + "\" in DOM cache, returning it.");
			return bosOptions.getDomCache().get(docUri);
		}
		
		logger.debug("getDomForSource(): Parsing input source \"" + source.getSystemId() + "\"...");
		
		XMLCatalogResolver resolver = new XMLCatalogResolver();
		String[] catalogs = bosOptions.getCatalogs();
		String catalogList = System.getProperty("xml.catalog.files");
		if (catalogList != null && !"".equals(catalogList)) {
			StringTokenizer  tokens = new StringTokenizer(catalogList, ";");
			if (tokens.hasMoreTokens()) {
				catalogs = new String[tokens.countTokens()];
				int i = 0;
				while (tokens.hasMoreTokens()) {
					catalogs[i++] = tokens.nextToken();
				}
			}
		}
		
		XMLGrammarPool grammarPool = bosOptions.getGrammarPool();
		
		if (grammarPool == null) {
			grammarPool = GrammarPoolManager.getGrammarPool();
		}
		

		resolver.setCatalogList(catalogs);
		DOMParser dp = null;
		try {
			XMLParserConfiguration config = new XIncludeAwareParserConfiguration();
			config.setProperty("http://apache.org/xml/properties/internal/grammar-pool",
			    grammarPool);
			dp = new org.apache.xerces.parsers.DOMParser(config);
			dp.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", true);
			dp.setFeature("http://apache.org/xml/features/dom/defer-node-expansion", false);
			dp.setFeature("http://xml.org/sax/features/validation", true);
			dp.setProperty("http://apache.org/xml/properties/internal/entity-resolver", resolver);
			dp.parse(source);
		} catch (Exception e) {
			try {
				bosOptions.registerInvalidDocument(source.getSystemId());
				if (throwExceptionIfInvalid) {
					throw new BosMemberValidationException("BOS member is not valid: " + source.getSystemId());
				}
			} catch (URISyntaxException e1) {
				throw new RuntimeException("Unexpected URI syntax exception from system ID \"" + source.getSystemId() + "\": " + e1.getMessage());
			}
			throw new DomException(e);
		} finally {		
//			if (errorHandler.getGotError())
//				try {
//					domOptions.registerInvalidDocument(source.getSystemId());
//					if (throwExceptionIfInvalid) {
//						throw new BosMemberValidationException(0, "BOS member is not valid: " + source.getSystemId());
//					}
//				} catch (URISyntaxException e1) {
//					throw new RuntimeException("Unexpected URI syntax exception from system ID \"" + source.getSystemId() + "\": " + e1.getMessage());
//				}
		}
		
		Document doc = dp.getDocument();
		logger.debug("getDomForSource(): Adding document \"" + docUri.toString() + "\" to DOM cache.");
		bosOptions.getDomCache().put(docUri, doc);
		logger.debug("getDomForSource(): Returning DOM for document \"" + source.getSystemId() + "\"");
		return doc;
	}
	
    /**
     * Given an element node and a namespace URI, returns the local prefix associated with that
     * namespace (that is, the nearest ancestor or self element that declares the namespace).
     * @param element The element to check.
     * @param nsURI The URI of the namespace whose prefix you want.
     * @return Returns the prefix or null if the namespace is not declared.
     */
    public static String getNamespacePrefix(Element element, String nsURI) {
    	NamedNodeMap atts = element.getAttributes();
    	for (int i = 0; i < atts.getLength(); i++) {
    		Attr att = (Attr)(atts.item(i));
    		String prefix = att.getPrefix();
    		if (prefix != null && prefix.equals("xmlns")) {
    			if (att.getValue().equals(nsURI)) {
    				return att.getLocalName();
    			}
    		}
    	}
        return null;
    }

	/**
	 * Given an element, returns the list of all unique namespace URIs used in the element
	 * tree rooted at that element.
	 * @param elem Element to calculate the namespaces used.
	 */
	public static Collection<String> getDocumentNamespaces(Element elem) {
		Set<String> namespaces = new TreeSet<String>();
		getSubtreeNamespaces(elem, namespaces);
		return namespaces;
	}


	/**
	 * Recursive method to get all the namespaces within a subtree of elements.
	 * @param elem
	 * @param namespaces
	 */
	public static void getSubtreeNamespaces(Element elem, Set<String> namespaces) {
		DomUtil.getElementNamespaces(elem, namespaces);
		if (elem.hasChildNodes()) {
			NodeList childs = elem.getChildNodes();
			for (int i = 0; i < childs.getLength(); i++) {
				Node child = childs.item(i);
				if (child.getNodeType() == Node.ELEMENT_NODE) {
					getSubtreeNamespaces((Element)child, namespaces);
				}
			}
		}
	}
	
    /**
     * Gets the namespaces declared on the element and adds them to the specified set.
     * @param element The element to examine.
     * @param namespaces A set to which new namespace URIs will be added.
     */
    public static void getElementNamespaces(Element element, Set<String> namespaces) {
		NamedNodeMap atts = element.getAttributes();
		for (int i = 0; i < atts.getLength(); i++) {
			Attr att = (Attr)(atts.item(i));
			String prefix = att.getPrefix();
			if (prefix != null && prefix.equals("xmlns")) {
				String nsURI = att.getValue();
				namespaces.add(nsURI);					
			} else {
				if (att.getName().equals("xmlns")) {
					namespaces.add(att.getValue());
				}
			}
		}        
    }

    /**
     * Given a schemaLocation attribute value, replaces the URI for a given namespace
     * with the specified new URI.
     * @param originalAttVal
     * @param schemaUri
     * @param newSchemaLoc 
     * @return
     */
    public static String UpdateSchemaLocationValue(String originalAttVal, String schemaUri, String newSchemaLoc) {
    	StringBuffer resultVal = new StringBuffer();
    	StringTokenizer tokenizer = new StringTokenizer(originalAttVal, " ");
    	while (tokenizer.hasMoreTokens()) {
    		String nsName = tokenizer.nextToken();
    		String schemaLoc = tokenizer.nextToken(); // Will throw a runtime exception if the attribute value is not a sequence of pairs.
    		if (nsName.equals(schemaUri)) {
    			schemaLoc = newSchemaLoc;
    		}
    		resultVal.append(nsName + " " + schemaLoc + " ");
    	}
        return resultVal.toString();
    }

    /**
     * Uses a null transform to serialize a DOM into an input stream using the default encoding.
     * @param doc Document to be serialized.
     * @return InputStream on the serialized bytes.
     * @throws Exception
     */
    public static InputStream serializeToInputStream(
    	    Document doc) throws Exception 
    	  {
    	return serializeToInputStream(doc, null);
    }

    /**
     * Uses a null transform to serialize a DOM into an input stream.
     * @param doc Document to be serialized.
     * @param encoding Encoding to serialize to. If null, encoding is utf-8
     * @return InputStream on the serialized bytes.
     * @throws Exception
     */
    public static InputStream serializeToInputStream(
    	    Document doc, 
    	    String encoding) throws Exception 
    	  {
    	    if (encoding == null)
    	      encoding = "utf-8";
    	    
    	    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    	    javax.xml.transform.Result rslt = new StreamResult(bos);
    	    serializeToResult(doc, encoding, rslt);
    	    return new ByteArrayInputStream(bos.toByteArray());
    }

	/**
	 * @param doc
	 * @param encoding
	 * @param bos
	 * @param rslt
	 * @return
	 * @throws Exception
	 */
	public static void serializeToResult(Document doc, String encoding,
			javax.xml.transform.Result rslt)
			throws Exception {
		javax.xml.transform.Source src = new DOMSource(doc);
		
		try {
		  Transformer transformer = getTransformerFactory().newTransformer();
		  
		  transformer.setOutputProperty(OutputKeys.ENCODING, encoding);
		  
		  transformer.setOutputProperty
		    (OutputKeys.OMIT_XML_DECLARATION, "no");
		  
		  // Set a property on the transformer if the caller wants a doctype and
		  // the node's owning document has the information
		  if (doc.getDoctype() != null) 
		  {
		    DocumentType doctype = doc.getDoctype();
		    if (doctype.getPublicId() != null)
		      transformer.setOutputProperty
		        (OutputKeys.DOCTYPE_PUBLIC, doctype.getPublicId());
		    if (doctype.getSystemId() != null)
		      transformer.setOutputProperty
		        (OutputKeys.DOCTYPE_SYSTEM, doctype.getSystemId());
		  }
  	  
		  transformer.transform(src, rslt);
		} 
		catch (TransformerException e) 
		{
		  throw new RuntimeException("Cannot serialize document: ", e);
		}
	}

    /**
     * Gets a transformer factory using the default URI resolver.
     * @return transformer factory instance.
     * @throws RSuiteException
     */
    public static TransformerFactory getTransformerFactory() throws Exception
    {
    	return getTransformerFactory(null);
    }

    /**
     * Gets a transformer fractory configured using the specified URI resolver.
     * @param uriResolver URI resolver to use with the factory. If null, default URI resolver is used.
     * @return transformer factory instance.
     * @throws RSuiteException
     */
    public static TransformerFactory getTransformerFactory(URIResolver uriResolver) throws Exception
    {
      TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl(); // TransformerFactory.newInstance();
  	  
      // Replace the default URI resolver with a chained resolver
      // that calls our internal resolver first, and then falls
      // back to the secondary resolver (set from the original value).    
      
      if (uriResolver != null)
    	  factory.setURIResolver(uriResolver);
      
      return factory;
    }


    public static Document getNewDom() throws ParserConfigurationException {
    	DocumentBuilder builder = DocumentBuilderFactoryImpl.newInstance().newDocumentBuilder();
    	return builder.newDocument();
    }
    
}

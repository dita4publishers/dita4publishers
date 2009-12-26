package net.sourceforge.dita4publishers.impl.ditabos;

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

import net.sourceforge.dita4publishers.api.ditabos.BosMemberValidationException;

import org.apache.log4j.Logger;
import org.apache.xerces.parsers.DOMParser;
import org.apache.xerces.parsers.XIncludeAwareParserConfiguration;
import org.apache.xerces.util.XMLCatalogResolver;
import org.apache.xerces.xni.grammars.XMLGrammarPool;
import org.apache.xerces.xni.parser.XMLParserConfiguration;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;



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
	 * @param xmlFile Document entity of the file to load.
	 * @return The DOM Document object for the document.
	 * @throws DomException
	 * @throws IOException 
	 * @throws MalformedURLException 
	 * @throws BosMemberValidationException 
	 * @throws FileNotFoundException 
	 */
	public static Document getDomForUri(URI xmlResource, BosConstructionOptions domOptions) throws DomException, MalformedURLException, IOException, BosMemberValidationException {
		InputSource source = new InputSource(xmlResource.toURL().openStream());
		source.setSystemId(xmlResource.toString());
		return getDomForSource(source, domOptions, false);
	}

	/**
	 * Constructs a DOM from the specified XML document file.
	 * @param xmlFile Document entity of the file to load.
	 * @return The DOM Document object for the document.
	 * @throws DomException
	 * @throws BosMemberValidationException 
	 */
	public static Document getDomForStream(InputStream stream, BosConstructionOptions domOptions) throws DomException, BosMemberValidationException {
		return getDomForSource(new InputSource(stream), domOptions, false);
	}

	/**
	 * Constructs a DOM from the specified XML document file.
	 * @param throwExceptionIfInvalid 
	 * @param xmlFile Document entity of the file to load.
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
     * @param string
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


}

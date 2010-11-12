/**
 * 
 */
package net.sourceforge.dita4publishers.util;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import net.sourceforge.dita4publishers.util.xml.XmlFormatSaxErrorHandlingXMLFilter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.xerces.util.XMLCatalogResolver;
import org.w3c.dom.Document;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;


/**
 * Utilities for doing SAX parsing and validation.
 */
public class SaxUtil {
	
	private static final Log log = LogFactory.getLog(SaxUtil.class);  

	
	/**
	 * Get an XML Reader that uses the default catalogs as defined by various environment variables.
	 * @param log
	 * @param logDoc
	 * @param validate
	 * @return Logging XML reader
	 * @throws Exception
	 */
	public static XMLReader getXMLFormatLoggingXMLReader(Log log, Document logDoc, boolean validate) throws Exception {
		return getXMLFormatLoggingXMLReader(log, logDoc, validate, getCatalogs());		
	}
	
	public static XMLReader getXMLFormatLoggingXMLReader(Log log, Document logDoc, boolean validate, String[] catalogs) throws Exception {
		
		log.debug("SAX Parser factory class=" + System.getProperty("javax.xml.parsers.SAXParserFactory"));
		
		
		XMLReader baseReader = null;;
		try {
			baseReader = XMLReaderFactory.createXMLReader();
		} catch (Exception e) {
			throw new Exception("Exception constructing new SAX parser: " + e.getMessage(), e);
		}
		
		
		XMLReader reader = new XmlFormatSaxErrorHandlingXMLFilter(baseReader, log, logDoc);

	    try 
	    {
	      
	    	reader.setFeature("http://xml.org/sax/features/validation", 
	    			validate);
	    	reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd",
	    			validate);
	    	reader.setEntityResolver(getCatalogResolver(catalogs));
	    } catch (Exception e) {
	    	String msg = "Failed to set features on XMLReader instance: " + e.getMessage(); 
	    	log.error(msg);
	    	throw new Exception(msg, e);
	    }
	    
		return reader;
	}
	
	/**
	 * Validates an XML document and returns the DOM containing the parsing result as a
	 * set of <message> elements.
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public static Document validateDocument(InputSource input) throws Exception {
		Document logDoc = null;
		XMLReader reader = getXMLFormatLoggingXMLReader(log, logDoc, true);
		reader.parse(input);
		return logDoc;
	}


	/**
	 * Validates an XML document and returns the DOM containing the parsing result as a
	 * set of <message> elements.
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public static Document validateDocument(InputSource input, String[] catalogs) throws Exception {
		Document logDoc = null;
		XMLReader reader = getXMLFormatLoggingXMLReader(log, logDoc, true, catalogs);
		reader.parse(input);
		return logDoc;
	}


	public static EntityResolver getCatalogResolver(String[] catalogs) {
		XMLCatalogResolver resolver = new XMLCatalogResolver();
		resolver.setCatalogList(catalogs);
		return resolver;

	}
	
	/**
	 * Tries to find the relevant entity resolution catalogs.
	 */
	protected static String[] getCatalogs() {
		
		List<String> catalogs = new ArrayList<String>();
		
		String catalogList = System.getProperty("xml.catalog.files");
		if (catalogList != null && !"".equals(catalogList)) {
			StringTokenizer  tokens = new StringTokenizer(catalogList, ";");
			if (tokens.hasMoreTokens()) {
				while (tokens.hasMoreTokens()) {
					catalogs.add(tokens.nextToken());
				}
			}
		}

		String toolkitCatalogUri = getDitaOpenToolkitCatalog();
		if (toolkitCatalogUri != null) {
			catalogs.add(toolkitCatalogUri);
		}
		String[] array = new String[catalogs.size()];	
		catalogs.toArray(array);
		return array;
	}

	/**
	 * @return
	 */
	private static String getDitaOpenToolkitCatalog() {
		File catalogFile = null;
		String ditaHome = System.getenv("DITA_HOME");
		if (ditaHome != null && !"".equals(ditaHome.trim())) {
			File ditaDir = new File(ditaHome);
			catalogFile = new File(ditaDir, "catalog-dita.xml");
			
		} else {
			System.err.println("DITA_HOME environment variable not set. Cannot find DITA Open Toolkit catalog-dita.xml file");
		}
		if (catalogFile != null) {
			try {
				checkExistsAndCanRead(catalogFile);
			} catch (Exception e) {
				System.err.println("Catalog file \"" + catalogFile.getAbsolutePath() + "\" does not exist or cannot be read.");
				System.exit(1);
			}
			return catalogFile.getAbsolutePath(); 
		}
		return null;
	}

	/**
	 * @param file
	 */
	private static void checkExistsAndCanRead(File file) {
		if (!file.exists()) {
			throw new RuntimeException("File " + file.getAbsolutePath() + " does not exist.");
		}
		if (!file.canRead()) {
			throw new RuntimeException("File " + file.getAbsolutePath() + " exists but cannot be read.");
		}
	}
	

}

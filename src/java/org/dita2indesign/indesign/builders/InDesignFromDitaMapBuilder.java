/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.builders;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import net.sf.saxon.FeatureKeys;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.Link;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.Rectangle;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.Story;
import org.dita2indesign.indesign.inx.model.TextContents;
import org.dita2indesign.indesign.inx.model.TextFrame;
import org.dita2indesign.indesign.inx.model.TextStyleRange;
import org.dita2indesign.indesign.inx.model.Link.LinkType;
import org.dita2indesign.util.DataUtil;
import org.dita2indesign.util.DitaOTAwareSchemaValidatingCatalogResolvingXMLReader;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;


/**
 * Takes a DITA map representing a single publication as input
 * and generates a new InDesign document with links to the map's topics placed
 * in placeholder frames.
 */
public class InDesignFromDitaMapBuilder {
	
	private static   Log log = LogFactory.getLog(InDesignFromDitaMapBuilder.class);
	private Map<Element, File> topicrefCache = new HashMap<Element, File>();

	/**
	 * @param context 
	 * @param gdTemplate
	 * @param gdIssueCa
	 */
	public InDesignFromDitaMapBuilder() {
	}

	/**
	 * @param publicationMapSource 
	 * @param inDesignTemplateSource 
	 * @return
	 */
	public InDesignDocument buildMapDocument(InputSource inDesignTemplateSource, InputSource publicationMapSource, Map2InDesignOptions options) throws Exception {
		if (log.isDebugEnabled())
			log.debug("buildIssueDocument(): inDesignTemplate=\"" + inDesignTemplateSource.getSystemId() + "\", publicationMap=\"" + publicationMapSource.getSystemId() + "\"");
		// Load the template then clone it to make our starting doc.
		InDesignDocument template = new InDesignDocument(inDesignTemplateSource);

		InDesignDocument doc = new InDesignDocument(template);
		
		Document mapDoc = DataUtil.constructNonValidatingDtdUsingDocumentBuilder().parse(publicationMapSource);
		if (mapDoc == null) {
			throw new Exception("Failed to parse issue \"" + publicationMapSource.getSystemId() + "\".");
		}
		
		// Look for articles and add them to the InDesign document:
		addTopicsToDocument(doc, mapDoc, options);
		
		generateInCopyArticlesForTopics(mapDoc, options);
		
		return doc;
	}

	/**
	 * Applies the specified transform to the map document in order to generate
	 * InCopy articles for the topics in the map. 
	 * @param mapDoc
	 * @param options Options used to configure the transform, including the URL of the 
	 * transform itself.
	 * @throws Exception 
	 */
	private void generateInCopyArticlesForTopics(Document mapDoc, Map2InDesignOptions options) throws Exception {

		URL xsltUrl = options.getXsltUrl();
		if (xsltUrl == null) {
			throw new Exception("No XSLT URL option value specified.");
		}
	    
        Source style = new StreamSource(xsltUrl.openStream());
        style.setSystemId(xsltUrl.toExternalForm());


        Source xmlSource = new DOMSource(mapDoc);
        String mapDocUri = mapDoc.getDocumentURI();
        xmlSource.setSystemId(mapDocUri);
        if (log.isDebugEnabled())
        	log.debug("xmlSource.systemId=\"" + xmlSource.getSystemId() + "\"");
        // Create a temp file in the same directory as the real INX file so the 
        // XSLT transform will generate its output in the right place:
        File resultFile = File.createTempFile("map2indesign", ".inx", options.getResultFile().getParentFile()); // NOTE: The top-level file is not used.

        if (log.isDebugEnabled())
        	log.debug("Calling transform()...");

        Source xsltSource = new StreamSource(xsltUrl.openStream());
        xsltSource.setSystemId(xsltUrl.toExternalForm());
        
        XsltTransformer trans = getSaxonTransformer(xmlSource, resultFile, xsltSource);
        
        trans.setParameter(new QName("styleCatalogUrl"), new XdmAtomicValue(options.getStyleCatalogUrl()));
        trans.setParameter(new QName("outputPath"), new XdmAtomicValue(resultFile.getParent()));
        trans.setParameter(new QName("linksPath"), new XdmAtomicValue(options.getLinksPath()));
        trans.setParameter(new QName("debug"), new XdmAtomicValue(options.getDebug()));

        trans.transform();
        if (log.isDebugEnabled())
        	log.debug("Transformation complete.");
		resultFile.delete(); // Don't need the result file since each article is generated as a separate file.
	}

	private void addTopicsToDocument(InDesignDocument inDesignDoc, Document mapDoc, Map2InDesignOptions options) throws Exception {
		if (log.isDebugEnabled())
			log.debug("addArticlesToDocument(): Starting...");
		
		
		// FIXME: These next lines should be handled by XmlApiManager. Can't use XmlConstants because
		//        it uses RSIConstants, which requires a real RSuite instance (don't ask).
		XPath xpath = getXPathFactory().newXPath();
		XPathExpression topicrefExpression = xpath.compile("//*[contains(@class, ' map/topicref ') and @href != '']");
		
		// Per Saxon docs, when source is a DOM, result of NODESET is a NodeList.
		NodeList topicrefs = (NodeList)topicrefExpression.evaluate(new DOMSource(mapDoc), XPathConstants.NODESET);

		// NOTE: This code assumes chunking has already been applied to the map so that any topicrefs are to
		// top-level topics.

		Spread spread = inDesignDoc.getSpread(0);

		if (log.isDebugEnabled())
			log.debug("addTopicsToDocument(): Found " + topicrefs.getLength() + " articles in content assembly.");
		double yTop = -260.0;
		double height = 120.0;
		// These values are determined by trial and error.
		// Probably a more elegant way to calculate this geometry:
		double xTranslate = -760.0;
		double yTranslate = -156.0;
		double yGap = 24.0;
		double xGap = 24.0;
		double width = 280.0; // Width of an article frame.
		int row = 0;
		Page page = spread.getEvenPage(); // Should get only page of the spread.
		if (page == null) {
			page = spread.getOddPage();
		}
		int rowCount = 6;
		
		for (int i = 0; i < topicrefs.getLength(); i++) {
			Element elem = (Element)topicrefs.item(i);
			if (log.isDebugEnabled())
				log.debug("addArticlesToDocument(): Topic [" + (i+1) + "], \"" + elem.getAttribute("href") + "\"");

			// FIXME: Need to handle non-XML topicrefs
			Link link = constructLinkForTopicref(inDesignDoc, elem, options);
			
			Rectangle frame;
//			if (mo.isNonXml()) {
//				continue; // For now, just skip non-XML MOs until we get image creation implemented.
//				// frame = createFrameForNonXmlMo(inDesignDoc, link);
//			} else {
				frame = createFrameForArticle(inDesignDoc, elem, link);
//			}

			frame.getGeometry().getBoundingBox().setCorners(-140, yTop, 140, (yTop + height));
			frame.getGeometry().getTransformationMatrix().setXTranslation(xTranslate);
			frame.getGeometry().getTransformationMatrix().setYTranslation(yTranslate + ((height + yGap) * row));
			

			spread.addRectangle(frame);
			row++;
			// This ensures all the articles stay in the first-page's pasteboard
			if (i > 0 && (i+1) % rowCount == 0) {
				xTranslate += (width + xGap);
				row = 0;
			}
			
			if (i > 0 && (i+1) % (rowCount*2) == 0) {
				xTranslate += page.getWidth() + xGap/2;
			}
			
						
		}
	}

	private TextFrame createFrameForArticle(InDesignDocument inDesignDoc,
			Element mo, Link link) throws Exception {
		TextFrame frame = inDesignDoc.newTextFrame(link);
		// Put frame to left of page, stacked vertically:
		
		Story story = frame.getParentStory();
		TextStyleRange txsr = new TextStyleRange();
		// FIXME: Get navigation title here?
		txsr.addChild(new TextContents(mo.getAttribute("href")));
		story.addChild(txsr);
		return frame;
	}

	private Link constructLinkForTopicref(InDesignDocument inDesignDoc, Element topicrefElem, Map2InDesignOptions options) throws Exception {
		Link link = inDesignDoc.newLink();
		Date lastModified = Calendar.getInstance().getTime();
		link.setDate(lastModified);
		
		
		setTopicLinkProperties(topicrefElem, link, options);
		link.setEditingState(Link.EditingState.EDITING_NOWHERE);
		return link;
	}

	/**
	 * @param topicrefElem
	 * @return
	 * @throws Exception 
	 */
	private File getReferencedTopic(Element topicrefElem) throws Exception {
		if (topicrefCache.containsKey(topicrefElem)) {
			return topicrefCache.get(topicrefElem);
		}
		String hrefValue = topicrefElem.getAttribute("href");
		if (hrefValue == null || "".equals(hrefValue)) {
			throw new Exception("No href= value for topicref element.");
		}
		String baseUri = topicrefElem.getBaseURI();
		URL baseUrl = new URL(baseUri);
		URL url = new URL(baseUrl, hrefValue);
		File topicFile = new File(url.getFile());
		topicrefCache.put(topicrefElem, topicFile);
		return topicFile;
	}

	/**
	 * @param mo
	 * @param link
	 * @throws Exception 
	 */
	private void setNonXmlLinkProperties(File object, Link link) throws Exception {
		link.setWindowsFileName(object.getAbsolutePath());
		link.setMacFileName(link.getWindowsFileName());
		String linkType = LinkType.EPS_PDF_AI;
		// FIXME: Set the link type appropriately based on contentType
		link.setLinkType(linkType);
		link.setFileType(0); // This appears to be zero for all graphic types--docs are not clear on this value's meaning.

	}

	private void setTopicLinkProperties(Element topicrefElem, Link link, Map2InDesignOptions options) throws Exception {
		// It appears that the name reflects the filename part of the OS-specific filename.
		// InDesign appears to require the "c:\" in order to properly display the link name under Windows.	
		
		String incopyArticleFilename = getInCopyArticleNameForTopic(topicrefElem);
		File linkedFile = new File(new File(options.getResultFile().getParentFile(), options.getLinksPath()), incopyArticleFilename);
		String windowsFilename = linkedFile.getAbsolutePath();
		if (windowsFilename.contains("/")) {
			// Must be a Mac filename, convert it to Windows
			windowsFilename = windowsFilename.replace('/', '\\');
			if (windowsFilename.startsWith("\\")) {
				windowsFilename = "c:" + windowsFilename; // As far as I can tell, windows filename must start with a drive indicator
				                           // for it to show up correctly in the Links UI.
			}
		}
		link.setWindowsFileName(windowsFilename);
		String macFilename = windowsFilename.replace('\\', ':'); 
		if (macFilename.startsWith("c:")) {
			macFilename = "Macintosh HD:" + macFilename.substring(2);
		}
		link.setMacFileName(macFilename);
		link.setLinkType(Link.LinkType.INCOPY);
		link.setFileType(0);
	}

	/**
	 * Given a topicref, returns the filename of the corresponding topic's 
	 * InCopy article.
	 * <p>Override this method in subclasses to change the filename mapping
	 * logic.</p>
	 * @param topicrefElem
	 * @param topicFile
	 * @return
	 * @throws Exception 
	 */
	public String getInCopyArticleNameForTopic(Element topicrefElem) throws Exception {
		File topicFile = getReferencedTopic(topicrefElem);
		String articleFilename = topicFile.getName().substring(0, topicFile.getName().lastIndexOf(".")) + ".incx";		
		return articleFilename;
	}

	/**
	 * Copied from XmlUtils and references to RSIConstant removed
	 * 
	 */
class RSuiteNamespaceContext implements NamespaceContext {
	private Hashtable<String, String> namespaces = new Hashtable<String, String>();

	public RSuiteNamespaceContext() {
		namespaces.put("RSUITE", "http://www.reallysi.com");
	}

	public String getNamespaceURI(String prefix) {
		String uri = null;
		if (prefix == null)
			throw new NullPointerException("Null prefix.");

		uri = namespaces.get(prefix);
		if (uri == null)
			uri = XMLConstants.XML_NS_URI;
		return uri;
	}

    public String getPrefix(String uri) {
        String prefix = null;
        if(uri==null) throw new NullPointerException("Null namespace uri.");
        for (String key : namespaces.keySet()) {
			String value = namespaces.get(key);
			if (uri.equals(value)) {
				prefix = key;
				break;
			}
		}
        if(prefix==null) prefix = XMLConstants.XML_NS_PREFIX;
        return prefix;
    }

    public Iterator<String> getPrefixes(String arg0) {
        return namespaces.keySet().iterator();
    }
    
    public void addNamespace(String prefix, String uri) throws Exception{
    	if("RSUITE".equals(prefix)){
    		throw new Exception("You can not change the default name space declaration of the RSUITE CMS");
    	}else{
    		namespaces.put(prefix, uri);
    	}
    }
    
    public void removeNamespace(String prefix) throws Exception{
    	if("RSUITE".equals(prefix)){
    		throw new Exception("You can not remove the default name space declaration of the RSUITE CMS");
    	}else{
    		namespaces.remove(prefix);
    	}
    }
}


	/**
	 * @param transformContext
	 * @param indesignTemplate
	 * @param publicationMap
	 * @return
	 * @throws Exception 
	 * @throws IOException 
	 */
	public InDesignDocument buildMapDocument(
			URL publicationMap,
			Map2InDesignOptions options) throws Exception {
		URL inDesignTemplate = options.getInDesignTemplate();
		if (inDesignTemplate == null) {
			throw new Exception("InDesign template option not set.");
		}
		InputSource indesignTemplateSource = new InputSource(inDesignTemplate.openStream()); 
		indesignTemplateSource.setSystemId(options.getInDesignTemplate().toExternalForm());
		
		InputSource mapSource = new InputSource(publicationMap.openStream());
		mapSource.setSystemId(publicationMap.toExternalForm());
		return buildMapDocument(indesignTemplateSource, mapSource, options);
	}
	
	  /**
	   * 
	   */
	  public XPathFactory getXPathFactory(){
		  return new net.sf.saxon.xpath.XPathFactoryImpl();
	  }
	  
	protected XsltTransformer getSaxonTransformer(Source inSource,
			File outFile, Source xsltSource) throws Exception {
        Processor proc = new Processor(false);
		proc.setConfigurationProperty(FeatureKeys.SOURCE_PARSER_CLASS, DitaOTAwareSchemaValidatingCatalogResolvingXMLReader.class.getName());
		XsltCompiler compiler = proc.newXsltCompiler();
//		compiler.setErrorListener(logger);
				
		XsltExecutable exp = compiler.compile(xsltSource);
	
		XdmNode source = proc.newDocumentBuilder().build(inSource);
		Serializer out = new Serializer();

        out.setOutputProperty(Serializer.Property.METHOD, "xml");
        out.setOutputProperty(Serializer.Property.INDENT, "no");
        out.setOutputFile(outFile);
        
        XsltTransformer trans = exp.load();
        
//        trans.getUnderlyingController().setErrorListener(logger);
        trans.setInitialContextNode(source);
        trans.setDestination(out);
//        trans.getUnderlyingController().setMessageEmitter(logger);
		return trans;
	}

	  

}

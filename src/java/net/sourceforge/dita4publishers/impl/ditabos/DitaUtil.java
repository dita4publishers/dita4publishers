package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.Vector;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import net.sourceforge.dita4publishers.api.dita.DitaPropsSpec;
import net.sourceforge.dita4publishers.api.ditabos.AddressingException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;




public class DitaUtil {
	
	private static final Log log = LogFactory.getLog(DitaUtil.class);

	public static final String ALL_KEYDEFS_XPATH = 
		"//*[(contains(@class, ' map/topicref ') or " +
		"   ends-with(@class, ' map/topicref')) and" +
		"  string(@keys) != '']";

	/**
	 * 
	 */
	public static final String ALL_TOPICREFS_XPATH = 
		"//*[contains(@class, ' map/topicref ') or ends-with(@class, ' map/topicref')]";
	public static final String ALL_TOPICREFS_WITH_HREF_XPATH = 
		"//*[contains(@class, ' map/topicref ') or ends-with(@class, ' map/topicref') and" +
		"    (@href != '')]";
	public static final String LINKTEXT_FOR_TOPICREF_XPATH = 
		"*[contains(@class, ' map/topicmeta ') or " +
		"  ends-with(@class, ' map/topicmeta')]/*[contains(@class, ' map/linktext ') or " +
		"                                         ends-with(@class, ' map/linktext')]";
	public static final String ALL_CONREFS_XPATH = 
		"//*[@conref != '' or @conkeyref != '']";
	public static final String ALL_HREFS_AND_KEYREFS = 
		"//*[@href != '' or @keyref != '']";
	public static final String ALL_HREFS_AND_CONREFS = 
		"//*[@href != '' or @conref != '']";
	public static final String ALL_OBJECTS = 
		"//*[(contains(@class, ' topic/object ') or " +
		"   ends-with(@class, ' topic/object'))]";

	static final XPathFactory xpathFact = new net.sf.saxon.xpath.XPathFactoryImpl();
	public static XPathExpression allKeyDefs;
	public static XPathExpression linktextForTopicref;
	public static XPathExpression allTopicrefs;
	public static XPathExpression allTopicrefsWithHrefs;
	public static XPathExpression allConrefs;
	public static XPathExpression allHrefsAndKeyrefs;
	public static XPathExpression allObjects;

	public static XPathExpression allHrefsAndConrefs;

	static {
   	  try {
   		  XPath xpath = xpathFact.newXPath();
			allKeyDefs = xpath.compile(ALL_KEYDEFS_XPATH);
			linktextForTopicref = xpath.compile(LINKTEXT_FOR_TOPICREF_XPATH);
			allTopicrefs = xpath.compile(ALL_TOPICREFS_XPATH);
			allTopicrefsWithHrefs = xpath.compile(ALL_TOPICREFS_WITH_HREF_XPATH);
			allConrefs = xpath.compile(ALL_CONREFS_XPATH);
			allHrefsAndKeyrefs = xpath.compile(ALL_HREFS_AND_KEYREFS);
			allHrefsAndConrefs = xpath.compile(ALL_HREFS_AND_CONREFS);
			allObjects = xpath.compile(ALL_OBJECTS);
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
      }

	public static final String RSUITE_METADATA_BASE_DECLS_ENT = "resources/dtds/rsuite-metadata-base-decls.ent";

	private static final String DITA_FRONTMATTER_DEFAULT_NAVTITLE = "Frontmatter";
	public static final String TAGNAME_LAYERED_METADATA = "LAYERED-METADATA";
	public static final String LAYERED_METADATA_DATATYPE_STRING = "String";
	public static final String LAYERED_METADATA_CLASS_ATT_VALUE = "classAttValue";
	public static final String LAYERED_METADATA_DTD_SYSTEM_ID = "dtdSystemID";
	public static final String LAYERED_METADATA_DTD_PUBLIC_ID = "dtdPublicID";
	public static final String LAYERED_METADATA_IS_DITA_MAP = "isDitaMap";
	public static final String LAYERED_METADATA_IS_TOPIC_HEAD = "isTopicHead";
	public static final String LAYERED_METADATA_IS_TOPIC_REF = "isTopicRef";
	public static final String LAYERED_METADATA_ORIGINAL_FILENAME = "originalFilename";
	public static final String LAYERED_METADATA_ORIGINAL_NAMESPACE_PREFIX = "originalNamespacePrefix";
	public static final String LAYERED_METADATA_ORIGINAL_NAMESPACE_URI = "originalNamespaceUri";
	public static final String LAYERED_METADATA_ORIGINAL_TAGNAME = "originalTagname";

	public static final Set<String> layeredMetadataFieldNames = new TreeSet<String>();
	static {
		layeredMetadataFieldNames.add(LAYERED_METADATA_CLASS_ATT_VALUE);
		layeredMetadataFieldNames.add(LAYERED_METADATA_DTD_PUBLIC_ID);
		layeredMetadataFieldNames.add(LAYERED_METADATA_DTD_SYSTEM_ID);
		layeredMetadataFieldNames.add(LAYERED_METADATA_IS_DITA_MAP);
		layeredMetadataFieldNames.add(LAYERED_METADATA_IS_TOPIC_HEAD);
		layeredMetadataFieldNames.add(LAYERED_METADATA_IS_TOPIC_REF);
		layeredMetadataFieldNames.add(LAYERED_METADATA_ORIGINAL_FILENAME);
		layeredMetadataFieldNames.add(LAYERED_METADATA_ORIGINAL_NAMESPACE_PREFIX);
		layeredMetadataFieldNames.add(LAYERED_METADATA_ORIGINAL_NAMESPACE_URI);
		layeredMetadataFieldNames.add(LAYERED_METADATA_ORIGINAL_TAGNAME);
	}

	public static final String DITA_ARCH_NS = "http://dita.oasis-open.org/architecture/2005/";
	public static final String DITA_ARCH_VERSION_ATTNAME = "DITAArchVersion";
	public static final String DITA_MAP_TYPE = "map/map";
	public static final String DITA_CLASS_ATTNAME = "class";
	public static final String DITA_TOPIC_TYPE = "topic/topic";
	public static final String DITA_TOPICREF_TYPE = "map/topicref";
	public static final String DITA_TOPICTITLE_TYPE = "topic/title";

	public static final int SCOPE_LOCAL = 0;
	public static final int SCOPE_PEER = 1;
	public static final int SCOPE_EXTERNAL = 2;
	
	public static final String DITA_HREF_ATTNAME = "href";
	public static final String DITA_SCOPE_ATTNAME = "scope";
	public static final Object DITA_SCOPE_ATTVALUE_LOCAL = "local";
	public static final Object DITA_SCOPE_ATTVALUE_PEER = "peer";
	public static final Object DITA_SCOPE_ATTVALUE_EXTERNAL = "external";
	public static final String DITA_NAVTITLE_ATTNAME = "navtitle";
	public static final String DITA_FORMAT_ATTNAME = "format";
	public static final String DITA_KEYREF_ATTNAME = "keyref";
	public static final String DITA_KEYS_ATTNAME = "keys";
	public static final String DITA_TYPE_ATTNAME = "type";
	
	public static final String DITA_FORMAT_VALUE_DITA = "dita";
	public static final String DITA_FORMAT_VALUE_DITAMAP = "ditamap";
	public static final String DITA_FORMAT_VALUE_PDF = "pdf";
	public static final String DITA_FORMAT_VALUE_HTML = "html";
	public static final String DITA_FORMAT_ATT_DEFAULT = DITA_FORMAT_VALUE_DITA;
	public static final String DITA_TYPE_ATT_DEFAULT = "topic";

	private static final List<String> BASE_PROPS_ATTS = new ArrayList<String>();
	
	static {
		BASE_PROPS_ATTS.add("platform");
		BASE_PROPS_ATTS.add("product");
		BASE_PROPS_ATTS.add("audience");
		BASE_PROPS_ATTS.add("otherprops");
		BASE_PROPS_ATTS.add("props");
	}



	/**
	 * Returns true if the element appears to be a map or within a map.
	 * @param root
	 * @return True or false
	 */
	public static boolean isDitaMap(Element elem) {
		Element root = elem.getOwnerDocument().getDocumentElement();
		if (root != null && isInDitaDocument(root)) {
			return isDitaType(root, DITA_MAP_TYPE);
		}
		return false;
	}

	public static boolean isDitaType(Element element, String ditaMapType) {
		String classValue = element.getAttribute(DITA_CLASS_ATTNAME);
		if (classValue != null) {
			// NOTE: because class values always start with "+" or "-",
			//       index can never be 0.
			return (classValue.indexOf(" " + ditaMapType.trim() + " ") > 0 ||
					classValue.endsWith(" " + ditaMapType.trim())); 
		}
		return false;
	}

	/**
	 * Returns true if the element's containing document 
	 * @param elem
	 * @return
	 */
	public static boolean isInDitaDocument(Element elem) {
		Element root = elem.getOwnerDocument().getDocumentElement();
		Element cand = root;
		if (cand.getTagName().equals("dita")) {
			// FIXME: This a little weak but unlikely to return false positives.			
			return true; 
		}
		return root.hasAttributeNS(DITA_ARCH_NS, DITA_ARCH_VERSION_ATTNAME);
	}

	public static boolean isDitaTopic(Element elem) {
		return isDitaType(elem, DITA_TOPIC_TYPE);
	}

	/**
	 * Returns true if the element is of type DITA_TOPICREF_TYPE and has
	 * a non-empty value for its href= attribute.
	 * @param elem
	 * @return
	 */
	public static boolean isTopicRef(Element elem) {
		if (isDitaType(elem, DITA_TOPICREF_TYPE)) {
			String href = elem.getAttribute(DITA_HREF_ATTNAME);
			return (href != null && !href.equals(""));
		}
		return false;
	}

	/**
	 * Returns true if the element of type DITA_TOPICTITLE_TYPE
	 * @param child
	 * @return True if it's a topic titlel
	 */
	private static boolean isTopicTitle(Element elem) {
		return isDitaType(elem, DITA_TOPICTITLE_TYPE);
	}

	/**
	 * Returns true if the element is of type DITA_TOPICREF_TYPE and has
	 * a an empty or null value for its href= attribute.
	 * @param elem
	 * @return
	 */
	public static boolean isTopicHead(Element elem) {
		if (isDitaType(elem, DITA_TOPICREF_TYPE)) {
			String href = elem.getAttribute(DITA_HREF_ATTNAME);
			return (href == null || href.equals(""));
		}
		return false;
	}

	/**
	 * Returns the topicrefs of any type that are a direct child of the parent element.
	 * @param parent
	 * @param topicrefs
	 */
	public static void getTopLevelTopicrefs(Element parent,
			Vector<Element> topicrefs) {
		Iterator<Element> iter = DataUtil.getElementChildrenIterator(parent);
		while (iter.hasNext()) {
			Element child = iter.next();
			if (isDitaType(child, DITA_TOPICREF_TYPE)) topicrefs.add(child);
		}
		
	}

	public static void getTopicrefs(Element elem, List<Element> topicrefs) {
		if (isTopicRef(elem)) {
			topicrefs.add(elem);
		}
		Iterator<Element> iter = DataUtil.getElementChildrenIterator(elem);
		while (iter.hasNext()) {
			Element child = iter.next();
			getTopicrefs(child, topicrefs);
		}
		
	}

	/**
	 * Resolve a topicref href= value to a file.
	 * @param elem
	 * @param memberFile
	 * @param scope local, peer, or external
	 * @return
	 * @throws AddressingException 
	 */
	public static File getTopicrefTargetFile(Element elem, File memberFile, int scopeLimit) throws AddressingException {
		String scopeValue = elem.getAttribute(DITA_SCOPE_ATTNAME);
		boolean RESOLVE_IT = false;
		if (scopeValue != null && !"".equals(scopeValue)) {
			if (DITA_SCOPE_ATTVALUE_LOCAL.equals(scopeValue)) {
				RESOLVE_IT = true;
			} else if (DITA_SCOPE_ATTVALUE_PEER.equals(scopeValue) && scopeLimit >= SCOPE_PEER) {
				RESOLVE_IT = true;				
			} else if (DITA_SCOPE_ATTVALUE_EXTERNAL.equals(scopeValue) && scopeLimit >= SCOPE_EXTERNAL) {
				RESOLVE_IT = true;				
			}
		} else {
			RESOLVE_IT = true;				
		}
		if (RESOLVE_IT) {
			if (elem.hasAttribute(DITA_HREF_ATTNAME)) {
				return AddressingUtil.getHrefTargetDocument(elem, memberFile);
			}
		}
		return null;
	}

	/**
	 * Given a DITA map document, returns the map's title, if there is one.
	 * @param rootDom
	 * @return The title as a string or null if there is no title.
	 */
	public static String getMapTitle(Document mapDoc) {
		Element titleElem = getChildOfDitaType(mapDoc, "topic/title");
		if (titleElem != null) {
			return DataUtil.getStringValueOfElement(titleElem);
		}
		return null;
	}

	public static Element getChildOfDitaType(Document mapDoc, String ditaTypeSpec) {
		Iterator<Element> childs = DataUtil.getElementChildrenIterator(mapDoc.getDocumentElement());
		while (childs.hasNext()) {
			Element child = childs.next();
			if (isDitaType(child, ditaTypeSpec)) return child;
		}
		return null;
	}

	public static String getTopicRefNavTitle(Element topicRefElem, BosConstructionOptions domOptions) throws Throwable {
		if (topicRefElem.hasAttribute(DITA_NAVTITLE_ATTNAME)) {
			return topicRefElem.getAttribute(DITA_NAVTITLE_ATTNAME);
		} else if (DitaUtil.isDitaType(topicRefElem, "bookmap/frontmatter")) {
			return DITA_FRONTMATTER_DEFAULT_NAVTITLE;
		}
		if (topicRefElem.hasAttribute(DITA_HREF_ATTNAME)) {
			File memberFile = null;
			Document parentDoc = topicRefElem.getOwnerDocument();
			if (parentDoc == null) throw new RuntimeException("No owner document for TopicRef data source element.");
			String parentUrl = parentDoc.getBaseURI();
			if (parentUrl == null) throw new RuntimeException("Topicref owner document base URI is null");
			memberFile = new File(new URI(parentUrl));
			// FIXME: Hardcoding scope local for now. Should get it from command-line parameters.
			Element targetTopic = getTopicrefTarget(topicRefElem, memberFile, SCOPE_LOCAL, domOptions);
			if (targetTopic == null) return "{No navtitle= value and unable to resolve topic reference}";
			return getTopicTitle(targetTopic);
		}
		return "Unable to determine navtitle value";
	}

	private static String getTopicTitle(Element topicElem) {
		// While the DITA spec requries title to be first child of topic,
		// RSuite metadata might be inserted before title, so we have to iterate
		// over children.
		Iterator<Element> iter = DataUtil.getElementChildrenIterator(topicElem);
		while (iter.hasNext()) {
			Element child = iter.next();
			if (isTopicTitle(child)) return DataUtil.getStringValueOfElement(child);
		}
		return null;
	}

	private static Element getTopicrefTarget(Element topicRefElem,
			File memberFile, int scopeLimit, BosConstructionOptions domOptions) throws Throwable {
		Document targetDoc = getTopicrefTargetDoc(topicRefElem, memberFile, scopeLimit, domOptions);
		if (targetDoc != null) {
			String href = topicRefElem.getAttribute(DITA_HREF_ATTNAME);
			if (href != null && !"".equals(href)) {
				return resolveTopicReference(targetDoc, href);
				
			}
		}
		return null;
	}

	private static Element resolveTopicReference(Document targetDoc, String href) {
		Element elem = targetDoc.getDocumentElement();
		if (href.indexOf("#") >= 0) {
			// Pointer to a topic by ID, find it
			throw new RuntimeException("Resolution of topic references by ID not yet implemented");
		} else {
			// Pointer to first topic in document
			if (isDitaTopic(elem)) {
				return elem;
			} else {
				Iterator<Element> iter = DataUtil.getElementChildrenIterator(elem);
				while (iter.hasNext()) {
					Element child = iter.next();
					if (isDitaTopic(child)) return child;
				}
			}
		}
		return null;
	}

	private static Document getTopicrefTargetDoc(Element topicRefElem,
			File memberFile, int scopeLimit, BosConstructionOptions domOptions) throws Throwable {
		File targetFile = getTopicrefTargetFile(topicRefElem, memberFile, scopeLimit);
		return DomUtil.getDomForDocument(targetFile, domOptions);
	}

	/**
	 * @param topicRef
	 * @return
	 */
	public static boolean isMapReference(Element topicRef) {
		return (topicRef.hasAttribute("href") && 
				topicRef.hasAttribute("format") && 
				topicRef.getAttribute("format").equals("ditamap")
				);
	}

	/**
	 * Gets the @href or linktext value of the key definition.
	 * @param keydef
	 * @return
	 */
	public static String getImmediateResourceForKeydef(Element keydef) {
		if (keydef.hasAttribute("href"))
			return keydef.getAttribute("href");
		NodeList resultNl = null;
		try {
			resultNl = (NodeList)linktextForTopicref.evaluate(keydef, XPathConstants.NODESET);
		} catch (XPathExpressionException e) {
			log.error("Unexpected exception evaluating XPath expression " + linktextForTopicref.toString());
		}
		if (resultNl != null && resultNl.getLength() > 0) {
			return resultNl.item(0).getTextContent();
		}
		return "{No href attribute linktext for key-defining topicref element \"" + keydef.getNodeName() + "\"}";
	}

	/**
	 * @param topicref
	 * @return
	 */
	public static boolean isLocalScope(Element topicref) {
		if (topicref.hasAttribute(DITA_SCOPE_ATTNAME)) {
			String scopeValue = topicref.getAttribute(DITA_SCOPE_ATTNAME);
			if (scopeValue.equals(DITA_SCOPE_ATTVALUE_LOCAL))
				return true;
			if (scopeValue.equals(DITA_SCOPE_ATTVALUE_PEER) ||
			    scopeValue.equals(DITA_SCOPE_ATTVALUE_EXTERNAL))
				return false;
			log.warn("Unrecognized value \"" + scopeValue + "\" for @" + DITA_SCOPE_ATTNAME + " attribute. Using 'local'"); 
		}
		return true; // local by default.
	}

	/**
	 * @param ref
	 * @return
	 */
	public static boolean isLocalOrPeerScope(Element ref) {
		return (isLocalScope(ref) || isPeerScope(ref));
	}

	/**
	 * @param topicref
	 * @return
	 */
	public static boolean isPeerScope(Element topicref) {
		if (topicref.hasAttribute(DITA_SCOPE_ATTNAME)) {
			String scopeValue = topicref.getAttribute(DITA_SCOPE_ATTNAME);
			if (scopeValue.equals(DITA_SCOPE_ATTVALUE_PEER))
				return true;
			if (scopeValue.equals(DITA_SCOPE_ATTVALUE_LOCAL) ||
			    scopeValue.equals(DITA_SCOPE_ATTVALUE_EXTERNAL))
				return false;
			log.warn("Unrecognized value \"" + scopeValue + "\" for @" + DITA_SCOPE_ATTNAME + " attribute. Using 'local'"); 
		}
		return false; // default scope is "local"
	}

	/**
	 * Return true if the linking element specifies a, explcitly or implicitly, a
	 * DITA map or topic document.
	 * @param link An element that may exhibit the format attribute
	 * @return
	 */
	public static boolean targetIsADitaFormat(Element link) {
		if (link.hasAttribute(DITA_FORMAT_ATTNAME)) {
			String formatValue = link.getAttribute(DITA_FORMAT_ATTNAME);
			if (!"dita".equalsIgnoreCase(formatValue) && !"ditamap".equalsIgnoreCase(formatValue))
				return false;
		}
		return true; // default format is "dita"
		
	} 
	
	/**
	 * Returns true if the topicref specifies format="ditamap"
	 * @param topicref
	 * @return
	 */
	public static boolean targetIsADitaMap(Element topicref) {
		if (topicref.hasAttribute(DITA_FORMAT_ATTNAME)) {
			String formatValue = topicref.getAttribute(DITA_FORMAT_ATTNAME);
			if ("ditamap".equalsIgnoreCase(formatValue))
				return true;
		}
		return false;
	}
	
	public static NodeList getKeyDefinitions(Element mapElem) {
		NodeList resultNl = null;
		try {
			resultNl = (NodeList)allKeyDefs.evaluate(mapElem, XPathConstants.NODESET);
		} catch (XPathExpressionException e) {
			throw new RuntimeException("Unexpected exception evaluating XPath expression " + allKeyDefs.toString(), e);
		}
		return resultNl;
		
	}

	/**
	 * @param doc
	 * @param fragId
	 * @return
	 */
	public static Element resolveDitaFragmentId(Document doc, String fragId) {
		String topicId = null;
		String elemId = null;
		if (fragId.contains("/")) {
			String[] parts = fragId.split("/");
			topicId = parts[0];
			elemId = parts[1];
		} else {
			topicId = fragId;
		}
		// FIXME: Use xpaths to resolve the IDs as appropriate
		throw new NotImplementedException();
	}

	/**
	 * @param doc
	 * @return
	 */
	public static Element getImplicitElementFromDoc(Document doc) {
		// FIXME: Handle "first topic child of root" rule for non-topic elements.
		return doc.getDocumentElement();
	}

	/**
	 * @param keydefElem
	 * @return
	 */
	public static DitaPropsSpec constructPropsSpec(Element elem) {
		Element docElem = elem.getOwnerDocument().getDocumentElement();
		String domainsAtt = docElem.getAttribute("domains");
		DitaPropsSpec propsSpec = new DitaPropsSpec();
		String[] propsAtts = getPropsAtts(domainsAtt);
		for (String propName : propsAtts) {
			if (elem.hasAttribute(propName)) {
				String attval = elem.getAttribute(propName);
				if (attval.contains("(")) {
					parseGeneralizedPropsValue(attval, propsSpec);
				} else {
					String[] tokens = attval.split(" ");
					for (String propVal : tokens) {
						propsSpec.addPropValue(propName, propVal);
					}
				}
				
			}
		}
		return propsSpec;
	}

	/**
	 * @param attval
	 * @param propsSpec
	 */
	private static void parseGeneralizedPropsValue(String attval,
			DitaPropsSpec propsSpec) {
		throw new NotImplementedException();
	}

	/**
	 * @param domainsAtt
	 * @return
	 */
	private static String[] getPropsAtts(String domainsAtt) {
		List<String> propsAtts = new ArrayList<String>();
		String[] result = new String[propsAtts.size()];
		propsAtts.addAll(BASE_PROPS_ATTS);
		if (domainsAtt == null)
			return propsAtts.toArray(result);
		char c;
		int p = 0;
		while (p < domainsAtt.length()) {
			c = domainsAtt.charAt(p);
			switch (c) {
			case ' ':
			case '\t':
				p++;
				break;
			case '(':
				p = parseParens(domainsAtt, ++p);
				break;
			case 'a':
				p = parsePropsDomain(domainsAtt, ++p, propsAtts);
				break;
			default:
				throw new RuntimeException("Unexpected character \"" + c + "\" at position " + p+1 + " in domains attribute value \"" + domainsAtt + "\"" +
						". Expected space, '(', or 'a'."); 
			}
		}
		result = new String[propsAtts.size()];
		return propsAtts.toArray(result);
	}

	/**
	 * @param domainsAtt
	 * @param i
	 * @param propsAtts
	 * @return
	 */
	private static int parsePropsDomain(String domainsAtt, int p,
			List<String> propsAtts) {
		if (p >= domainsAtt.length()) {
			throw new RuntimeException("Unexpected end of string, expected '(' in domains attribute value \"" + domainsAtt + "\"");
		}
		char c = domainsAtt.charAt(p++);
		if (c != '(') {
			throw new RuntimeException("Expected '(' following 'a', found '" + c + "' at position " + p + " in domains attribute value \"" + domainsAtt + "\"");
		}
		StringBuilder buf = new StringBuilder();
		boolean done = false;
		while (!done && p < domainsAtt.length()) {
			c = domainsAtt.charAt(p);
			switch (c) {
			case ')':
				p++;
				done = true;
				break;
			default:
				buf.append(c);
				p++;
			}
		}
		if (!done) {
			throw new RuntimeException("Unexpected end of string, expected ')' in domains attribute value \"" + domainsAtt + "\"");
		}
		String[] tokens = buf.toString().trim().split(" ");
		if (tokens.length < 2) {
			throw new RuntimeException("Expected two tokens in attribute domain declaration, found " + tokens.length + " in domains attribute value \"" + domainsAtt + "\"");
		}
		if ("props".equals(tokens[0])) {
			propsAtts.add(tokens[tokens.length - 1]);
		}
		return p;
	}

	/**
	 * Scan to ")", return position following the ")".
	 * @param domainsAtt
	 * @param p
	 * @return position of character following the ")".
	 */
	private static int parseParens(String domainsAtt, int p) {
		char c = domainsAtt.charAt(p);
		while (p < domainsAtt.length()) {
			switch (c) {
			case ')':
				p++;
				break;
			default:
				p++;
			}
 		}
		return p;
	}


}

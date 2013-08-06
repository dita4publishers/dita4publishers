package net.sourceforge.dita4publishers.slideset;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFactoryConfigurationException;

import net.sf.saxon.om.NamespaceConstant;
import net.sourceforge.dita4publishers.slideset.datamodel.Div;
import net.sourceforge.dita4publishers.slideset.datamodel.Image;
import net.sourceforge.dita4publishers.slideset.datamodel.ListItem;
import net.sourceforge.dita4publishers.slideset.datamodel.OrderedList;
import net.sourceforge.dita4publishers.slideset.datamodel.Para;
import net.sourceforge.dita4publishers.slideset.datamodel.SimpleSlideSet;
import net.sourceforge.dita4publishers.slideset.datamodel.Slide;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideContainer;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideGroup;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideItem;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideNotes;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideSetProlog;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideSetStyles;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideStyle;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideTitle;
import net.sourceforge.dita4publishers.slideset.datamodel.Slides;
import net.sourceforge.dita4publishers.slideset.datamodel.StyleDefinition;
import net.sourceforge.dita4publishers.slideset.datamodel.TextRun;
import net.sourceforge.dita4publishers.slideset.datamodel.UnorderedList;
import net.sourceforge.dita4publishers.slideset.visitors.SlideBody;
import net.sourceforge.dita4publishers.slideset.visitors.SlideSetException;
import net.sourceforge.dita4publishers.slideset.visitors.SlideSetNsContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.xerces.jaxp.DocumentBuilderFactoryImpl;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Manages the creation of SlideSet instances from XML source data.
 * 
 */
public class SlideSetFactoryImpl
        implements SlideSetFactory {
    
    private static Log log = LogFactory.getLog(SlideSetFactoryImpl.class);
    private XPath xpath;
    
    public static final String TAGNAME_SIMPLESLIDESET = "simpleslideset";
    public static final String NS_NAME_SIMPLESLIDESET = "urn:ns:dita4publishers.org:doctypes:simpleslideset";

    public SlideSetFactoryImpl() throws XPathFactoryConfigurationException {
        super();
        System.setProperty("javax.xml.xpath.XPathFactory:"
                + NamespaceConstant.OBJECT_MODEL_SAXON,
                "net.sf.saxon.xpath.XPathFactoryImpl");
        XPathFactory xpathFactory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
        this.xpath = xpathFactory.newXPath();
        NamespaceContext nsContext = new SlideSetNsContext();
        xpath.setNamespaceContext(nsContext);
    }


    /**
     * Construct a slide set from a Simple Slide Set XML document.
     * @param slideSetXmlStream The input stream containing the XML document to be processed.
     * @return The constructed SlideSet
     * @throws Exception
     */
    public
            SimpleSlideSet
            constructSlideSet(
                    InputStream slideSetXmlStream) throws Exception {

        Document slideSetDoc = constructSlideSetXmlDocument(slideSetXmlStream);
        SimpleSlideSet slideSet = new SimpleSlideSet(
                slideSetDoc);
        Element root = slideSetDoc.getDocumentElement();

        Element prologElem = (Element) xpath.evaluate("/*/sld:prolog",
                root,
                XPathConstants.NODE);
        
        SlideSetProlog prolog = constructProlog(prologElem);
        slideSet.setProlog(prolog);

        Element stylesElem = (Element) xpath.evaluate("/*/sld:styles",
                root,
                XPathConstants.NODE);

        slideSet.setStyles(constructStyles(stylesElem));

        Element slidesElem = (Element) xpath.evaluate("/*/sld:slides",
                root,
                XPathConstants.NODE);
        Slides slides = new Slides(slidesElem);
        slideSet.setSlides(slides);
        constructSlideContainer(
                slides,
                slidesElem);
        return slideSet;
    }

    private
            void
            constructSlide(
                    Slide slide,
                    Element slideElem) throws Exception {
        Element titleNode = (Element) xpath.evaluate("sld:title",
                slideElem,
                XPathConstants.NODE);
        slide.setTitle(constructTitle(titleNode));
        Element bodyNode = (Element) xpath.evaluate("sld:slidebody",
                slideElem,
                XPathConstants.NODE);
        slide.setBody(constructBody(bodyNode));
        Element notesNode = (Element) xpath.evaluate("sld:slidenotes",
                slideElem,
                XPathConstants.NODE);
        slide.setNotes(contructNotes(notesNode));
    }

    private
            SlideNotes contructNotes(
                    Element notesNode) {
        if (notesNode == null) return null;
        SlideNotes notes = new SlideNotes(notesNode);
        notes.addChildren(constructContentItems(notesNode, false));
        return notes;
    }


    private
            SlideBody constructBody(
                    Element bodyNode) {
        SlideBody body = null;
    
        if (bodyNode != null) {
            body = new SlideBody(bodyNode);
            body.addChildren(constructContentItems(bodyNode, false));
        }
        return body;
    }


    private
            SlideSetStyles
            constructStyles(
                    Element stylesElem) throws XPathExpressionException {
        SlideSetStyles styles = new SlideSetStyles(
                stylesElem);
        NodeList nl;
        nl = (NodeList) xpath.evaluate("/*/sld:slideStyles",
                stylesElem,
                XPathConstants.NODESET);
        for (int i = 0; i < nl.getLength(); i++) {
            Element elem = (Element) nl.item(i);
            StyleDefinition style = new SlideStyle(
                    elem);
            String name = xpath.evaluate("string(./@name)",
                    elem);
            String type = "slideStyle";
            style.setId(type + "::"
                    + name);
            style.setName(name);
            // TODO: Capture the properties.
            styles.addStyle(style);
        }
        return styles;
    }

    private
            SlideSetProlog
            constructProlog(
                    Element prologElem) {
        return new SlideSetProlog(
                prologElem);
    }

    protected
            Document
            constructSlideSetXmlDocument(InputStream inStream) throws ParserConfigurationException,
                    IOException,
                    SAXException,
                    SlideSetException {
        DocumentBuilderFactory factory = DocumentBuilderFactoryImpl.newInstance();
        factory.setNamespaceAware(true);
        factory.setValidating(false);
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document slideSetDoc = builder.parse(inStream);
        Element root = slideSetDoc.getDocumentElement();
        NodeList cands = slideSetDoc.getElementsByTagNameNS(NS_NAME_SIMPLESLIDESET,
                TAGNAME_SIMPLESLIDESET);
        if (cands.getLength() == 0) {
            throw new SlideSetException(
                    "Failed to find expected root element {"
                            + NS_NAME_SIMPLESLIDESET
                            + "}"
                            + TAGNAME_SIMPLESLIDESET
                            + ". Found \""
                            + (root.getNamespaceURI() == null
                                    ? ""
                                    : "{"
                                            + root.getNamespaceURI()
                                            + "}")
                            + root.getLocalName()
                            + "\"");
        }
        return slideSetDoc;
    }

    /**
     * Processes a &lt;slides element to construct the
     * slides or slide groups in it.
     * @param slides The slide container to put stuff in.
     * @param slidesElem The data source for the slides.
     * @throws Exception
     */
    private
            void
            constructSlideContainer(
                    SlideContainer slides,
                    Element slidesElem) throws Exception {
        NodeList nl = slidesElem.getChildNodes();
        for (int i = 0; i < nl.getLength(); i++) {
            Node node = nl.item(i);
            if (node.getNodeType() != Node.ELEMENT_NODE)
                continue;
            // Node should be either sld:slide or sld:slidegroup
            Element elem = (Element) node;
            if (!NS_NAME_SIMPLESLIDESET.equals(elem.getNamespaceURI())) {
                log.warn("Found non-SLD namespace element: {"
                        + elem.getNamespaceURI()
                        + "}:"
                        + elem.getLocalName());
                continue;
            }
            if ("slidegroup".equals(elem.getLocalName())) {
                SlideGroup slideGroup = new SlideGroup(
                        elem);
                slideGroup.setParent(slides);
                Element titleNode = (Element) xpath.evaluate("sld:title",
                        elem,
                        XPathConstants.NODE);
                SlideTitle title = constructTitle(titleNode);
                // Groups may have titles
                slideGroup.setTitle(title);
                slides.add(slideGroup);
                constructSlideContainer(slideGroup,
                        elem);
            } else if ("slide".equals(elem.getLocalName())) {
                Slide slide = new Slide(
                        elem);
                slides.add(slide);
                constructSlide(slide,
                        elem);
                slide.setParent(slides);
            } else {
                log.warn("Unexpected element "
                        + elem.getNodeName()
                        + ", ignoring it.");
            }

        }
    }

    /**
     * Constructs a Title object
     * @param titleNode The data source for the title.
     * @return The Title instance
     */
    private
            SlideTitle constructTitle(
                    Element titleNode) {
        SlideTitle title = new SlideTitle(titleNode);
        title.addChildren(constructContentItems(titleNode));
        return title;
    }

    /**
     * Constructs objects expected in the content of things, e.g., 
     * paragraphs, lists, text nodes, etc. Any DOM text nodes will
     * result in TextRun objects in the slide.
     * @param rootNode The root element whose children will be processed.
     * @return List, possibly empty, of content objects.
     */
    private
            List<SlideItem>
            constructContentItems(
                    Element rootNode) {
        boolean includeTextNodes = true;
        return constructContentItems(rootNode, includeTextNodes);
    }

    /**
     * Constructs objects expected in the content of things, e.g., 
     * paragraphs, lists, etc.
     * @param rootNode The root element whose children will be processed.
     * @param includeTextNodes If true, include text nodes in the DOM as text runs,
     * otherwise ignore them.
     * @return List, possibly empty, of content objects.
     */
    private
            List<SlideItem>
            constructContentItems(
                    Element rootNode,
                    boolean includeTextNodes) {
        
        List<SlideItem> contentItems = new ArrayList<SlideItem>();
        NodeList nl = rootNode.getChildNodes();
        for (int i = 0; i < nl.getLength(); i++) {
            Node node = nl.item(i);           
            SlideItem item = null;
            // FIXME: Need to figure out how to only care about text nodes in the 
            // context of elements that may contain text, e.g., p, li, text, etc.
            
            switch (node.getNodeType()) {
            case Node.TEXT_NODE:
                if (!includeTextNodes) continue;
                String text = node.getTextContent();
                // If text node is first or last and contains only white space
                // then don't keep it.
                String trimmed = text.trim();
                if ((i == 0 || i == nl.getLength() - 1)  && "".equals(trimmed)) {
                    break;
                }
                item = new TextRun(text);
                contentItems.add(item);
                break;
            case Node.ELEMENT_NODE:
                Element elem = (Element)node;
                if (!NS_NAME_SIMPLESLIDESET.equals(elem.getNamespaceURI())) {
                    log.warn("Found non-SLD namespace element: {"
                            + elem.getNamespaceURI()
                            + "}:"
                            + elem.getLocalName());
                    continue;
                }
                if ("p".equals(elem.getLocalName())) {
                    item = new Para(elem);
                } else if ("ul".equals(elem.getLocalName())) {
                    item = new UnorderedList(elem);
                } else if ("ol".equals(elem.getLocalName())) {
                    item = new OrderedList(elem);
                } else if ("li".equals(elem.getLocalName())) {
                    item = new ListItem(elem);
                } else if ("div".equals(elem.getLocalName())) {
                    item = new Div(elem);
                    if (elem.hasAttribute("outputclass")) {
                        item.setStyleName(elem.getAttribute("outputclass"));
                    }
                } else if ("image".equals(elem.getLocalName())) {
                    item = new Image(elem);
                    // The @href value needs to be an absolute URL.
                    String href = elem.getAttribute("href");
                    try {
                        ((Image)item).setImageUrl(href);
                    } catch (MalformedURLException e) {
                        log.error("MalformedURLException from URL string \"" + href + "\": " + e.getMessage());
                    }
                } else if ("inline".equals(elem.getLocalName())) {
                    item = new TextRun(elem);
                    if (elem.hasAttribute("style")) {
                        ((SlideItem)item).setStyleName(elem.getAttribute("style"));
                    }
                    // NOTE: Inline can only contain text.
                    
                } else {
                    log.warn("constructContentItems(): Unexpected element " + elem.getLocalName());
                    continue;
                }
                contentItems.add(item);
                item.addChildren(constructContentItems(elem));
                break;
            default:
                // Ignore 
            }
        }
        return contentItems;
    }


    /**
     * Creates the in-memory model of the slide set from the XML.
     * 
     * @throws Exception
     */
    private void constructSlideSetObjects(Document slideSetDoc) throws Exception {
        SimpleSlideSet slideSet = new SimpleSlideSet(slideSetDoc);
        Element root = slideSetDoc.getDocumentElement();

        Element prologElem = (Element) this.xpath.evaluate("/*/sld:prolog",
                root,
                XPathConstants.NODE);
        SlideSetProlog prolog = constructProlog(prologElem);
        slideSet.setProlog(prolog);

        Element stylesElem = (Element) xpath.evaluate("/*/sld:styles",
                root,
                XPathConstants.NODE);
        SlideSetStyles styles = constructStyles(stylesElem);
        slideSet.setStyles(styles);

        Element slidesElem = (Element) xpath.evaluate("/*/sld:slides",
                root,
                XPathConstants.NODE);
        Slides slides = new Slides(
                slidesElem);
        slideSet.setSlides(slides);
        constructSlideContainer(slides,
                slidesElem);
    }

    public static
            SlideSetFactory
            newInstance() throws Exception {
        return new SlideSetFactoryImpl();
    }

}

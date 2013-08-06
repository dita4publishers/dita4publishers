package net.sourceforge.dita4publishers.slideset.visitors;

import java.io.IOException;
import java.io.InputStream;

import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;

import net.sf.saxon.om.NamespaceConstant;
import net.sourceforge.dita4publishers.slideset.SlideSetFactory;
import net.sourceforge.dita4publishers.slideset.SlideSetFactoryImpl;
import net.sourceforge.dita4publishers.slideset.SlideSetVisitor;
import net.sourceforge.dita4publishers.slideset.datamodel.SimpleSlideSet;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;


public class SlideSetVisitorBase implements SlideSetVisitor {

//    private static Log log = LogFactory.getLog(SlideSetVisitorBase.class);

    private Document slideSetDoc;
    private SimpleSlideSet slideSet;
    private XPathFactory xpathFactory;
    private XPath xpath;

    public SlideSetVisitorBase() throws Exception {
        super();
        System.setProperty(
                "javax.xml.xpath.XPathFactory:"
                        + NamespaceConstant.OBJECT_MODEL_SAXON,
                "net.sf.saxon.xpath.XPathFactoryImpl");
        this.xpathFactory = XPathFactory
                .newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
        this.xpath = this.xpathFactory.newXPath();
        NamespaceContext nsContext = new SlideSetNsContext();
        xpath.setNamespaceContext(nsContext);

    }

    @Override
    public void generatePresentation(InputStream slideSetXmlUrl)
            throws SlideSetException, ParserConfigurationException,
            IOException, SAXException {
        try {
            SlideSetFactory factory = SlideSetFactoryImpl.newInstance();
            this.slideSet = factory.constructSlideSet(slideSetXmlUrl);
        } catch (Exception e) {
            throw new SlideSetException(
                    e.getClass().getSimpleName() + ": " + e.getMessage(),
                    e);
        }
    }

    @Override
    public Document getSlideSetDocument() {
        return slideSetDoc;
    }

    public SimpleSlideSet getSlideSet() {
        return this.slideSet;
    }

}
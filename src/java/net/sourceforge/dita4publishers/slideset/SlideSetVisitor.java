package net.sourceforge.dita4publishers.slideset;

import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.ParserConfigurationException;

import net.sourceforge.dita4publishers.slideset.visitors.SlideSetException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;


/**
 * Interface for visitor/walker classes that operate on simple slide set XML
 * files to generate some form of result presentation, e.g., PowerPoint.
 * 
 */
public interface SlideSetVisitor {
    
    public Document getSlideSetDocument();

    /**
     * Visit the XML document that contains the slide set. This is normally the
     * initial visit method called.
     * 
     * @param inputStream The XML document that contains the slide set. Should
     *        use the simpleslideset schema.
     * @throws ParserConfigurationException
     * @throws IOException
     * @throws SAXException
     * @throws SlideSetException 
     */
    void generatePresentation(InputStream inputStream) 
            throws ParserConfigurationException,
            IOException, 
            SAXException, 
            SlideSetException, Exception;
    
}

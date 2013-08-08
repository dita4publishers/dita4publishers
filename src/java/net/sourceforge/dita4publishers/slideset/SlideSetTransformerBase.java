package net.sourceforge.dita4publishers.slideset;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.FeatureKeys;
import net.sf.saxon.s9api.Destination;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltTransformer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.xml.resolver.CatalogManager;
import org.apache.xml.resolver.tools.CatalogResolver;
import org.w3c.dom.Document;
import org.xml.sax.EntityResolver;
import org.xml.sax.SAXException;

/**
 * Utility class that manages the full DITA-to-slideset-to-slides transformation
 * process.
 */
public abstract class SlideSetTransformerBase implements SlideSetTransformer {

    private InputStream ditaMapStream;
    // The log may be overriden by subclasses.
    protected Log log = LogFactory.getLog(SlideSetTransformerBase.class);
    private DocumentBuilder docBuilder;
    private OutputStream resultStream;
    private Source slideSetTransformSource;
    private Map<QName, XdmAtomicValue> slideSetTransformParams;
    private boolean debug;
    private URIResolver uriResolver;
    private EntityResolver entityResolver;
    private String[] catalogs;
    private String mapSystemId; 
    
    public SlideSetTransformerBase() throws ParserConfigurationException {
        docBuilder = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder();
        docBuilder.setEntityResolver(entityResolver);
        this.resultStream = new ByteArrayOutputStream();
    }

    public SlideSetTransformerBase(
            InputStream mapStream,
            String mapSystemId) throws ParserConfigurationException {
        this();
        this.ditaMapStream = mapStream;
        this.mapSystemId = mapSystemId;
    }

    /**
     * Construct the transformer with the map source and result output stream.
     * @param mapSource Source providing the DITA map to process.
     * @param resultStream Output stream to hold the primary result.
     * @throws ParserConfigurationException
     */
    public SlideSetTransformerBase(
            InputStream mapStream,
            String mapSystemId,
            OutputStream resultStream) throws ParserConfigurationException {
        this(mapStream, mapSystemId);
        this.resultStream = resultStream;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#setDitaMap(java.net.URL)
     */
    @Override
    public
            void setDitaMap(
                    URL ditaMapUrl) throws IOException {
        this.ditaMapStream = ditaMapUrl.openStream();
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#setLog(org.apache.commons.logging.Log)
     */
    @Override
    public
            void setLog(
                    Log log) {
        this.log = log;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#setDocumentBuilder(javax.xml.parsers.DocumentBuilder)
     */
    @Override
    public
            void
            setDocumentBuilder(
                    DocumentBuilder docBuilder) {
        this.docBuilder = docBuilder;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#getResultStream()
     */
    @Override
    public
            OutputStream
            getResultStream() {
        return this.resultStream;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#setResultStream(java.io.OutputStream)
     */
    @Override
    public
            void
            setResultStream(
                    OutputStream resultStream) {
        this.resultStream = resultStream;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#getDocumentBuilder()
     */
    @Override
    public
            DocumentBuilder getDocumentBuilder() {
        return this.docBuilder;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#getMapSource()
     */
    @Override
    public
            Source getMapSource() throws Exception {
        Document doc = this.docBuilder.parse(this.ditaMapStream); 
        DOMSource domSource = new DOMSource(doc);
        domSource.setSystemId(mapSystemId);
        return domSource;

    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#transform()
     */
    @Override
    public abstract
            void transform() throws Exception;
    
    protected XsltCompiler getSaxonXsltCompiler() throws Exception {
        Processor proc = new Processor(false); // Not schema aware.
        proc.setConfigurationProperty(FeatureKeys.DTD_VALIDATION, false);
        proc.setConfigurationProperty(FeatureKeys.LINE_NUMBERING, true);
        XsltCompiler compiler = proc.newXsltCompiler();
        return compiler;
    }

    protected
            void
            setupResolver(
                    String[] catalogs) {
        CatalogResolver resolver = null;
        if (catalogs != null && catalogs.length > 0) {
            String catalogList = catalogs[0];
            for (int i = 1; i < catalogs.length; i++) {
                catalogList += ";" + catalogs[i];
            }
            System.out.println("+ [INFO] Using catalog files: " + catalogList);

            CatalogManager manager = new CatalogManager();
            manager.setCatalogFiles(catalogList);
            manager.setRelativeCatalogs(true);
            manager.setPreferPublic(true);
            resolver = new CatalogResolver(manager);
        }
        this.uriResolver = resolver;
        this.entityResolver = resolver;
        
    }

    @Override
    public
            String[] getCatalogs() {
        return this.catalogs;
    }

    @Override
    public
            Source
            getMapToSlideSetTransformSource() {
                return this.slideSetTransformSource;
            }

    @Override
    public
            void
            setSlideSetTransformSource(
                    Source source,
                    Map<QName, XdmAtomicValue> params) {
        this.slideSetTransformSource = source; 
        this.slideSetTransformParams = params;
                        
    }

    protected
            void
            generateSlideSetXml(
                    Destination xsltResult) throws Exception,
                    SaxonApiException {
                        XsltCompiler xsltCompiler = getSaxonXsltCompiler();
                        Source xsltSource = getMapToSlideSetTransformSource();
                        if (xsltSource == null) {
                            throw new Exception("DITA-to-SlideSet transform source not set.");
                        }
                        XsltTransformer xsltTransform = xsltCompiler.compile(xsltSource).load();
                        xsltTransform.setDestination(xsltResult);
                        xsltTransform.setSource(getMapSource());  
                        xsltTransform.getUnderlyingController()
                            .setURIResolver(uriResolver);
                        
                        if (this.slideSetTransformParams != null) {
                            for (Entry<QName, XdmAtomicValue> entry : slideSetTransformParams.entrySet()) {
                                xsltTransform.setParameter(
                                        entry.getKey(), 
                                        entry.getValue());
                            }
                        }
                        xsltTransform.transform();
                    }

    @Override
    public
            void setDebug(
                    boolean isDebug) {
                        this.debug = isDebug;
                    }

    @Override
    public
            boolean getDebug() {
                return this.debug;
            }

    @Override
    public
            void
            setUriResolver(
                    URIResolver resolver) {
                        this.uriResolver = resolver;
                        
                    }

    public
            void setCatalogs(
                    String[] catalogs) {
                        this.catalogs = catalogs;
                        setupResolver(catalogs);
                        this.docBuilder.setEntityResolver(entityResolver);
                    }


}

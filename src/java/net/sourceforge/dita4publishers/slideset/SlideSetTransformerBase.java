package net.sourceforge.dita4publishers.slideset;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
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
import org.apache.xerces.util.XMLCatalogResolver;
import org.apache.xml.resolver.CatalogManager;
import org.apache.xml.resolver.tools.CatalogResolver;
import org.xml.sax.EntityResolver;

/**
 * Utility class that manages the full DITA-to-slideset-to-slides transformation
 * process.
 */
public abstract class SlideSetTransformerBase implements SlideSetTransformer {

    private Source ditaMapSource;
    // The log may be overriden by subclasses.
    protected Log log = LogFactory.getLog(SlideSetTransformerBase.class);
    private DocumentBuilder docBuilder;
    private OutputStream resultStream;
    private Source slideSetTransformSource;
    private Map<QName, XdmAtomicValue> slideSetTransformParams;
    private boolean debug;
    private URIResolver uriResolver;
    private String[] catalogs; 
    
    public SlideSetTransformerBase() throws ParserConfigurationException {
        docBuilder = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder();
        this.resultStream = new ByteArrayOutputStream();
    }

    public SlideSetTransformerBase(Source mapSource) throws ParserConfigurationException {
        this();
        this.ditaMapSource = mapSource;
    }

    /**
     * Construct the transformer with the map source and result output stream.
     * @param mapSource Source providing the DITA map to process.
     * @param resultStream2 Output stream to hold the primary result.
     * @throws ParserConfigurationException
     */
    public SlideSetTransformerBase(
            Source mapSource,
            OutputStream resultStream2) throws ParserConfigurationException {
        this(mapSource);
        this.resultStream = resultStream2;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#setDitaMap(java.net.URL)
     */
    @Override
    public
            void setDitaMap(
                    URL ditaMapUrl) throws IOException {
        this.ditaMapSource = new StreamSource(ditaMapUrl.openStream());
    }

    /* (non-Javadoc)
     * @see net.sourceforge.dita4publishers.slideset.SlideSetTransformer#setDitaMap(javax.xml.transform.Source)
     */
    @Override
    public
            void setDitaMap(
                    Source mapSource) {
        this.ditaMapSource = mapSource;
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
            Source getMapSource() {
        return this.ditaMapSource;
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
        String[] catalogs = getCatalogs();
        if (catalogs != null && catalogs.length > 0) {
            String catalogList = catalogs[0];
            for (int i = 1; i < catalogs.length; i++) {
                catalogList += ";" + catalogs[i];
            }
            CatalogManager manager = new CatalogManager();
            manager.setCatalogFiles(catalogList);
            manager.setRelativeCatalogs(true);
            manager.setPreferPublic(true);
            EntityResolver resolver = new XMLCatalogResolver(catalogs);
            if (log.isDebugEnabled()) {
                // Capture timing and file output info.
                proc.setConfigurationProperty(FeatureKeys.TIMING, true);
            }
        }
        XsltCompiler compiler = proc.newXsltCompiler();
        if (uriResolver != null) {
            compiler.setURIResolver(uriResolver);
        }
        return compiler;
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
                        if (this.uriResolver != null) {
                            xsltTransform.getUnderlyingController().setURIResolver(uriResolver);
                        }
                        xsltTransform.setDestination(xsltResult);
                        xsltTransform.setSource(getMapSource());                        
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
                    }


}

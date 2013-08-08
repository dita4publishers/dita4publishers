package net.sourceforge.dita4publishers.slideset;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.transform.Source;
import javax.xml.transform.URIResolver;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmAtomicValue;

import org.apache.commons.logging.Log;
import org.apache.xml.resolver.CatalogManager;

public interface SlideSetTransformer {

    /**
     * Set the URL of the DITA map to be processed into slides.
     * The URL will be used to create a Source instance.
     * @param ditaMapUrl The URL of the input DITA map
     * @throws IOException If the openStream() method on the URL fails.
     */
    public abstract
            void
            setDitaMap(
                    URL ditaMapUrl) throws IOException;

    /**
     * Set the log to use for logging.
     * @param log The log to use.
     */
    public abstract
            void setLog(
                    Log log);

    /**
     * Set the document builder to use for parsing the source document (and any
     * intermediate XML documents). The default builder is the one returned
     * by the Java-configured document builder factory. 
     * @param docBuilder The document builder to use.
     */
    public abstract
            void
            setDocumentBuilder(
                    DocumentBuilder docBuilder);

    /**
     * Gets the output stream that will contain the primary result of the transform,
     * e.g., the PPTX slide deck or Zip file or manifest document, whatever the result
     * is.
     * @return The output stream. The default stream is a {@link ByteArrayOutputStream}
     */
    public abstract
            OutputStream
            getResultStream();

    /**
     * Set the result stream to use for the output.
     * <p>The default result stream is a {@link ByteArrayOutputStream}.
     * @param resultStream The result stream to use for the primary output.
     */
    public abstract
            void
            setResultStream(
                    OutputStream resultStream);

    /**
     * Get the document builder used to parse the input document and
     * intermediate documents.
     * @return The document builder.
     */
    public abstract
            DocumentBuilder
            getDocumentBuilder();

    /**
     * Gets the DITA map {@link Source} set on the transformer.
     * @return The source. Will be null if not yet set. 
     * @throws Exception 
     */
    public abstract
            Source getMapSource() throws Exception;

    /**
     * Does the transform. The input is the map source, the primary
     * result will be in the result output stream.
     */
    public abstract
            void
            transform() throws Exception;

    /**
     * Get the Source for the DITA-to-SlideSet transform.
     * @return The transform source, or null if not set.
     */
    public
    Source
    getMapToSlideSetTransformSource();

    /**
     * Set the source for the DITA-to-SlideSet XML XSLT transform.
     * @param xsltSource The source of the XSLT transform to run
     * @param params Map of parameters to set on the transform.
     */
    public abstract
            void
            setSlideSetTransformSource(
                    Source xsltSource,
                    Map<QName, XdmAtomicValue> params);
    
    /**
     * Turn debugging on or off. When debugging is on, intermediate
     * files will be saved and additional loggging messages will be
     * emitted.
     * @param isDebug
     */
    public void setDebug(boolean isDebug);

    /**
     * Get the value of the debug flag.
     * @return The debug value.
     */
    public abstract
            boolean getDebug();

    /**
     * Set the input stream that provides the base PPTX presentation
     * from which the new presentation will be constructed.
     * The base presentation provides slide masters.
     * @param basePresentationStream Input stream providing the bytes of
     * the base PPTX presentation.
     */
    public abstract
            void
            setBasePresentation(
                    InputStream basePresentationStream);

    /**
     * Set the URI resolver to use when parsing XML or
     * processing XSLT style sheets. If not set, the built-in
     * resolvers are used.
     * @param resolver The resolver to use.
     */
    public abstract
            void
            setUriResolver(URIResolver resolver);

    /**
     * Gets the list of catalog file paths set for the transformer.
     * @return Array, possibly null, of catalog file paths (see {@link CatalogManager}).
     */
    String[] getCatalogs();
}
package net.sourceforge.dita4publishers.slideset;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmAtomicValue;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;

public class TestSlideSetTransformer {

    @Test
    public
            void testSlideSetTransformer() throws Throwable {
        
        URL ditaMapUrl = this.getClass()
                .getClassLoader()
                .getResource(
                        "resources/slidesets/slideset-test/slide-set-test-01.ditamap");
        assertNotNull(
                "Didn't find input DITA map",
                ditaMapUrl);
        URL basePresentationUrl = this.getClass()
                .getClassLoader()
                .getResource(
                        "resources/ppt/simple-slide-deck-01.pptx");
        assertNotNull(
                "Didn't find template PPTX file",
                basePresentationUrl);

        // FIXME: This is a hack for immediate testing. Not sure how to get around this
        // for unit testing purposes. Propbably with a system property
        
        URL ditaToSlideSetXsltUrl = 
                new URL("file:///Users/ekimber/workspace_40/dita4publishers_slideset/toolkit_plugins/net.sourceforge.dita4publishers.slideset/xsl/map2slidesetImpl.xsl");
        assertNotNull(ditaToSlideSetXsltUrl);
        
        Log log = LogFactory.getLog("slidesettransformer log");
        SlideSetTransformer transformer = new PPTXSlideSetTransformer();
        assertNotNull(transformer);
        transformer.setBasePresentation(basePresentationUrl.openStream());
        
        // We can provide our own log. The default is a normal class-specific log.
        transformer.setLog(log); // What rolls down stairs, alone or in pairs?
        
        // Different ways to set the input map:
        
        // By URL:
        transformer.setDitaMap(ditaMapUrl);
        
        // From a Source
        Source mapSource = new StreamSource(ditaMapUrl.openStream());
        mapSource.setSystemId(ditaMapUrl.toExternalForm());
        transformer.setDitaMap(mapSource);
        // Can also construct the transformer with the source:
        
        transformer = new PPTXSlideSetTransformer(
                mapSource, 
                ditaToSlideSetXsltUrl.openStream());
        Source candSource = transformer.getMapSource();
        assertNotNull(candSource);
        assertEquals(mapSource, candSource);
        
        // We can set the docBuilder if we need to use a custom one, e.g.,
        // an RSuite-aware document builder. Uses the default builder
        // if not explicitly set.
        DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder();
        transformer.setDocumentBuilder(docBuilder);
        assertEquals("Doc builder didn't match the one we set", docBuilder,
                transformer.getDocumentBuilder());
        
        URIResolver resolver = null;
        transformer.setUriResolver(resolver);
        
        ByteArrayOutputStream resultStream = transformer.getResultStream();
        assertNotNull(resultStream);
        assertTrue("Expected a ByteArrayOutputStream, got " + resultStream.getClass().getSimpleName(), 
                resultStream instanceof ByteArrayOutputStream);
        
        Map<QName, XdmAtomicValue> params = new HashMap<QName, XdmAtomicValue>();
        File tempFile = File.createTempFile("dita2pptx", "garbage");
        params.put(
                new QName("outdir"), 
                new XdmAtomicValue(tempFile.getParentFile().getAbsolutePath()));
        try {
            tempFile.delete();
        } catch (Exception e) {
        }

        transformer.setSlideSetTransformSource(
                new StreamSource(ditaToSlideSetXsltUrl.openStream()),
                params);

        resultStream = new ByteArrayOutputStream();
        
        transformer = new PPTXSlideSetTransformer(
                mapSource, 
                resultStream,
                basePresentationUrl.openStream());
        candSource = transformer.getMapSource();
        assertNotNull(candSource);
        OutputStream candStream = transformer.getResultStream();
        assertNotNull(candStream);
        assertEquals(resultStream, candStream);
        transformer.setLog(log);
        Source xsltSource = new StreamSource(ditaToSlideSetXsltUrl.openStream());
        xsltSource.setSystemId(ditaToSlideSetXsltUrl.toExternalForm());
        
        transformer.setSlideSetTransformSource(
                xsltSource, 
                params);
        
        // Now do the transform.
        transformer.setDebug(true);
        assertTrue("Expected debug to be true", transformer.getDebug());
        transformer.transform();
        
        ByteArrayOutputStream baos = (ByteArrayOutputStream)resultStream;
        assertTrue("Result stream is empty", baos.toByteArray().length > 0);
        File pptxFile = File.createTempFile("pptx-gen-test", ".pptx");
        IOUtils.copy(new ByteArrayInputStream(baos.toByteArray()), 
                new FileOutputStream(pptxFile));
        log.info("PPTX file written to " + pptxFile.getAbsolutePath());

    }

}

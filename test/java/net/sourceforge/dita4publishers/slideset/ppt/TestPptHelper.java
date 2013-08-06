package net.sourceforge.dita4publishers.slideset.ppt;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;

import junit.framework.TestCase;
import net.sourceforge.dita4publishers.slideset.SlideSetVisitor;
import net.sourceforge.dita4publishers.slideset.visitors.PPTXGeneratingSlideSetVisitor;

import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;

public class TestPptHelper extends
        TestCase {

    // @Test
    public
            void
            testCreatePowerpoint()
                    throws Exception {
        URL basePresentationUrl = this.getClass()
                .getClassLoader()
                .getResource(
                        "resources/ppt/simple-slide-deck-01.pptx");
        assertNotNull(
                "Didn't find template PPTX file",
                basePresentationUrl);
        URL slideSetXml = this.getClass()
                .getClassLoader()
                .getResource(
                        "resources/slidesets/slideset-test.xml");
        assertNotNull(
                "Didn't find slideset XML file",
                slideSetXml);

        
        PPTXGeneratingSlideSetVisitor pptxGeneratingSlideVisitor = 
                new PPTXGeneratingSlideSetVisitor(
                        basePresentationUrl.openStream());
        XMLSlideShow pptx = pptxGeneratingSlideVisitor.getPptx();
        assertNotNull(pptx);
        int initialSlideCount = pptx.getSlides().length;

        SlideSetVisitor slideVisitor = pptxGeneratingSlideVisitor;

        slideVisitor.generatePresentation(slideSetXml.openStream());

        XSLFSlide[] slides = pptx.getSlides();
        assertTrue(
                "expected more than "
                        + initialSlideCount
                        + " slides",
                slides.length > initialSlideCount);

        File newPPTX = File.createTempFile(
                "testppthelper-",
                ".pptx");
        FileOutputStream outStream = new FileOutputStream(
                newPPTX);
        pptx.write(outStream);
        outStream.close();
        System.out.println("New PPTX file is:\n"
                + newPPTX.getAbsolutePath());

    }


}
